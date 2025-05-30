package egovframework.example.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "metadata")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Metadata {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String tableName;
    private String title;
    private String organization;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;  // 테이블 생성일
    
    private String category;
    private String regionType;
    private String regionColumn;
    private String dateColumn;
    private String searchColumns;
    
    @Column(name = "start_date")
    private LocalDate startDate;  // 조사 시작일
    
    @Column(name = "end_date")
    private LocalDate endDate;    // 조사 종료일

    private String description;    // 데이터 설명
    private String externalUrl;    // 외부 URL
    private String dataInformation; // 데이터 정보

    @Override
    public String toString() {
        return "Metadata{" +
                "id=" + id +
                ", tableName='" + tableName + '\'' +
                ", title='" + title + '\'' +
                ", organization='" + organization + '\'' +
                ", createdAt=" + createdAt +
                ", category='" + category + '\'' +
                ", regionType='" + regionType + '\'' +
                ", regionColumn='" + regionColumn + '\'' +
                ", dateColumn='" + dateColumn + '\'' +
                ", searchColumns='" + searchColumns + '\'' +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", description='" + description + '\'' +
                ", externalUrl='" + externalUrl + '\'' +
                ", dataInformation='" + dataInformation + '\'' +
                '}';
    }
}