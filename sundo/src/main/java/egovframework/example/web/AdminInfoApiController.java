package egovframework.example.web;

import egovframework.example.dto.InfoSummaryDTO;
import egovframework.example.service.AdminInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;

@RestController
@RequiredArgsConstructor
public class AdminInfoApiController {

    private final AdminInfoService adminInfoService;

    @GetMapping("/api/admin/info-summary")  // 변경됨
    public Map<String, Object> getAdminSummary() {
        Map<String, Object> result = new HashMap<>();
        result.put("institution", adminInfoService.getInstitutionInfo());
        result.put("platform", adminInfoService.getBigDataPlatformInfo());
        result.put("integration", adminInfoService.getIntegrationStatus());
        return result;
    }
}
