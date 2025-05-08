package egovframework.example.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdminController {

    @RequestMapping("/adminpage.do")
    public String adminPage() {
        return "admin-dashboard"; // /WEB-INF/jsp/admin-dashboard.jsp 로 이동
    }
}
