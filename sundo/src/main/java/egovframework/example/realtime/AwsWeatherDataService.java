package egovframework.example.realtime;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;


import javax.net.ssl.*; // 꼭 import 필요
import java.security.cert.X509Certificate;
@Slf4j
@Service
public class AwsWeatherDataService {
	
	static {
        try {
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    @Override
                    public void checkClientTrusted(X509Certificate[] chain, String authType) {
                    }

                    @Override
                    public void checkServerTrusted(X509Certificate[] chain, String authType) {
                    }

                    @Override
                    public X509Certificate[] getAcceptedIssuers() {
                        return new X509Certificate[0];
                    }
                }
            };

            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
            HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);

            System.out.println("⚠ 개발 환경: SSL 인증서 검증 무시 활성화됨");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final Map<String, StationMeta> stnMetaMap = new HashMap<>();
    private final Map<String, DamMeta> damMetaMap = new HashMap<>();

    private static final String META_API_KEY = "_v7wW5IUQqu-8FuSFNKrLA";
    private static final String DATA_API_KEY = "Rae_zrJ_T7Wnv86yf8-1mA";

    @PostConstruct
    public void init() {
        loadStationMetaFromKmaApi(); // 기상청 측정소 메타
        loadDamMetaFromApi();        // 댐 메타정보
        createIndexIfNotExist();     // 인덱스 생성
    }

    public void loadStationMetaFromKmaApi() {
        try {
            String url = "https://apihub.kma.go.kr/api/typ01/url/stn_inf.php?inf=AWS&stn=&tm=202211300900&authKey=" + META_API_KEY;
            BufferedReader reader = new BufferedReader(new InputStreamReader(
                    Jsoup.connect(url).ignoreContentType(true).execute().bodyStream(), "EUC-KR"));

            String line;
            boolean isDataSection = false;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.startsWith("# STN")) {
                    isDataSection = true;
                    continue;
                }
                if (!isDataSection || line.isEmpty() || line.startsWith("#")) continue;

                String[] tokens = line.trim().split("\\s+");
                if (tokens.length < 9) continue;

                String stn = String.valueOf(Integer.parseInt(tokens[0]));
                double lon = Double.parseDouble(tokens[1]);
                double lat = Double.parseDouble(tokens[2]);
                String name = tokens[8];

                stnMetaMap.put(stn, new StationMeta(name, lon, lat));
            }

            log.info("✅ STN 메타정보 {}건 로딩 완료", stnMetaMap.size());

        } catch (Exception e) {
            log.error("❌ STN 메타정보 API 로딩 실패", e);
        }
    }

    public void loadDamMetaFromApi() {
        try {
            String url = "https://api.hrfco.go.kr/52832662-D130-4239-9C5F-730AD3BE6BC6/dam/info.json";
            BufferedReader reader = new BufferedReader(new InputStreamReader(new URL(url).openStream(), StandardCharsets.UTF_8));
            String json = reader.lines().collect(Collectors.joining("\n"));
            reader.close();

            ObjectMapper mapper = new ObjectMapper();
            JsonNode array = mapper.readTree(json);

            for (JsonNode damNode : array) {
                String damId = damNode.path("dmobscd").asText();
                String name = damNode.path("obsnm").asText();
                double lon = damNode.path("x").asDouble();
                double lat = damNode.path("y").asDouble();
                damMetaMap.put(damId, new DamMeta(name, lon, lat));
            }

            log.info("✅ 댐 메타정보 {}건 로딩 완료", damMetaMap.size());

        } catch (Exception e) {
            log.error("❌ 댐 메타정보 API 로딩 실패", e);
        }
    }

    public void saveFromProxyAws() {
        try {
            String url = "https://apihub.kma.go.kr/api/typ01/cgi-bin/url/nph-aws2_min?stn=0&disp=0&help=1&authKey=" + DATA_API_KEY;
            BufferedReader in = new BufferedReader(new InputStreamReader(new URL(url).openStream(), StandardCharsets.UTF_8));
            List<String> lines = new ArrayList<>();
            String line;

            while ((line = in.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#") || line.startsWith("-")) continue;
                if (line.matches("^\\d{12}\\s+\\d+.*")) {
                    lines.add(line);
                }
            }
            in.close();

            int savedCount = 0;
            for (String l : lines) {
                String[] parts = l.trim().split("\\s+");
                if (parts.length < 18) continue;

                String rawStn = parts[1];
                String stn = String.valueOf(Integer.parseInt(rawStn));
                StationMeta meta = stnMetaMap.get(stn);

                String name = (meta != null) ? meta.getName() : "UNKNOWN";
                double lon = (meta != null) ? meta.getLon() : 0.0;
                double lat = (meta != null) ? meta.getLat() : 0.0;

                Timestamp timestamp = new Timestamp(new SimpleDateFormat("yyyyMMddHHmm").parse(parts[0]).getTime());
                double temp = Double.parseDouble(parts[7]);
                double humidity = Double.parseDouble(parts[15]);
                double wind = Double.parseDouble(parts[5]);
                double rain = Double.parseDouble(parts[9]);

                jdbcTemplate.update(
                    "INSERT INTO weather_data (stn, name, station_name, date, temp, humidity, wind, rain, geom, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ST_SetSRID(ST_MakePoint(?, ?), 5179), now()) " +
                    "ON CONFLICT (stn) DO UPDATE SET " +
                    "temp = EXCLUDED.temp, humidity = EXCLUDED.humidity, wind = EXCLUDED.wind, " +
                    "rain = EXCLUDED.rain, geom = EXCLUDED.geom, name = EXCLUDED.name, " +
                    "station_name = EXCLUDED.station_name, created_at = EXCLUDED.created_at",
                    ps -> {
                        ps.setString(1, stn);
                        ps.setString(2, name);
                        ps.setString(3, name);
                        ps.setTimestamp(4, timestamp);
                        ps.setDouble(5, temp);
                        ps.setDouble(6, humidity);
                        ps.setDouble(7, wind);
                        ps.setDouble(8, rain);
                        ps.setDouble(9, lon);
                        ps.setDouble(10, lat);
                    }
                );

                savedCount++;
            }

            log.info("✅ AWS 실시간 데이터 저장 완료: {}개", savedCount);

        } catch (Exception e) {
            log.error("❌ AWS 데이터 저장 실패", e);
        }
    }

    public void fetchAndStoreDamData() {
        try {
            String url = "https://api.hrfco.go.kr/52832662-D130-4239-9C5F-730AD3BE6BC6/dam/list/10M.json";
            BufferedReader reader = new BufferedReader(new InputStreamReader(new URL(url).openStream(), StandardCharsets.UTF_8));
            String json = reader.lines().collect(Collectors.joining("\n"));
            reader.close();

            ObjectMapper mapper = new ObjectMapper();
            JsonNode dataArray = mapper.readTree(json).path("content");

            int savedCount = 0;
            for (JsonNode node : dataArray) {
                String damId = node.path("dmobscd").asText();
                String dateStr = node.path("ymdhm").asText();
                Timestamp date = new Timestamp(new SimpleDateFormat("yyyyMMddHHmm").parse(dateStr).getTime());

                double level = node.path("swl").asDouble();
                double inflow = node.path("inf").asDouble();
                double outflow = node.path("sfw").asDouble();

                DamMeta meta = damMetaMap.get(damId);
                String damName = (meta != null) ? meta.getName() : "UNKNOWN";
                double lon = (meta != null) ? meta.getLon() : 0.0;
                double lat = (meta != null) ? meta.getLat() : 0.0;

                jdbcTemplate.update(
                    "INSERT INTO dam_data (dam_id, dam_name, date, level, inflow, outflow, geom, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ST_SetSRID(ST_MakePoint(?, ?), 5179), now()) " +
                    "ON CONFLICT (dam_id) DO UPDATE SET " +
                    "level = EXCLUDED.level, inflow = EXCLUDED.inflow, outflow = EXCLUDED.outflow, " +
                    "geom = EXCLUDED.geom, created_at = EXCLUDED.created_at",
                    damId, damName, date, level, inflow, outflow, lon, lat
                );
                savedCount++;
            }

            log.info("✅ 댐 실시간 데이터 저장 완료: {}개", savedCount);

        } catch (Exception e) {
            log.error("❌ 댐 데이터 저장 실패", e);
        }
    }

    private void createIndexIfNotExist() {
        String checkIndexSql = "SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'weather_data' AND indexname = 'idx_weather_data_stn_date'";
        int count = jdbcTemplate.queryForObject(checkIndexSql, Integer.class);
        if (count == 0) {
            jdbcTemplate.execute("CREATE INDEX idx_weather_data_stn_date ON weather_data(stn, date)");
            log.info("✅ 인덱스 'idx_weather_data_stn_date' 생성 완료");
        }
    }

    private static class StationMeta {
        private final String name;
        private final double lon;
        private final double lat;
        public StationMeta(String name, double lon, double lat) {
            this.name = name;
            this.lon = lon;
            this.lat = lat;
        }
        public String getName() { return name; }
        public double getLon() { return lon; }
        public double getLat() { return lat; }
    }

    private static class DamMeta {
        private final String name;
        private final double lon;
        private final double lat;
        public DamMeta(String name, double lon, double lat) {
            this.name = name;
            this.lon = lon;
            this.lat = lat;
        }
        public String getName() { return name; }
        public double getLon() { return lon; }
        public double getLat() { return lat; }
    }
}
