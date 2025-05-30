package egovframework.example.service.impl;

import egovframework.example.model.Metadata;
import egovframework.example.repository.MetadataRepository;
import egovframework.example.service.MetadataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.postgresql.ds.PGSimpleDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class MetadataServiceImpl implements MetadataService {

    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Value("${spring.datasource.username}")
    private String dbUser;

    @Value("${spring.datasource.password}")
    private String dbPassword;

    private PGSimpleDataSource dataSource;

    private final MetadataRepository metadataRepository;
    
    private final JdbcTemplate jdbcTemplate;
    
    @PostConstruct
    public void init() {
        dataSource = new PGSimpleDataSource();
        dataSource.setURL(dbUrl);
        dataSource.setUser(dbUser);
        dataSource.setPassword(dbPassword);
        log.info("✅ MetadataServiceImpl: 데이터소스 초기화 완료");
    }

    @Override
    public void save(Metadata metadata) throws Exception {
        String sql = "INSERT INTO metadata (table_name, title, organization, start_date, end_date, created_at, category, region_type, region_column, date_column, search_columns, description, external_url, data_information) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, metadata.getTableName());
            pstmt.setString(2, metadata.getTitle());
            pstmt.setString(3, metadata.getOrganization());
            pstmt.setDate(4, java.sql.Date.valueOf(metadata.getStartDate()));  // startDate
            pstmt.setDate(5, java.sql.Date.valueOf(metadata.getEndDate()));    // endDate
            pstmt.setTimestamp(6, java.sql.Timestamp.valueOf(metadata.getCreatedAt()));  // createdAt
            pstmt.setString(7, metadata.getCategory());                        // category
            pstmt.setString(8, metadata.getRegionType());                      // regionType
            pstmt.setString(9, metadata.getRegionColumn());                    // regionColumn
            pstmt.setString(10, metadata.getDateColumn());                     // dateColumn
            pstmt.setString(11, metadata.getSearchColumns());                 // searchColumns
            pstmt.setString(12, metadata.getDescription());                   // description
            pstmt.setString(13, metadata.getExternalUrl());                   // externalUrl
            pstmt.setString(14, metadata.getDataInformation());               // dataInformation

            int result = pstmt.executeUpdate();
            log.info("✅ 메타데이터 저장 완료: {}건 - table={}, title={}, organization={}, startDate={}, endDate={} ",
                    result, metadata.getTableName(), metadata.getTitle(), metadata.getOrganization(), metadata.getStartDate(), metadata.getEndDate());
        } catch (SQLException e) {
            log.error("❌ 메타데이터 저장 실패", e);
            throw e;
        }
    }

    @Override
    public List<Metadata> findAll() throws Exception {
        List<Metadata> list = new ArrayList<>();
        String sql = "SELECT * FROM metadata ORDER BY created_at DESC";  // created_at 기준으로 정렬

        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Metadata metadata = Metadata.builder()
                        .id(rs.getLong("id"))
                        .tableName(rs.getString("table_name"))
                        .title(rs.getString("title"))
                        .organization(rs.getString("organization"))
                        .startDate(rs.getDate("start_date") != null ? rs.getDate("start_date").toLocalDate() : null)  // startDate null 처리
                        .endDate(rs.getDate("end_date") != null ? rs.getDate("end_date").toLocalDate() : null)      // endDate null 처리
                        .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)  // createdAt null 처리
                        .category(rs.getString("category") != null ? rs.getString("category") : "데이터 없음")  // category null 처리
                        .regionType(rs.getString("region_type") != null ? rs.getString("region_type") : "데이터 없음")  // region_type null 처리
                        .regionColumn(rs.getString("region_column") != null ? rs.getString("region_column") : "데이터 없음")  // region_column null 처리
                        .dateColumn(rs.getString("date_column") != null ? rs.getString("date_column") : "데이터 없음")  // date_column null 처리
                        .searchColumns(rs.getString("search_columns") != null ? rs.getString("search_columns") : "데이터 없음")  // search_columns null 처리
                        .description(rs.getString("description"))  // description null 처리
                        .externalUrl(rs.getString("external_url"))  // externalUrl null 처리
                        .dataInformation(rs.getString("data_information"))  // dataInformation null 처리
                        .build();
                list.add(metadata);
            }
        } catch (SQLException e) {
            log.error("❌ 메타데이터 조회 실패", e);
            throw e;
        }

        return list;
    }



    @Override
    public void update(Metadata metadata) throws Exception {
        String sql = "UPDATE metadata SET title = ?, organization = ?, start_date = ?, end_date = ?, created_at = ?, category = ?, region_type = ?, region_column = ?, date_column = ?, search_columns = ?, description = ?, external_url = ?, data_information = ? WHERE id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, metadata.getTitle());
            pstmt.setString(2, metadata.getOrganization());
            pstmt.setDate(3, java.sql.Date.valueOf(metadata.getStartDate()));  // startDate
            pstmt.setDate(4, java.sql.Date.valueOf(metadata.getEndDate()));    // endDate
            pstmt.setTimestamp(5, java.sql.Timestamp.valueOf(metadata.getCreatedAt()));  // createdAt
            pstmt.setString(6, metadata.getCategory());                        // category
            pstmt.setString(7, metadata.getRegionType());                      // regionType
            pstmt.setString(8, metadata.getRegionColumn());                    // regionColumn
            pstmt.setString(9, metadata.getDateColumn());                     // dateColumn
            pstmt.setString(10, metadata.getSearchColumns());                 // searchColumns
            pstmt.setString(11, metadata.getDescription());                   // description
            pstmt.setString(12, metadata.getExternalUrl());                   // externalUrl
            pstmt.setString(13, metadata.getDataInformation());               // dataInformation
            pstmt.setLong(14, metadata.getId());                              // id

            pstmt.executeUpdate();
            log.info("✅ 메타데이터 수정 완료 - id={}, title={}", metadata.getId(), metadata.getTitle());
        } catch (SQLException e) {
            log.error("❌ 메타데이터 수정 실패", e);
            throw e;
        }
    }


    @Override
    public void deleteById(Long id) throws Exception {
        String tableName = null;

        // 1. 삭제할 테이블 이름 조회
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT table_name FROM metadata WHERE id = ?")) {
            pstmt.setLong(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    tableName = rs.getString("table_name");
                } else {
                    throw new SQLException("❌ 해당 ID의 메타데이터를 찾을 수 없습니다: " + id);
                }
            }
        }

        // 2. 메타데이터 삭제
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM metadata WHERE id = ?")) {
            pstmt.setLong(1, id);
            pstmt.executeUpdate();
            log.info("✅ 메타데이터 삭제 완료: id={}", id);
        }

        // 3. 실제 테이블 삭제
        if (tableName != null && !tableName.trim().isEmpty()) {
            String dropSql = "DROP TABLE IF EXISTS " + tableName;
            try (Connection conn = dataSource.getConnection();
                 Statement stmt = conn.createStatement()) {
                stmt.executeUpdate(dropSql);
                log.info("✅ 실제 테이블 삭제 완료: {}", tableName);
            }
        }
    }
    
    @Override
    public List<List<String>> findTableData(String tableName) throws Exception {
        List<List<String>> rows = new ArrayList<>();

        String sql = "SELECT * FROM " + tableName;
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            // 헤더 추가
            List<String> headers = new ArrayList<>();
            for (int i = 1; i <= columnCount; i++) {
                headers.add(metaData.getColumnLabel(i));
            }
            rows.add(headers);

            // 데이터 행 추가
            while (rs.next()) {
                List<String> row = new ArrayList<>();
                for (int i = 1; i <= columnCount; i++) {
                    row.add(rs.getString(i));
                }
                rows.add(row);
            }
        } catch (SQLException e) {
            log.error("❌ 테이블 데이터 조회 실패", e);
            throw e;
        }

        return rows;
    }

    @Override
    public List<List<String>> fetchTableDataPreview(String tableName) {
        List<List<String>> data = new ArrayList<>();
        String sql = "SELECT * FROM " + tableName + " LIMIT 50"; // 상위 50개 데이터만 조회

        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            // 헤더 추가
            List<String> headers = new ArrayList<>();
            for (int i = 1; i <= columnCount; i++) {
                headers.add(metaData.getColumnLabel(i));
            }
            data.add(headers);

            // 데이터 행 추가
            while (rs.next()) {
                List<String> row = new ArrayList<>();
                for (int i = 1; i <= columnCount; i++) {
                    row.add(rs.getString(i));
                }
                data.add(row);
            }
        } catch (SQLException e) {
            log.error("❌ 미리보기 데이터 조회 실패", e);
            return Collections.emptyList(); // 오류 발생 시 빈 리스트 반환
        }

        return data;
    }
    

    @Override
    public Metadata findById(Long id) throws Exception {
        String sql = "SELECT * FROM metadata WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return Metadata.builder()
                        .id(rs.getLong("id"))
                        .tableName(rs.getString("table_name"))
                        .title(rs.getString("title"))
                        .organization(rs.getString("organization"))
                        .startDate(rs.getDate("start_date").toLocalDate())  // startDate
                        .endDate(rs.getDate("end_date").toLocalDate())      // endDate
                        .createdAt(rs.getTimestamp("created_at").toLocalDateTime()) // createdAt
                        .description(rs.getString("description"))           // description
                        .externalUrl(rs.getString("external_url"))         // externalUrl
                        .dataInformation(rs.getString("data_information")) // dataInformation
                        .build();
            } else {
                throw new SQLException("❌ 해당 ID의 메타데이터를 찾을 수 없습니다: " + id);
            }
        } catch (SQLException e) {
            log.error("❌ 메타데이터 단건 조회 실패", e);
            throw e;
        }
    }
    
   

    @Override
    public List<String> getDistinctCategories() {
        return metadataRepository.findDistinctCategories();
    }

    
    @Override
    public List<String> getTableNamesByCategory(String category) {
        String sql = "SELECT table_name FROM metadata WHERE category = ?";
        return jdbcTemplate.queryForList(sql, String.class, category);
    }
    
    @Override
    public List<Map<String, Object>> getTableData(String tableName) {
        List<Map<String, Object>> results = new ArrayList<>();

        String sql = "SELECT * FROM " + tableName;

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    row.put(metaData.getColumnLabel(i), rs.getObject(i));
                }
                results.add(row);
            }

        } catch (Exception e) {
            log.error("❌ 테이블 데이터 조회 실패", e);
        }

        return results;
    }

    @Override
    public List<String> getAllCategories() {
        String sql = "SELECT DISTINCT category FROM metadata ORDER BY category";
        return jdbcTemplate.queryForList(sql, String.class);
    }
    
    
    



}
