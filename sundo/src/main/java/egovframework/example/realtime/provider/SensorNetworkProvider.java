package egovframework.example.realtime.provider;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class SensorNetworkProvider {
    public void fetchAndSave() {
        // TODO: 센서 데이터 수집 및 저장 로직 작성
        log.info("✅ [센서] 데이터 수집 완료");
    }
}