package egovframework.example.service;

import java.util.List;
import java.util.Map;

import egovframework.example.model.Metadata;

public interface MetadataService {
	void save(Metadata metadata) throws Exception;
    List<Metadata> findAll() throws Exception;
    Metadata findById(Long id) throws Exception;
    void update(Metadata metadata) throws Exception;
    void deleteById(Long id) throws Exception;
    List<List<String>> findTableData(String tableName) throws Exception;
    List<List<String>> fetchTableDataPreview(String tableName);

    List<String> getDistinctCategories();  // 카테고리 목록 조회
    List<String> getTableNamesByCategory(String category); //해당 테이블 뜨게
    List<String> getAllCategories();
    List<Map<String, Object>> getTableData(String tableName);  // ✅ 추가

}
