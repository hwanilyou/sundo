package egovframework.example.service.impl;

import egovframework.example.service.ShpService;
import lombok.extern.slf4j.Slf4j;
import org.postgresql.ds.PGSimpleDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

@Slf4j
@Service
public class ShpServiceImpl implements ShpService {

    private final String UPLOAD_DIR = "C:/temp/uploads/";

    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Value("${spring.datasource.username}")
    private String dbUser;

    @Value("${spring.datasource.password}")
    private String dbPassword;

    private PGSimpleDataSource dataSource;

    @PostConstruct
    public void init() {
        dataSource = new PGSimpleDataSource();
        dataSource.setURL(dbUrl);
        dataSource.setUser(dbUser);
        dataSource.setPassword(dbPassword);
        log.info("✅ 데이터베이스 연결 초기화 완료");
    }

    @Override
    public void importShpToPostGIS(MultipartFile file, String tableName) throws Exception {
        String uniqueDirName = tableName + "_" + UUID.randomUUID();
        File workingDir = new File(UPLOAD_DIR, uniqueDirName);
        if (!workingDir.mkdirs()) {
            throw new IOException("❌ 작업 디렉토리 생성 실패: " + workingDir.getAbsolutePath());
        }

        File zipFile = new File(workingDir, file.getOriginalFilename());
        file.transferTo(zipFile);
        log.info("📦 ZIP 파일 저장 완료: {}", zipFile.getAbsolutePath());

        unzip(zipFile, workingDir);
        log.info("📂 ZIP 압축 해제 완료");

        File shpFile = findShpFile(workingDir);
        if (shpFile == null) {
            throw new IllegalArgumentException("❌ SHP 파일이 존재하지 않습니다.");
        }

        checkShpSupportFiles(shpFile);

        registerShapefile(shpFile.getAbsolutePath(), tableName);
        log.info("🗘️ SHP 등록 명령어 실행 완료: {}", tableName);

        if (!checkTableExists(tableName)) {
            log.error("❌ 테이블 생성 실패 또는 PostGIS 반영 실패: {}", tableName);
            throw new RuntimeException("PostGIS에 테이블이 생성되지 않았습니다.");
        }

        addPrimaryKeyIfNotExist(tableName);
        log.info("✅ SHP 등록 및 기본키 설정 완료: {}", tableName);
    }

    private void unzip(File zipFile, File destDir) throws IOException {
        try (ZipInputStream zis = new ZipInputStream(new FileInputStream(zipFile))) {
            ZipEntry zipEntry;
            while ((zipEntry = zis.getNextEntry()) != null) {
                File newFile = new File(destDir, zipEntry.getName());
                if (zipEntry.isDirectory()) {
                    newFile.mkdirs();
                    continue;
                }
                try (FileOutputStream fos = new FileOutputStream(newFile)) {
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = zis.read(buffer)) > 0) {
                        fos.write(buffer, 0, len);
                    }
                }
            }
        }
    }

    private File findShpFile(File dir) {
        File[] files = dir.listFiles();
        if (files == null) return null;
        for (File file : files) {
            if (file.getName().toLowerCase().endsWith(".shp")) {
                return file;
            }
        }
        return null;
    }

    private void checkShpSupportFiles(File shpFile) {
        String baseName = shpFile.getName().substring(0, shpFile.getName().lastIndexOf("."));
        File dir = shpFile.getParentFile();
        String[] requiredExtensions = {".shx", ".dbf"};
        for (String ext : requiredExtensions) {
            File requiredFile = new File(dir, baseName + ext);
            if (!requiredFile.exists()) {
                throw new IllegalStateException("❌ 필수 파일 누락: " + requiredFile.getName());
            }
        }
    }

    private void registerShapefile(String shpPath, String tableName) throws IOException, InterruptedException {
        String[] encodings = {"UTF-8", "CP949", "LATIN1"};
        boolean success = false;

        for (String enc : encodings) {
            String command = String.format(
                    "shp2pgsql -c -s 5179 -W \"%s\" \"%s\" %s | psql -U %s -d sundo_data",
                    enc, shpPath, tableName, dbUser
            );

            log.info("🔁 인코딩 [{}]으로 shp2pgsql 실행 시도 중...", enc);
            log.info("📤 실행 명령어: {}", command);

            ProcessBuilder pb = new ProcessBuilder("cmd.exe", "/c", command);
            pb.redirectErrorStream(true);
            pb.environment().put("PGPASSWORD", dbPassword);

            Process process = pb.start();

            StringBuilder output = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line).append("\n");
                    log.info(line);
                }
            }

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                log.info("✅ shp2pgsql 실행 성공 (인코딩: {})", enc);
                success = true;
                break;
            } else {
                log.warn("⚠️ shp2pgsql 실행 실패 (인코딩: {}, 코드: {})", enc, exitCode);
                log.warn("🔻 출력 내용:\n{}", output);
            }
        }

        if (!success) {
            throw new RuntimeException("❌ 모든 인코딩 시도 실패: SHP 파일을 등록할 수 없습니다.");
        }
    }

    private boolean checkTableExists(String tableName) throws SQLException {
        String sql = "SELECT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = ?);";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tableName.toLowerCase());
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getBoolean(1);
        }
    }

    private void addPrimaryKeyIfNotExist(String tableName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM information_schema.table_constraints tc " +
                     "JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name " +
                     "WHERE tc.table_name = ? AND tc.constraint_type = 'PRIMARY KEY'";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tableName.toLowerCase());
            ResultSet rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) == 0) {
                String alterSQL = String.format("ALTER TABLE %s ADD COLUMN id SERIAL PRIMARY KEY", tableName);
                try (Statement alterStmt = conn.createStatement()) {
                    alterStmt.executeUpdate(alterSQL);
                    log.info("🔑 기본키(id) 컬럼 추가 완료: {}", tableName);
                }
            } else {
                log.info("✅ 테이블 '{}'에는 이미 기본키가 존재합니다.", tableName);
            }
        }
    }

    @Override
    public void updateTableWithShp(MultipartFile file, String tableName) throws Exception {
        // TODO: 구현 예정
    }
}
 