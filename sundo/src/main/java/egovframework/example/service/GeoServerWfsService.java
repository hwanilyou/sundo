package egovframework.example.service;

import java.util.List;
import java.util.Map;

public interface GeoServerWfsService {

    List<Map<String, Object>> fetchFeatures(
        String tableName,
        String dateColumn,
        String startDate,
        String endDate,
        String location,
        int limit,
        int offset
    );

    int countFeatures(
        String tableName,
        String dateColumn,
        String startDate,
        String endDate,
        String location
    );

    List<String> getOrderedColumns(String tableName);
    
    List<Map<String, Object>> fetchFeaturesByLocationAndOrg(String stations, String organization, String cqlFilter);
}
