package egovframework.example.web;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import egovframework.example.dto.DataLogDTO;
import egovframework.example.repository.UserActionLogRepository;
import egovframework.example.service.DataLogService;

@RestController
public class DataLogController {

    private final DataLogService dataLogService;
    private final UserActionLogRepository userActionLogRepository; // ✅ 추가

    public DataLogController(DataLogService dataLogService,
                              UserActionLogRepository userActionLogRepository) {
        this.dataLogService = dataLogService;
        this.userActionLogRepository = userActionLogRepository; // ✅ 주입
    }

    @GetMapping("/api/data-log")
    public List<DataLogDTO> getDataLogs() {
        return dataLogService.getUpdateLogs();
    }

    @GetMapping("/api/data-log/latest")
    public List<DataLogDTO> getLatestByDataName() {
        return dataLogService.getLatestLogsByDataName();
    }

    @PostMapping("/api/user-log/reset")
    public ResponseEntity<Void> resetLogs() {
        userActionLogRepository.deleteAll(); // ✅ 사용자 로그 초기화
        return ResponseEntity.ok().build();
    }
}
