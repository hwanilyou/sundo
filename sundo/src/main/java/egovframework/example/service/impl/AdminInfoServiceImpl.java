package egovframework.example.service.impl;

import egovframework.example.dto.InfoSummaryDTO;
import egovframework.example.model.Metadata;
import egovframework.example.repository.MetadataRepository;
import egovframework.example.service.AdminInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminInfoServiceImpl implements AdminInfoService {

    private final MetadataRepository metadataRepository;

    @Override
    public List<InfoSummaryDTO> getInstitutionInfo() {
        List<Metadata> list = metadataRepository.findAll();

        return list.stream()
                .collect(Collectors.groupingBy(Metadata::getOrganization))
                .entrySet().stream()
                .map(e -> new InfoSummaryDTO(
                        e.getKey(),
                        "정상",
                        e.getValue().size(),
                        0
                )).collect(Collectors.toList());
    }

    @Override
    public InfoSummaryDTO getBigDataPlatformInfo() {
        // 예시: "물환경 정보 시스템" 관련 데이터 기준
        List<Metadata> list = metadataRepository.findAll().stream()
                .filter(m -> m.getOrganization().contains("물환경"))
                .collect(Collectors.toList());

        return new InfoSummaryDTO("물환경 정보 시스템", "정상", list.size(), 0);
    }

    @Override
    public InfoSummaryDTO getIntegrationStatus() {
        // 전송 관련 상태 예시
        return new InfoSummaryDTO("연계 처리 결과", "정상", 0, 0);
    }
}
