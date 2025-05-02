package egovframework.example.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SimulationController {

    @RequestMapping("/simulation.do")
    public String simulationPage() {
        return "simulation"; // /WEB-INF/jsp/simulation.jsp 로 이동
    }
 // ✅ 이미지 테스트용 JSP 호출
    @RequestMapping("/resources-test.do")
    public String testPage() {
        return "resources-test"; // /WEB-INF/jsp/resources-test.jsp
    }
}
