package egovframework.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
//각 정보 블록(기관, 플랫폼 등)의 요약 정보 구조 정의
public class InfoSummaryDTO {
    private String name;      // 예: "물환경 정보 시스템"
    private String status;    // 예: "정상"
    private int successCount; // 예: 38
    private int errorCount;   // 예: 0
}
