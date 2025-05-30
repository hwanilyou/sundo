package egovframework.example.web;

import lombok.RequiredArgsConstructor;
import lombok.var;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;

@Controller
@ResponseBody
@RequiredArgsConstructor
public class SiteTreeController {

    private final JdbcTemplate jdbcTemplate;
    
    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }


    @GetMapping("/api/site-tree")
    public List<Map<String, Object>> getSiteTree(@RequestParam String tableName) {
    	 String sql = String.format(
    		        "SELECT DISTINCT first_basin, major_basin, mid_basin, ptnm FROM %s WHERE first_basin IS NOT NULL AND major_basin IS NOT NULL AND mid_basin IS NOT NULL AND ptnm IS NOT NULL",
    		        tableName
    		    );

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);

        Map<String, Map<String, Map<String, List<String>>>> grouped = new LinkedHashMap<>();

        for (Map<String, Object> row : rows) {
            String basin = safeStr(row.get("first_basin"));
            String major = safeStr(row.get("major_basin"));
            String mid = safeStr(row.get("mid_basin"));
            String ptnm = safeStr(row.get("ptnm"));

            // ✅ 넷 중 하나라도 비어있으면 제외
            if (basin.isEmpty() || major.isEmpty() || mid.isEmpty() || ptnm.isEmpty()) continue;

            grouped
                .computeIfAbsent(basin, k -> new LinkedHashMap<>())
                .computeIfAbsent(major, k -> new LinkedHashMap<>())
                .computeIfAbsent(mid, k -> new ArrayList<>())
                .add(ptnm);
        }

        // ✅ 트리 구조 변환
        List<Map<String, Object>> result = new ArrayList<>();
        for (var basinEntry : grouped.entrySet()) {
            Map<String, Object> basinNode = new LinkedHashMap<>();
            basinNode.put("label", basinEntry.getKey());
            List<Map<String, Object>> majorList = new ArrayList<>();

            for (var majorEntry : basinEntry.getValue().entrySet()) {
                Map<String, Object> majorNode = new LinkedHashMap<>();
                majorNode.put("label", majorEntry.getKey());
                List<Map<String, Object>> midList = new ArrayList<>();

                for (var midEntry : majorEntry.getValue().entrySet()) {
                    Map<String, Object> midNode = new LinkedHashMap<>();
                    midNode.put("label", midEntry.getKey());
                    midNode.put("children", midEntry.getValue());
                    midList.add(midNode);
                }

                majorNode.put("children", midList);
                majorList.add(majorNode);
            }

            basinNode.put("children", majorList);
            result.add(basinNode);
        }

        return result;
    }

    // 공백 문자열 처리 포함된 유틸 함수
    private String safeStr(Object obj) {
        return (obj == null) ? "" : obj.toString().trim();
    }

}
