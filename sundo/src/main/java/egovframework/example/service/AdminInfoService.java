package egovframework.example.service;

import egovframework.example.dto.InfoSummaryDTO;

import java.util.List;

public interface AdminInfoService {
    List<InfoSummaryDTO> getInstitutionInfo();
    InfoSummaryDTO getBigDataPlatformInfo();
    InfoSummaryDTO getIntegrationStatus();
}
