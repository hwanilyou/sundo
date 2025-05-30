// 패키지: egovframework.example.realtime

package egovframework.example.realtime;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import egovframework.example.realtime.provider.KMAWeatherProvider;
import egovframework.example.realtime.provider.SensorNetworkProvider;

@Slf4j
@Service
@RequiredArgsConstructor
public class RealTimeDataService {

    private final KMAWeatherProvider kmaWeatherProvider;
    private final SensorNetworkProvider sensorNetworkProvider;

    public void updateAll() {
        log.info("🌦️ 기상청 데이터 수집 시작");
        kmaWeatherProvider.fetchAndSave();

        log.info("🌐 센서 네트워크 데이터 수집 시작");
        sensorNetworkProvider.fetchAndSave();
    }
}