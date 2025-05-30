package egovframework.example.service;

import egovframework.example.entity.WeatherDataEntity;
import egovframework.example.repository.WeatherDataRepository;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class WeatherDataService {

    private final WeatherDataRepository repository;
    private final GeometryFactory geometryFactory = new GeometryFactory();

    public void fetchAndSave() throws Exception {
        System.out.println("🌍 [1단계] 측정소 정보 로딩 시작");
        Map<String, double[]> stationCoords = new HashMap<>();
        Map<String, String> stationNames = new HashMap<>();

        URL stnUrl = new URL("https://apihub.kma.go.kr/api/typ01/url/stn_inf.php?inf=AWS&stn=&tm=202211300900&help=0&authKey=_v7wW5IUQqu-8FuSFNKrLA");
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(stnUrl.openStream(), StandardCharsets.UTF_8))) {
            reader.lines()
                    .filter(line -> !line.startsWith("#"))
                    .forEach(line -> {
                        String[] tokens = line.trim().split("\\s+");
                        if (tokens.length >= 9) {
                            String stn = tokens[0];
                            try {
                                double lon = Double.parseDouble(tokens[1]);
                                double lat = Double.parseDouble(tokens[2]);
                                String name = tokens[8];
                                stationCoords.put(stn, new double[]{lon, lat});
                                stationNames.put(stn, name);
                            } catch (Exception e) {
                                System.err.println("❌ [좌표 파싱 실패] 라인: " + line);
                            }
                        }
                    });
        }
        System.out.println("✅ [1단계] 측정소 정보 로딩 완료: " + stationCoords.size() + "개 지점");

        System.out.println("🌦 [2단계] 실시간 기상 데이터 파싱 시작");

        URL dataUrl = new URL("https://apihub.kma.go.kr/api/typ01/cgi-bin/url/nph-aws2_min?stn=0&disp=0&help=0&authKey=Rae_zrJ_T7Wnv86yf8-1mA");
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(dataUrl.openStream(), StandardCharsets.UTF_8))) {
            reader.lines()
                    .filter(line -> !line.startsWith("#") && !line.trim().isEmpty())
                    .forEach(line -> {
                        System.out.println("📡 수신: " + line);
                        try {
                            String[] tokens = line.trim().split("\\s+");
                            if (tokens.length < 18) {
                                System.err.println("⚠ [스킵] 데이터 길이 부족: " + tokens.length);
                                return;
                            }

                            String rawDate = tokens[0];
                            LocalDateTime dateTime = LocalDateTime.parse(
                                    rawDate.substring(0, 8) + " " + rawDate.substring(8),
                                    DateTimeFormatter.ofPattern("yyyyMMdd HHmm")
                            );

                            String stn = tokens[1];
                            double temp = Double.parseDouble(tokens[11]);
                            double humidity = Double.parseDouble(tokens[12]);
                            double wind = Double.parseDouble(tokens[6]);
                            double rain = Double.parseDouble(tokens[17]);

                            double[] coord = stationCoords.get(stn);
                            String stnKo = stationNames.getOrDefault(stn, "지점명 없음");

                            if (coord == null) {
                                System.err.println("⚠ [스킵] 좌표 정보 없음: " + stn);
                                return;
                            }

                            double lon = coord[0];
                            double lat = coord[1];

                            Point geom = geometryFactory.createPoint(new Coordinate(lon, lat));
                            geom.setSRID(5179);

                            WeatherDataEntity entity = WeatherDataEntity.builder()
                                    .stn(stn)
                                    .stnKo(stnKo)
                                    .dateTime(dateTime)
                                    .temperature(temp)
                                    .humidity(humidity)
                                    .windSpeed(wind)
                                    .rainfall(rain)
                                    .lon(lon)
                                    .lat(lat)
                                    .geom(geom)
                                    .build();

                            repository.save(entity);
                            System.out.println("✅ 저장 완료: " + stnKo + " | " + dateTime);
                        } catch (Exception e) {
                            System.err.println("❌ 저장 실패 라인: " + line);
                            e.printStackTrace();
                        }
                    });
        }

        System.out.println("🌈 [완료] 실시간 기상 데이터 저장 작업 종료");
    }
}
