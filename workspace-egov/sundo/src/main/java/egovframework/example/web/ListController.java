package egovframework.example.web;

import java.util.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ListController {

    @RequestMapping("/list.do")
    public String listPage(Model model) {
        List<Map<String, String>> dataList = new ArrayList<>();

        Map<String, String> item1 = new HashMap<>();
        item1.put("region", "서울 강남구");
        item1.put("date", "2025-03-15");
        item1.put("type", "수질 데이터");
        item1.put("value", "pH 7.5");

        Map<String, String> item2 = new HashMap<>();
        item2.put("region", "경기도 수원시");
        item2.put("date", "2025-03-12");
        item2.put("type", "생물 데이터");
        item2.put("value", "어류 다양성 0.85");

        dataList.add(item1);
        dataList.add(item2);

        model.addAttribute("dataList", dataList);

        return "list";  // => /WEB-INF/jsp/list.jsp로 이동
    }
}