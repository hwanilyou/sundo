// 📁 경로: egovframework.example.repository

package egovframework.example.repository;

import egovframework.example.entity.WeatherDataEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WeatherDataRepository extends JpaRepository<WeatherDataEntity, Long> {
    // 필요한 경우 여기에 findByStn, findByDate 등 메서드 추가 가능
}
