package egovframework.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MapController {

    @RequestMapping("/")  // ← 이 부분 확인!
    public String index() {
        return "map";  
    }
    
    @RequestMapping("/hello")
    public String hello() {
        return "map";
    }

}
