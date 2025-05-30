package egovframework.example.service;

import egovframework.example.entity.DataLogEntity;
import egovframework.example.repository.DataLogRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

@Service
public class WeatherSyncService {

    private final DataLogRepository logRepo;

    public WeatherSyncService(DataLogRepository logRepo) {
        this.logRepo = logRepo;
    }

    @Scheduled(fixedRate = 600_000)  // 10분마다 실행
    public void syncWeatherData() {
        try {
            // 1) 기상청 API 호출
            URL url = new URL("https://apihub.kma.go.kr/api/typ01/cgi-bin/url/nph-aws2_min?stn=0&disp=0&help=1&authKey=Rae_zrJ_T7Wnv86yf8-1mA");
            String result;
            try (BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), StandardCharsets.UTF_8))) {
                result = in.lines().collect(Collectors.joining("\n"));
            }

            // 2) 데이터 개수 파싱
            int dataCount = (int) result.lines().filter(line -> !line.startsWith("#")).count();

            // 3) 로그 저장
            DataLogEntity log = new DataLogEntity();
            log.setOrganization("기상청");
            log.setDataName("기상 데이터");
            log.setDataCount(dataCount);
            log.setStatus("성공");
            log.setExecutedAt(LocalDateTime.now());
            log.setSuccessCount(dataCount);
            log.setErrorCount(0);
            log.setBaseDate(LocalDate.now());
            log.setLastUpdated(LocalDate.now());
            log.setNextUpdate(LocalDate.now().plusDays(1)); // 하루 뒤 기준

            logRepo.save(log);
            System.out.println("✅ [WeatherSync] 기상 데이터 동기화 성공: " + dataCount + "건");

        } catch (Exception e) {
            System.err.println("❌ [WeatherSync] 기상 데이터 동기화 실패: " + e.getMessage());

            // 실패 로그도 저장
            DataLogEntity log = new DataLogEntity();
            log.setOrganization("기상청");
            log.setDataName("기상 데이터");
            log.setDataCount(0);
            log.setStatus("실패: " + e.getMessage());
            log.setExecutedAt(LocalDateTime.now());
            log.setSuccessCount(0);
            log.setErrorCount(1);
            log.setBaseDate(LocalDate.now());
            log.setLastUpdated(LocalDate.now());
            log.setNextUpdate(LocalDate.now().plusDays(1));

            logRepo.save(log);
        }
    }
    
    @Scheduled(fixedRate = 600_000)  // 10분마다 실행
    public void syncDamData() {
        try {
            URL url = new URL("https://api.hrfco.go.kr/52832662-D130-4239-9C5F-730AD3BE6BC6/dam/list/10M.json");
            String result;
            try (BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), StandardCharsets.UTF_8))) {
                result = in.lines().collect(Collectors.joining("\n"));
            }

            int dataCount = result.split("\\{").length - 1; // JSON 객체 개수 추정

            DataLogEntity log = new DataLogEntity();
            log.setOrganization("한강 홍수 통제소");
            log.setDataName("댐 데이터");
            log.setDataCount(dataCount);
            log.setStatus("성공");
            log.setExecutedAt(LocalDateTime.now());
            log.setSuccessCount(dataCount);
            log.setErrorCount(0);
            log.setBaseDate(LocalDate.now());
            log.setLastUpdated(LocalDate.now());
            log.setNextUpdate(LocalDate.now().plusDays(1));
            logRepo.save(log);

            System.out.println("✅ [DamSync] 댐 데이터 동기화 성공: " + dataCount + "건");

        } catch (Exception e) {
            System.err.println("❌ [DamSync] 댐 데이터 동기화 실패: " + e.getMessage());

            DataLogEntity log = new DataLogEntity();
            log.setOrganization("한강 홍수 통제소");
            log.setDataName("댐 데이터");
            log.setDataCount(0);
            log.setStatus("실패: " + e.getMessage());
            log.setExecutedAt(LocalDateTime.now());
            log.setSuccessCount(0);
            log.setErrorCount(1);
            log.setBaseDate(LocalDate.now());
            log.setLastUpdated(LocalDate.now());
            log.setNextUpdate(LocalDate.now().plusDays(1));
            logRepo.save(log);
        }
    }
}
