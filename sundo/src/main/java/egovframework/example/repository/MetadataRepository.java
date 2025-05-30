package egovframework.example.repository;

import egovframework.example.model.Metadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;
import java.util.List;

public interface MetadataRepository extends JpaRepository<Metadata, Long> {
    // 기본 CRUD 기능은 JpaRepository가 자동 제공
    Optional<Metadata> findByTableName(String tableName);
    List<Metadata> findByCategory(String category);
    
    // 연도만 추출하여 유니크한 값으로 반환하는 쿼리 (startDate로 변경)
    @Query("SELECT DISTINCT EXTRACT(YEAR FROM m.startDate) FROM Metadata m WHERE m.category = :category")
    List<Integer> findDistinctYears(String category);

    // 카테고리로 메타데이터 조회하고, createdAt으로 최신순 정렬
    List<Metadata> findByCategoryOrderByCreatedAtDesc(String category); // createdAt 기준으로 최신순
    
    // 모든 메타데이터 조회
    @Override
    List<Metadata> findAll();  // JpaRepository 기본 메서드 사용
    
    
    @Query("SELECT DISTINCT m.category FROM Metadata m WHERE m.category IS NOT NULL")
    List<String> findDistinctCategories();
    
    @Query("SELECT m.tableName FROM Metadata m WHERE m.category = :category")
    List<String> findTableNamesByCategory(@Param("category") String category);

}
