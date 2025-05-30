package egovframework.example.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import egovframework.example.dto.UserActionLogDTO;
import egovframework.example.entity.UserActionLogEntity;
import egovframework.example.repository.UserActionLogRepository;

@Service
public class UserActionLogService {

    private final UserActionLogRepository userActionLogRepository;

    public UserActionLogService(UserActionLogRepository userActionLogRepository) {
        this.userActionLogRepository = userActionLogRepository;
    }

    // 로그 저장
    public UserActionLogDTO saveLog(String dataName, String logType, String status) {
        UserActionLogEntity entity = new UserActionLogEntity();
        entity.setDataName(dataName);
        entity.setLogType(logType);
        entity.setStatus(status);
        entity.setExecutedAt(LocalDateTime.now());

        UserActionLogEntity saved = userActionLogRepository.save(entity);

        return new UserActionLogDTO(
            saved.getId(),
            saved.getExecutedAt(),
            saved.getDataName(),
            saved.getLogType(),
            saved.getStatus()
        );
    }

    // 최신 10개 로그 조회
    public List<UserActionLogDTO> getLatestLogs() {
        List<UserActionLogEntity> entities = userActionLogRepository.findTop10ByOrderByExecutedAtDesc();
        return entities.stream()
            .map(e -> new UserActionLogDTO(
                e.getId(),
                e.getExecutedAt(),
                e.getDataName(),
                e.getLogType(),
                e.getStatus()
            ))
            .collect(Collectors.toList());
    }
}
