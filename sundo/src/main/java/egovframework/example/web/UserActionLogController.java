package egovframework.example.web;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import egovframework.example.dto.UserActionLogDTO;
import egovframework.example.service.UserActionLogService;

@RestController
@RequestMapping("/api/user-log")
public class UserActionLogController {

    private final UserActionLogService userActionLogService;

    public UserActionLogController(UserActionLogService userActionLogService) {
        this.userActionLogService = userActionLogService;
    }

    // GET: 최신 10개 로그 조회
    @GetMapping
    public List<UserActionLogDTO> getUserLogs() {
        return userActionLogService.getLatestLogs();
    }

    // POST: 로그 저장
    @PostMapping("/save")
    public ResponseEntity<UserActionLogDTO> saveUserLog(
            @RequestParam String dataName,
            @RequestParam String logType,
            @RequestParam(defaultValue = "성공") String status) {

        System.out.println("✅ 로그 저장 요청: " + dataName + ", " + logType + ", " + status);
        UserActionLogDTO dto = userActionLogService.saveLog(dataName, logType, status);
        return ResponseEntity.ok(dto);
    }
}
