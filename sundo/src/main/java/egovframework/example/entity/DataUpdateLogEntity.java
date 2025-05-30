package egovframework.example.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import javax.persistence.*;


@Entity
@Table(name = "data_update_log")
public class DataUpdateLogEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "organization")
    private String organization;

    @Column(name = "data_name")
    private String dataName;

    @Column(name = "data_count")
    private int dataCount;
    
    @Column(name = "base_date")
    private LocalDate baseDate;

    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;

    @Column(name = "next_update")
    private LocalDateTime nextUpdate;

    @Column(name = "status")
    private String status;
    
    @Column(name = "success_count")
    private int successCount;

    @Column(name = "error_count")
    private int errorCount;
    
      
    public DataUpdateLogEntity() {
    }


	public Long getId() {
		return id;
	}


	public void setId(Long id) {
		this.id = id;
	}


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


	public LocalDateTime getLastUpdated() {
		return lastUpdated;
	}


	public void setLastUpdated(LocalDateTime lastUpdated) {
		this.lastUpdated = lastUpdated;
	}


	public LocalDateTime getNextUpdate() {
		return nextUpdate;
	}


	public void setNextUpdate(LocalDateTime nextUpdate) {
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


	public DataUpdateLogEntity(Long id, String organization, String dataName, int dataCount, LocalDate baseDate,
			LocalDateTime lastUpdated, LocalDateTime nextUpdate, String status, int successCount, int errorCount) {
		super();
		this.id = id;
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

	
}
