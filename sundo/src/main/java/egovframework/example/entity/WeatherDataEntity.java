package egovframework.example.entity;

import javax.persistence.*;
import org.locationtech.jts.geom.Point;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "weather_data")
public class WeatherDataEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String stn;
    private String stnKo;
    private LocalDateTime dateTime;

    private Double temperature;
    private Double windSpeed;
    private Double humidity;
    private Double rainfall;

    private Double lon; // ✅ 경도 추가
    private Double lat; // ✅ 위도 추가

    @Column(columnDefinition = "geometry(Point, 5179)")
    private Point geom;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Getter/Setter 또는 @Builder 등 추가
}
