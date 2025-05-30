package egovframework.example.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class DataLogDTO {
    private Long id;
    private String organization; // 기관명
    private String dataName;  // 데이터명
    private int dataCount;  // 데이터 수
    private String status;  // 상태
    private LocalDateTime executedAt;  // 실행 시간
    private int successCount;  // 성공 수
    private int errorCount;  // 에러 수
    private LocalDate baseDate;  // 기본 시간
    private LocalDate lastUpdated;  // 마지막 갱신 시간
    private LocalDate nextUpdate;  // 다음 갱실 예정일

    public DataLogDTO(Long id, String organization, String dataName, int dataCount, String status,
                      LocalDateTime executedAt, int successCount, int errorCount,
                      LocalDate baseDate, LocalDate lastUpdated, LocalDate nextUpdate) {
        this.id = id;
        this.organization = organization;
        this.dataName = dataName;
        this.dataCount = dataCount;
        this.status = status;
        this.executedAt = executedAt;
        this.successCount = successCount;
        this.errorCount = errorCount;
        this.baseDate = baseDate;
        this.lastUpdated = lastUpdated;
        this.nextUpdate = nextUpdate;
    }

    public Long getId() { return id; }
    public String getOrganization() { return organization; }
    public String getDataName() { return dataName; }
    public int getDataCount() { return dataCount; }
    public String getStatus() { return status; }
    public LocalDateTime getExecutedAt() { return executedAt; }
    public int getSuccessCount() { return successCount; }
    public int getErrorCount() { return errorCount; }
    public LocalDate getBaseDate() { return baseDate; }
    public LocalDate getLastUpdated() { return lastUpdated; }
    public LocalDate getNextUpdate() { return nextUpdate; }
}