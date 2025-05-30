package egovframework.example.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import egovframework.example.entity.DataUpdateLogEntity;

public interface DataUpdateLogRepository extends JpaRepository<DataUpdateLogEntity, Long>{
	List<DataUpdateLogEntity> findAllByOrderByLastUpdatedDesc();
}
