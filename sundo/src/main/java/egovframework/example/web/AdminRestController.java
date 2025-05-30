// web/AdminRestController.java
package egovframework.example.web;

import egovframework.example.dto.AdminSummaryDto;
import egovframework.example.service.AdminDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminRestController {

    private final AdminDashboardService dashboardService;

    @GetMapping("/dashboard-summary")
    public AdminSummaryDto getSummary() {
        return dashboardService.getAdminSummary();
    }
}
