package egovframework.example.service.impl;

import egovframework.example.service.CsvService;
import lombok.extern.slf4j.Slf4j;
import org.postgresql.ds.PGSimpleDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.HashSet;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;

@Slf4j
@Service
public class CsvServiceImpl implements CsvService {

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
        log.info("✅ CsvServiceImpl 데이터소스 초기화 완료");
    }

    @Override
    public void createTableAndInsert(MultipartFile file, String tableName) throws Exception {
        tableName = sanitizeColumn(tableName);

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8));
             Connection conn = dataSource.getConnection()) {

            String headerLine = reader.readLine();
            if (headerLine == null || headerLine.trim().isEmpty()) {
                throw new IllegalArgumentException("CSV 파일의 헤더가 비어 있습니다.");
            }

            String[] headers = headerLine.split(",");
            for (int i = 0; i < headers.length; i++) {
                headers[i] = sanitizeColumn(headers[i]);
            }

            // 기존 컬럼 목록 조회
            Set<String> existingColumns = getTableColumns(tableName, conn);

            boolean tableExists = !existingColumns.isEmpty();
            boolean hasId = existingColumns.contains("id");

            // CREATE TABLE 쿼리 구성
            if (!tableExists) {
                StringBuilder createSql = new StringBuilder("CREATE TABLE " + tableName + " (");
                createSql.append("id SERIAL PRIMARY KEY, ");
                for (String column : headers) {
                    createSql.append(column).append(" TEXT, ");
                }
                createSql.setLength(createSql.length() - 2);
                createSql.append(");");
                log.info("✅ CREATE SQL = {}", createSql);
                try (Statement stmt = conn.createStatement()) {
                    stmt.execute(createSql.toString());
                }
            } else if (!hasId) {
                String alterSql = "ALTER TABLE " + tableName + " ADD COLUMN id SERIAL PRIMARY KEY;";
                log.info("✅ ALTER SQL = {}", alterSql);
                try (Statement stmt = conn.createStatement()) {
                    stmt.execute(alterSql);
                }
            }

            // INSERT 쿼리 구성
            StringBuilder insertSql = new StringBuilder("INSERT INTO " + tableName + " (");
            insertSql.append(String.join(", ", headers));
            insertSql.append(") VALUES (");
            insertSql.append("?,".repeat(headers.length));
            insertSql.setLength(insertSql.length() - 1);
            insertSql.append(");");

            log.info("✅ INSERT SQL = {}", insertSql);

            PreparedStatement pstmt = conn.prepareStatement(insertSql.toString());

            String line;
            while ((line = reader.readLine()) != null) {
                String[] values = line.split(",", -1);
                for (int i = 0; i < headers.length; i++) {
                    pstmt.setString(i + 1, (i < values.length) ? values[i] : null);
                }
                pstmt.executeUpdate();
            }

            log.info("✅ [{}] 테이블 생성 및 데이터 삽입 완료", tableName);
        }
    }

    private Set<String> getTableColumns(String tableName, Connection conn) {
        Set<String> columns = new HashSet<>();
        try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT column_name FROM information_schema.columns WHERE table_name = ?")) {
            stmt.setString(1, tableName.toLowerCase());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                columns.add(rs.getString("column_name"));
            }
        } catch (SQLException e) {
            log.warn("컬럼 목록 조회 실패 (무시): {}", e.getMessage());
        }
        return columns;
    }

    @Override
    public void saveCsvToDatabase(MultipartFile file, String dataType) {
        // 사용 안함
    }

    @Override
    public void updateTableWithCsv(MultipartFile file, String tableName) throws Exception {
        File tempFile = new File("C:/temp/uploads/" + file.getOriginalFilename());
        file.transferTo(tempFile);

        try (BufferedReader br = new BufferedReader(new FileReader(tempFile));
             Connection conn = dataSource.getConnection()) {

            conn.setAutoCommit(false);

            String headerLine = br.readLine();
            if (headerLine == null) throw new IllegalArgumentException("CSV 파일이 비어 있습니다.");
            String[] columns = headerLine.split(",");

            String line;
            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");
                if (values.length != columns.length) continue;

                StringBuilder sql = new StringBuilder("INSERT INTO ").append(tableName).append(" (");
                for (String col : columns) sql.append(sanitizeColumn(col)).append(",");
                sql.setLength(sql.length() - 1);
                sql.append(") VALUES (");
                for (int i = 0; i < values.length; i++) sql.append("?,");
                sql.setLength(sql.length() - 1);
                sql.append(") ON CONFLICT DO NOTHING");

                try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
                    for (int i = 0; i < values.length; i++) {
                        pstmt.setString(i + 1, values[i].trim());
                    }
                    pstmt.executeUpdate();
                }
            }
            conn.commit();
        }
    }

    @Override
    public void updateCsvToTable(MultipartFile file, String tableName) throws Exception {
        tableName = sanitizeColumn(tableName);

        try (
            BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8));
            Connection conn = dataSource.getConnection()
        ) {
            conn.setAutoCommit(false);

            // 1. 헤더 추출 및 컬럼 정리
            String headerLine = reader.readLine();
            if (headerLine == null || headerLine.trim().isEmpty()) {
                throw new IllegalArgumentException("CSV 파일에 헤더가 없습니다.");
            }

            String[] rawHeaders = headerLine.split(",");
            String[] headers = sanitizeColumns(rawHeaders);
            List<String[]> csvRows = new ArrayList<>();
            Set<String> csvIds = new HashSet<>();

            // 2. CSV 데이터 읽기
            String line;
            while ((line = reader.readLine()) != null) {
                String[] values = line.split(",", -1);
                csvRows.add(values);
                if (values.length > 0 && !values[0].isEmpty()) {
                    csvIds.add(values[0].trim()); // id assumed to be first column
                }
            }

            // 3. 현재 DB의 id 목록 조회
            Set<String> dbIds = new HashSet<>();
            try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM " + tableName);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dbIds.add(rs.getString("id"));
                }
            }

            // 4. INSERT & UPDATE
            String updateSql = buildUpdateSql(tableName, headers);
            String insertSql = buildInsertSql(tableName, headers);

            try (
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                PreparedStatement updateStmt = conn.prepareStatement(updateSql)
            ) {
                for (String[] row : csvRows) {
                    if (row.length == 0 || row[0].isEmpty()) continue;
                    String id = row[0].trim();

                    if (dbIds.contains(id)) {
                        for (int i = 0; i < headers.length; i++) {
                            updateStmt.setString(i + 1, i < row.length ? row[i] : null);
                        }
                        updateStmt.setString(headers.length + 1, id);
                        updateStmt.addBatch();
                    } else {
                        for (int i = 0; i < headers.length; i++) {
                            insertStmt.setString(i + 1, i < row.length ? row[i] : null);
                        }
                        insertStmt.addBatch();
                    }
                }
                insertStmt.executeBatch();
                updateStmt.executeBatch();
            }

            // 5. DELETE
            Set<String> idsToDelete = new HashSet<>(dbIds);
            idsToDelete.removeAll(csvIds);
            try (PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM " + tableName + " WHERE id = ?")) {
                for (String id : idsToDelete) {
                	deleteStmt.setInt(1, Integer.parseInt(id));
                    deleteStmt.addBatch();
                }
                deleteStmt.executeBatch();
            }

            conn.commit();
            log.info("✅ [{}] 테이블: INSERT={}, UPDATE={}, DELETE={}", tableName, csvRows.size() - dbIds.size(), dbIds.size(), idsToDelete.size());

        } catch (Exception e) {
            log.error("❌ 업로드 처리 중 오류", e);
            throw e;
        }
    }
    
    private String buildUpdateSql(String tableName, String[] headers) {
        StringBuilder sb = new StringBuilder("UPDATE ");
        sb.append(tableName).append(" SET ");
        for (int i = 1; i < headers.length; i++) { // 0번은 id이므로 제외
            sb.append(headers[i]).append(" = ?, ");
        }
        sb.setLength(sb.length() - 2); // 마지막 콤마 제거
        sb.append(" WHERE id = ?"); // WHERE 조건으로 id 사용
        return sb.toString();
    }



    private String buildInsertSql(String tableName, String[] headers) {
        StringBuilder sb = new StringBuilder("INSERT INTO ");
        sb.append(tableName).append(" (");
        sb.append(String.join(", ", headers));
        sb.append(") VALUES (");
        sb.append("?,".repeat(headers.length));
        sb.setLength(sb.length() - 1);
        sb.append(")");

        // ✅ id를 고정된 conflict 기준으로 설정
        sb.append(" ON CONFLICT (id) DO UPDATE SET ");
        for (String header : headers) {
            if (!header.equalsIgnoreCase("id")) {  // id는 업데이트 대상에서 제외
                sb.append(header).append(" = EXCLUDED.").append(header).append(", ");
            }
        }
        sb.setLength(sb.length() - 2); // 마지막 , 제거
        return sb.toString();
    }


    private String sanitizeColumn(String raw) {
        String sanitized = raw.trim()
                .replaceAll("[^a-zA-Z0-9_]", "_")
                .replaceAll("_+", "_")
                .replaceAll("^_+", "")
                .replaceAll("_+$", "")
                .toLowerCase();
        log.info("🎯 컬럼 변환: [{}] -> [{}]", raw, sanitized);
        return sanitized;
    }

    private String[] sanitizeColumns(String[] headers) {
        String[] sanitized = new String[headers.length];
        for (int i = 0; i < headers.length; i++) {
            sanitized[i] = sanitizeColumn(headers[i]);
        }
        return sanitized;
    }
}
