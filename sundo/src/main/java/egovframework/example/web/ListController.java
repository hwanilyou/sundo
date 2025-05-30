package egovframework.example.web;

import egovframework.example.model.Metadata;
import egovframework.example.repository.MetadataRepository;
import egovframework.example.service.GeoServerWfsService;
import egovframework.example.service.ListService;
import egovframework.example.service.MetadataService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ListController {

    private final ListService listService;
    private final MetadataRepository metadataRepository;
    private final MetadataService metadataService;
    private final GeoServerWfsService geoServerWfsService;

    @GetMapping("/list.do")
    public String listPage(
            @RequestParam(required = false) String dataType,
            @RequestParam(required = false) String tableName,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String location,
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        // 카테고리 목록 가져오기
        List<String> categoryList = metadataService.getAllCategories();
        model.addAttribute("categoryList", categoryList);

        // 측정소 선택 후 WFS 요청 처리 (location 파라미터가 존재할 경우)
        List<Map<String, Object>> data = new ArrayList<>();
        if (location != null && !location.isEmpty()) {
            // location을 기준으로 WFS 요청 (기상청/환경부에 맞는 필터 처리)
            data = geoServerWfsService.fetchFeaturesByLocationAndOrg(location, "환경부", "ptnm IN ('" + location + "')");

            // WFS 데이터에서 properties만 추출
            List<Map<String, Object>> processedData = new ArrayList<>();
            for (Map<String, Object> feature : data) {
                Map<String, Object> properties = (Map<String, Object>) feature.get("properties");
                processedData.add(properties);  // properties만 리스트에 추가
            }

            // WFS 요청 URL 데이터 확인
            System.out.println("WFS 요청 URL 데이터 확인: " + processedData);
            data = processedData;  // processedData를 사용하여 WFS 데이터 업데이트
        }

        // 테이블 데이터 가져오기
        if (tableName != null && !tableName.isEmpty()) {
            Metadata metadata = metadataRepository.findByTableName(tableName).orElse(null);
            String dateColumn = metadata != null ? metadata.getDateColumn() : "date";
            String regionColumn = metadata != null ? metadata.getRegionColumn() : null;
            String organization = metadata != null ? metadata.getOrganization() : "";  // Get organization value

            if ((startDate == null || startDate.isEmpty()) && metadata != null)
                startDate = String.valueOf(metadata.getStartDate());
            if ((endDate == null || endDate.isEmpty()) && metadata != null)
                endDate = String.valueOf(metadata.getEndDate());

            int pageSize = 15;
            int offset = (page - 1) * pageSize;
            int totalCount = geoServerWfsService.countFeatures(tableName, dateColumn, startDate, endDate, location);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            List<Map<String, Object>> pagedList = geoServerWfsService.fetchFeatures(
                    tableName, dateColumn, startDate, endDate, location, pageSize, offset
            );

            // Get the columns and remove unwanted ones (wkt_geom, wmyr, wmod, name)
            List<String> columns = geoServerWfsService.getOrderedColumns(tableName);

            // Check the organization type and adjust columns accordingly
            if ("기상청".equals(organization)) {  // 수질 데이터 처리
                // 수질 데이터에서 first_basin, major_basin, mid_basin, ptnm 처리
                columns.remove("wkt_geom");
                columns.remove("wmyr");
                columns.remove("wmod");
                columns.remove("name");
                columns.remove("stn");
                
            } else if ("환경부".equals(organization)) {  // 기상청 데이터 처리
                // 기상청 데이터에서 stn, name 처리
                columns.remove("first_basin");
                columns.remove("major_basin");
                columns.remove("mid_basin");
            }

            if ("biological_monitoring".equalsIgnoreCase(tableName)) {
               // java 9 이상 사용시 columns.removeAll(List.of( )); 사용
               columns.removeAll(Arrays.asList(
                      "ITEMTEMP", "ITEMDOC", "ITEMBOD", "ITEMCOD", "ITEMSS", "ITEMTN", "ITEMTP",
                      "ITEMTOC", "ITEMPH", "ITEMPHENOL", "ITEMEC", "ITEMTCOLI", "ITEMCD",
                      "ITEMCN", "ITEMPB", "ITEMCR6", "ITEMAS", "ITEMHG", "WMYR", "WMOD", "TYPE", "PTNM",
                      "ITEMCU", "ITEMZN", "ITEMCR", "ITEMNI", "ITEMBA", "ITEMDTN", "ITEMNH3N", "ITEMNO3N",
                      "ITEMDTP", "ITEMPOP", "ITEMCLOA", "ITEMHCB", "ITEMECOLI", "ITEMFL", "ITEMCOL", "ITEMNHEX",
                      "ITEMABS", "ITEMTCE", "ITEMPCE", "ITEMCCL4", "ITEMDCETH", "ITEMDCM", "ITEMBENZEN",
                      "ITEMPCB", "ITEMOP", "ITEMANTIMO", "ITEMCHCL3", "ITEMDEHP", "ITEMDIOX", "ITEMTRANS",
                      "ITEMAMNT", "ITEMHCHO"
                  ));
               
           
                
                
            }
            // Remove specific columns that you don't want to show
            columns.remove("type");
            columns.remove("wkt_geom");
            columns.remove("wmyr");
            columns.remove("wmod");
            columns.remove("name");
            columns.remove("stn");
            columns.remove("id_0");
            columns.remove("id_1");
            columns.remove("created_at");
            columns.remove("dam_id");
            columns.removeIf(col -> col.equalsIgnoreCase("ptno"));

            Map<String, String> columnLabelMap = new HashMap<>();
            columnLabelMap.put("station_name", "위치");
            columnLabelMap.put("X", "경도");
            columnLabelMap.put("Y", "위도");
            columnLabelMap.put("date", "날짜");
            columnLabelMap.put("temp", "기온");
            columnLabelMap.put("humidity", "습도");
            columnLabelMap.put("wind", "풍속");
            columnLabelMap.put("rain", "강수 감지");
            columnLabelMap.put("SurveyYear", "조사년도");
            columnLabelMap.put("ptnm", "위치");
            columnLabelMap.put("SurveyRoun", "회차");
            columnLabelMap.put("PTNM_2", "위치");
            columnLabelMap.put("Scientific", "학명");
            columnLabelMap.put("KoreanName", "한글명");
            columnLabelMap.put("Individual", "개체 수");
            columnLabelMap.put("itemTemp", "수온");
            columnLabelMap.put("itemDoc", "용존산소(Doc)");
            columnLabelMap.put("itemBod", "생물학적 산소요구량(Bod)");
            columnLabelMap.put("itemCod", "화학적 산소요구량(Cod)");
            columnLabelMap.put("itemSs", "부유물질(Ss)");
            columnLabelMap.put("itemTn", "총질소(Tn)");
            columnLabelMap.put("itemTp", "총인(Tp)");
            columnLabelMap.put("itemToc", "총유기탄소(Toc)");
            columnLabelMap.put("dam_name", "댐 이름");
            columnLabelMap.put("level", "수위");
            columnLabelMap.put("inflow", "유입량");
            columnLabelMap.put("outflow", "방류량");

            
            
            
            
            // Add WFS data to list
            List<Map<String, Object>> combinedList = new ArrayList<>(pagedList);
            combinedList.addAll(data);  // Add WFS data to the list

            model.addAttribute("list", combinedList);  // Add combined list
            model.addAttribute("columns", columns);  // Pass the filtered columns
            model.addAttribute("tableList", metadataService.getTableNamesByCategory(dataType));
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("columnLabelMap", columnLabelMap);

            // Keep search conditions
            model.addAttribute("selectedTable", tableName);
            model.addAttribute("selectedStartDate", startDate);
            model.addAttribute("selectedEndDate", endDate);
            model.addAttribute("selectedLocation", location);
            model.addAttribute("selectedDataType", dataType);

            System.out.println("✅ 데이터 수: " + totalCount);
            System.out.println("✅ 총 페이지 수: " + totalPages);
        }

        return "list";  // list.jsp로 이동
    }

    
    @GetMapping("/api/station/data")
    @ResponseBody
    public List<Map<String, Object>> getData(
            @RequestParam String organization,  // 클라이언트에서 넘긴 organization
            @RequestParam String stations,  // 기상청: station_name, 환경부: ptnm
            @RequestParam String searchData) {  // 클라이언트에서 넘긴 searchData (station_name 또는 ptnm)
        
        // CQL 필터 작성
        String cqlFilter = buildCqlFilter(stations, organization, searchData);
        
        // 데이터를 GeoServer나 DB에서 조회하는 로직
        List<Map<String, Object>> data = geoServerWfsService.fetchFeaturesByLocationAndOrg(stations, organization, cqlFilter);
        
        return data;
    }

    private String buildCqlFilter(String stations, String organization, String searchData) {
        List<String> conditions = new ArrayList<>();

        if ("기상청".equals(organization)) {
            conditions.add("station_name IN ('" + searchData + "')");
        } else if ("환경부".equals(organization)) {
            conditions.add("ptnm IN ('" + searchData + "')");
        }

        return String.join(" AND ", conditions);
    }



    @GetMapping("/api/tables/by-category")
    @ResponseBody
    public List<String> getTablesByCategory(@RequestParam String category) {
        return metadataService.getTableNamesByCategory(category);
    }
}
