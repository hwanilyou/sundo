package egovframework.example.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import egovframework.example.entity.DataLogEntity;

public interface DataLogRepository extends JpaRepository<DataLogEntity, Long>{
	List<DataLogEntity> findAllByOrderByExecutedAtDesc();
	
	@Query(value = "SELECT DISTINCT ON (data_name) " +
	        "id, organization, data_name, data_count, status, " +
	        "executed_at, success_count, error_count, " +
	        "base_date, last_updated, next_update " +
	        "FROM data_log " +
	        "ORDER BY data_name, last_updated DESC",
	        nativeQuery = true)
	List<DataLogEntity> findLatestByDataName();
}
