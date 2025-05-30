package egovframework.example.realtime;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@RequiredArgsConstructor
@Component
public class RealTimeDataScheduler {

    private final RealTimeDataService realTimeDataService;
    private final AwsWeatherDataService awsWeatherDataService;

    @Scheduled(fixedDelay = 300_000) // 5분 간격
    public void fetchAllRealTimeData() {
        log.info("🔄 실시간 AWS 기상데이터 수집 시작");
        awsWeatherDataService.saveFromProxyAws();
    }

    public void fetchAndSaveAws() {
        log.info("🔄 실시간 AWS 기상데이터 수집 시작");
        awsWeatherDataService.saveFromProxyAws();
    }
    
    @Scheduled(fixedDelay = 600_000) // 10분 간격
    public void fetchDamData() {
        log.info("💧 댐 실시간 데이터 수집 시작");
        awsWeatherDataService.fetchAndStoreDamData();  // 임시 통합 구조 기준
    }

}
