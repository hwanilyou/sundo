package egovframework.example.service.impl;

import egovframework.example.service.StationMetadataService;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class StationMetadataServiceImpl implements StationMetadataService {
	@Autowired
    private final JdbcTemplate jdbcTemplate;

    @Override
    public List<Map<String, Object>> getKmaStationList() {
        return jdbcTemplate.queryForList("SELECT stn, station_name, station_cido FROM station_metadata WHERE organization = '기상청'");
    }

    @Override
    public List<String> getFirstBasins() {
        return jdbcTemplate.queryForList("SELECT DISTINCT first_basin FROM station_metadata WHERE organization = '환경부' AND first_basin IS NOT NULL ORDER BY first_basin", String.class);
    }

    @Override
    public List<String> getMajorBasinsByFirst(String firstBasin) {
        return jdbcTemplate.queryForList("SELECT DISTINCT major_basin FROM station_metadata WHERE organization = '환경부' AND first_basin = ? AND major_basin IS NOT NULL ORDER BY major_basin", String.class, firstBasin);
    }

    @Override
    public List<String> getMidBasinsByMajor(String majorBasin) {
        return jdbcTemplate.queryForList("SELECT DISTINCT mid_basin FROM station_metadata WHERE organization = '환경부' AND major_basin = ? AND mid_basin IS NOT NULL ORDER BY mid_basin", String.class, majorBasin);
    }

    @Override
    public List<String> getStationsByMidBasin(String midBasin) {
        return jdbcTemplate.queryForList("SELECT DISTINCT ptnm FROM station_metadata WHERE organization = '환경부' AND mid_basin = ? AND ptnm IS NOT NULL ORDER BY ptnm", String.class, midBasin);
    }
    
 // 조건에 맞는 데이터를 조회하는 메서드
    @Override
    public List<Map<String, Object>> getDataByConditions(
        String searchData, String tableName, String startDate, String endDate,
        String org, String firstBasin, String majorBasin, String midBasin, List<String> stations) {

        // 쿼리 작성 (예시: 조건에 맞는 데이터를 조회하는 쿼리)
        String sql = "SELECT * FROM " + tableName + " WHERE " +
            "organization = ? AND first_basin = ? AND major_basin = ? AND mid_basin = ? " +
            "AND station IN (?) AND date BETWEEN ? AND ?";

        // stations 리스트를 쉼표로 구분하여 하나의 문자열로 만들어서 쿼리에 사용
        String stationsList = String.join(",", stations);

        // 쿼리 실행
        return jdbcTemplate.queryForList(sql, org, firstBasin, majorBasin, midBasin, stationsList, startDate, endDate);
    }
}
