package egovframework.example.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.example.model.Metadata;
import egovframework.example.repository.MetadataRepository; // MetadataRepository 임포트
import egovframework.example.service.GeoServerWfsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;
import javax.sql.DataSource;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class GeoServerWfsServiceImpl implements GeoServerWfsService {

    private final String GEOSERVER_BASE_URL = "http://localhost:8282/geoserver/sundo3/ows";

    @Autowired
    private DataSource dataSource;
    
    @Autowired
    private MetadataRepository metadataRepository;  // MetadataRepository 주입

    // 기존 fetchFeatures 메소드 수정
    @Override
    public List<Map<String, Object>> fetchFeatures(String tableName, String dateColumn, String startDate, String endDate,
                                                   String location, int limit, int offset) {
        try {
            // 메타데이터 조회
            Metadata metadata = getMetadataForTable(tableName);  // 테이블에 대한 메타데이터 가져오기
            String organization = metadata != null ? metadata.getOrganization() : "";  // organization 값 확인

            // CQL 필터 생성
            String cqlFilter = buildCqlFilter(dateColumn, startDate, endDate, location, organization);

            // 요청 URL 생성
            String requestUrl = UriComponentsBuilder.fromHttpUrl(GEOSERVER_BASE_URL)
                    .queryParam("service", "WFS")
                    .queryParam("version", "1.0.0")
                    .queryParam("request", "GetFeature")
                    .queryParam("typeName", "sundo3:" + tableName)
                    .queryParam("outputFormat", "application/json")
                    .queryParam("maxFeatures", limit)
                    .queryParam("startIndex", offset)
                    .queryParam("cql_filter", cqlFilter)
                    .toUriString();

            log.info("📡 WFS 요청 URL: {}", requestUrl);

            HttpURLConnection conn = (HttpURLConnection) new URL(requestUrl).openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            InputStream inputStream = conn.getInputStream();
            String response = new BufferedReader(new InputStreamReader(inputStream))
                    .lines().collect(Collectors.joining("\n"));

            log.info("🌐 fetchFeatures 응답: {}", response);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response);
            JsonNode features = root.get("features");

            List<Map<String, Object>> result = new ArrayList<>();
            if (features != null && features.isArray()) {
                for (JsonNode feature : features) {
                    JsonNode props = feature.get("properties");
                    Map<String, Object> row = new HashMap<>();
                    props.fieldNames().forEachRemaining(field -> 
                            row.put(field, props.get(field).asText("")));

                    result.add(row);
                }
            }
            return result;

        } catch (Exception e) {
            log.error("❌ WFS 데이터 가져오기 실패", e);
            return Collections.emptyList();
        }
    }

    // getMetadataForTable 메소드 정의
    private Metadata getMetadataForTable(String tableName) {
        return metadataRepository.findByTableName(tableName).orElse(null);  // MetadataRepository에서 테이블 이름으로 메타데이터 조회
    }

    @Override
    public int countFeatures(String tableName, String dateColumn, String startDate, String endDate, String location) {
        try {
            String cqlFilter = buildCqlFilter(dateColumn, startDate, endDate, location, "");  // organization 값 없이 기본 필터 사용
            String requestUrl = UriComponentsBuilder.fromHttpUrl(GEOSERVER_BASE_URL)
                    .queryParam("service", "WFS")
                    .queryParam("version", "1.0.0")
                    .queryParam("request", "GetFeature")
                    .queryParam("typeName", "sundo3:" + tableName)
                    .queryParam("resultType", "hits")
                    .queryParam("cql_filter", cqlFilter)
                    .toUriString();

            log.info("📡 WFS Count 요청 URL: {}", requestUrl);

            HttpURLConnection conn = (HttpURLConnection) new URL(requestUrl).openConnection();
            conn.setRequestMethod("GET");

            try (Scanner scanner = new Scanner(conn.getInputStream())) {
                String response = scanner.useDelimiter("\\A").next();
                log.info("📦 WFS Count 응답 본문:\n{}", response);

                String marker = "numberOfFeatures=\"";
                int start = response.indexOf(marker);
                if (start == -1) {
                    log.error("❌ numberOfFeatures 항목이 응답에 없습니다.");
                    return 0;
                }

                start += marker.length();
                int end = response.indexOf("\"", start);
                String numberStr = response.substring(start, end);
                log.info("✅ 파싱된 feature 개수: {}", numberStr);
                return Integer.parseInt(numberStr);
            }

        } catch (Exception e) {
            log.error("❌ WFS Count 실패", e);
            return 0;
        }
    }
    
    public List<Map<String, Object>> fetchFeaturesByLocationAndOrg(String stations, String organization, String cqlFilter) {
        try {
            log.info("Fetching features with location: {} and organization: {}", stations, organization);

            // 조직에 맞는 테이블 이름 선택
            String typeName = "sundo3:water_data";  // 기본 테이블 이름 (환경부)
            
            if ("기상청".equals(organization)) {
                typeName = "sundo3:weather_data";  // 기상청의 경우 weather_data 테이블 사용
            }

            // GeoServer에 WFS 요청 보내기
            String requestUrl = UriComponentsBuilder.fromHttpUrl(GEOSERVER_BASE_URL)
                    .queryParam("service", "WFS")
                    .queryParam("version", "1.0.0")
                    .queryParam("request", "GetFeature")
                    .queryParam("typeName", typeName)  // 동적으로 테이블 이름 설정
                    .queryParam("outputFormat", "application/json")
                    .queryParam("maxFeatures", 100)
                    .queryParam("startIndex", 0)
                    .queryParam("cql_filter", cqlFilter)
                    .toUriString();

            log.info("📡 WFS 요청 URL: {}", requestUrl);

            // 요청 보내기
            HttpURLConnection conn = (HttpURLConnection) new URL(requestUrl).openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            int responseCode = conn.getResponseCode();
            log.info("HTTP Response Code: {}", responseCode);

            if (responseCode != HttpURLConnection.HTTP_OK) {
                log.error("❌ WFS 요청 실패. 응답 코드: {}", responseCode);
                return new ArrayList<>();
            }

            InputStream inputStream = conn.getInputStream();
            InputStreamReader reader = new InputStreamReader(inputStream);
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode rootNode = objectMapper.readTree(reader);

            List<Map<String, Object>> result = new ArrayList<>();
            rootNode.get("features").forEach(feature -> {
                Map<String, Object> featureMap = new HashMap<>();
                JsonNode propertiesNode = feature.get("properties");

                if (propertiesNode != null) {
                    propertiesNode.fieldNames().forEachRemaining(field -> {
                        featureMap.put(field, propertiesNode.get(field).asText());
                    });
                }
                result.add(featureMap);
            });

            return result;

        } catch (Exception e) {
            log.error("❌ WFS 요청 중 오류 발생", e);
            return new ArrayList<>();
        }
    }


    private String buildCqlFilter(String dateColumn, String startDate, String endDate, String location, String organization) {
        List<String> conditions = new ArrayList<>();

        // 날짜 조건 추가
        if (startDate != null && !startDate.isEmpty()) {
            conditions.add(dateColumn + " >= '" + startDate + "'");
        }
        if (endDate != null && !endDate.isEmpty()) {
            conditions.add(dateColumn + " <= '" + endDate + "'");
        }

        // location에 따른 조건 추가
        if (location != null && !location.isEmpty()) {
            if ("환경부".equals(organization)) {
                // 환경부는 ptnm 기준으로 필터링
                conditions.add("ptnm IN ('" + location + "')");
            } else if ("기상청".equals(organization)) {
                // 기상청은 station_name 기준으로 필터링
                conditions.add("station_name IN ('" + location + "')");
            }
        }

        // CQL 필터 로그 추가
        log.info("CQL 필터 생성: {}", String.join(" AND ", conditions));

        return String.join(" AND ", conditions);
    }



    @Override
    public List<String> getOrderedColumns(String tableName) {
        List<String> columnList = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             ResultSet rs = conn.getMetaData().getColumns(null, "public", tableName, null)) {
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME");
                if (!List.of("layer", "path", "geom", "id", "first_basin", "major_basin", "mid_basin").contains(columnName)) {
                    columnList.add(columnName);
                }
            }
        } catch (Exception e) {
            log.error("❌ 컬럼 순서 가져오기 실패", e);
        }
        return columnList;
    }
}
