package egovframework.example.service;

import egovframework.example.dto.ListSearchDto;

import java.util.List;
import java.util.Map;

public interface ListService {
    // 방식 1: DTO 이용 방식
    List<Map<String, Object>> searchData(ListSearchDto dto) throws Exception;

    // 방식 2: 파라미터 직접 전달 방식
    List<Map<String, Object>> searchData(String tableName, String startDate, String endDate, String location);

    // 카테고리 목록 (수질 / 생물 등)
    List<String> getAllCategories();

    List<Map<String, Object>> search(String tableName, String dateColumn, String regionColumn, String startDate, String endDate, String location);
    
    // 선택된 카테고리에 따른 테이블 목록 반환
    List<String> getTableNamesByCategory(String category);
    
    List<Map<String, Object>> searchPaged(String tableName, String dateColumn, String regionColumn,
            String startDate, String endDate, String location,
            int limit, int offset);
    
    int count(String tableName, String dateColumn, String regionColumn,
            String startDate, String endDate, String location);

}
