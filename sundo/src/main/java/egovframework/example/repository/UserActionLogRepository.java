package egovframework.example.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import egovframework.example.entity.UserActionLogEntity;

public interface UserActionLogRepository extends JpaRepository<UserActionLogEntity, Long> {

    List<UserActionLogEntity> findTop10ByOrderByExecutedAtDesc(); // 최신 순 정렬
}
