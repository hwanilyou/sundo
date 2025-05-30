package egovframework.example.dto;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

public class UserActionLogDTO {
    private Long id;                  // No.
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime executedAt; // 시간
    private String dataName;         // 데이터명
    private String logType;          // 구분 (예: 수신)
    private String status;           // 결과 (성공, 실패)

    public UserActionLogDTO() {}

    public UserActionLogDTO(Long id, LocalDateTime executedAt, String dataName, String logType, String status) {
        this.id = id;
        this.executedAt = executedAt;
        this.dataName = dataName;
        this.logType = logType;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public LocalDateTime getExecutedAt() { return executedAt; }
    public void setExecutedAt(LocalDateTime executedAt) { this.executedAt = executedAt; }

    public String getDataName() { return dataName; }
    public void setDataName(String dataName) { this.dataName = dataName; }

    public String getLogType() { return logType; }
    public void setLogType(String logType) { this.logType = logType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
