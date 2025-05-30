package egovframework.example.service.impl;

import egovframework.example.model.Metadata;
import egovframework.example.repository.MetadataRepository;
import egovframework.example.dto.AdminSummaryDto;
import egovframework.example.service.AdminDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminDashboardServiceImpl implements AdminDashboardService {

    private final MetadataRepository metadataRepository;

    @Override
    public AdminSummaryDto getAdminSummary() {
        List<Metadata> allMetadata = metadataRepository.findAll();

        // 기관 정보 생성 (organization 기준으로 그룹화)
        List<AdminSummaryDto.InstitutionDto> institutions = allMetadata.stream()
                .collect(Collectors.groupingBy(Metadata::getOrganization))
                .entrySet().stream()
                .map(entry -> AdminSummaryDto.InstitutionDto.builder()
                        .name(entry.getKey())
                        .status("정상") // 지금은 고정
                        .successCount(entry.getValue().size())
                        .errorCount(0) // 추후 오류건수 로직 반영 가능
                        .build())
                .collect(Collectors.toList());

        // 빅데이터 플랫폼 예시 (분류: 물환경 정보 시스템)
        AdminSummaryDto.PlatformDto platform = AdminSummaryDto.PlatformDto.builder()
                .status("정상")
                .successCount((int) allMetadata.stream().filter(m -> "물환경 정보 시스템".equals(m.getOrganization())).count())
                .errorCount(0)
                .build();

        // 연계 처리 결과 예시
        AdminSummaryDto.IntegrationDto integration = AdminSummaryDto.IntegrationDto.builder()
                .status("정상")
                .successCount(allMetadata.size())
                .errorCount(0)
                .build();

        return new AdminSummaryDto(institutions, platform, integration);
    }
}
