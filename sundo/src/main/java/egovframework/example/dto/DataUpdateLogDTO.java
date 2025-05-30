package egovframework.example.dto;

import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonFormat;

public class DataUpdateLogDTO {
	private String organization;
	private String dataName;        // 데이터명
    private int dataCount;          // 데이터 수
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate baseDate;
    
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate lastUpdated;  // 마지막 갱신일

	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private LocalDate nextUpdate;  // 다음 갱신일
    private String status;          // 상태 (성공, 대기)
    
    private int successCount;     // ✅ 정상 건수
    private int errorCount;
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public String getDataName() {
		return dataName;
	}
	public void setDataName(String dataName) {
		this.dataName = dataName;
	}
	public int getDataCount() {
		return dataCount;
	}
	public void setDataCount(int dataCount) {
		this.dataCount = dataCount;
	}
	public LocalDate getBaseDate() {
		return baseDate;
	}
	public void setBaseDate(LocalDate baseDate) {
		this.baseDate = baseDate;
	}
	public LocalDate getLastUpdated() {
		return lastUpdated;
	}
	public void setLastUpdated(LocalDate lastUpdated) {
		this.lastUpdated = lastUpdated;
	}
	public LocalDate getNextUpdate() {
		return nextUpdate;
	}
	public void setNextUpdate(LocalDate nextUpdate) {
		this.nextUpdate = nextUpdate;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getSuccessCount() {
		return successCount;
	}
	public void setSuccessCount(int successCount) {
		this.successCount = successCount;
	}
	public int getErrorCount() {
		return errorCount;
	}
	public void setErrorCount(int errorCount) {
		this.errorCount = errorCount;
	}
	public DataUpdateLogDTO(String organization, String dataName, int dataCount, LocalDate baseDate,
			LocalDate lastUpdated, LocalDate nextUpdate, String status, int successCount, int errorCount) {
		super();
		this.organization = organization;
		this.dataName = dataName;
		this.dataCount = dataCount;
		this.baseDate = baseDate;
		this.lastUpdated = lastUpdated;
		this.nextUpdate = nextUpdate;
		this.status = status;
		this.successCount = successCount;
		this.errorCount = errorCount;
	}
	public DataUpdateLogDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
    
    
    
    

}
