// dto/AdminSummaryDto.java
package egovframework.example.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class AdminSummaryDto {

    private List<InstitutionDto> institution;
    private PlatformDto platform;
    private IntegrationDto integration;

    @Data
    @Builder
    public static class InstitutionDto {
        private String name;
        private String status;
        private int successCount;
        private int errorCount;
    }

    @Data
    @Builder
    public static class PlatformDto {
        private String status;
        private int successCount;
        private int errorCount;
    }

    @Data
    @Builder
    public static class IntegrationDto {
        private String status;
        private int successCount;
        private int errorCount;
    }
}
