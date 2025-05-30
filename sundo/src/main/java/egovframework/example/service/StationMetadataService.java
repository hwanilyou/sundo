package egovframework.example.service;

import java.util.List;
import java.util.Map;

public interface StationMetadataService {
    List<Map<String, Object>> getKmaStationList();
    List<String> getFirstBasins();
    List<String> getMajorBasinsByFirst(String firstBasin);
    List<String> getMidBasinsByMajor(String majorBasin);
    List<String> getStationsByMidBasin(String midBasin);
    
    
    
 // 조건에 맞는 데이터를 조회하는 메서드
    List<Map<String, Object>> getDataByConditions(
        String searchData, String tableName, String startDate, String endDate,
        String org, String firstBasin, String majorBasin, String midBasin, List<String> stations);
}
