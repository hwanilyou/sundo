package egovframework.example.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_action_log")
public class UserActionLogEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "executed_at")
    private LocalDateTime executedAt;

    @Column(name = "data_name")
    private String dataName;

    @Column(name = "log_type")
    private String logType;  // 예: 수신, 선택

    @Column(name = "status")
    private String status;   // 성공 / 실패

    public UserActionLogEntity() {}

    public UserActionLogEntity(Long id, LocalDateTime executedAt, String dataName, String logType, String status) {
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
