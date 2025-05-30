package egovframework.example.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {

    @RequestMapping("/")
    public String index() {
        return "index";  // -> /WEB-INF/jsp/index.jsp
    }
    @RequestMapping("/map")
	public String showMap() {
		return "platform/map";
	}
}