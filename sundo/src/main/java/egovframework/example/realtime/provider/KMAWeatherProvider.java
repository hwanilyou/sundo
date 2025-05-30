package egovframework.example.realtime.provider;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class KMAWeatherProvider {
    public void fetchAndSave() {
        // TODO: 기상청 API 호출 및 weather_data 테이블 저장 로직 작성
        log.info("✅ [기상청] 데이터 수집 완료");
    }
}