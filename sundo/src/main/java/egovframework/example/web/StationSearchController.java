package egovframework.example.web;

import egovframework.example.service.StationMetadataService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/station")
@RequiredArgsConstructor
public class StationSearchController {

    @Autowired
    private StationMetadataService stationMetadataService;

    // 기관에 따라 조건 분기 (기상청이면 stn/station_name, 환경부면 대권역 리스트)
    @GetMapping("/list-by-organization")
    public ResponseEntity<?> getStationListByOrganization(@RequestParam String organization) {
        if ("기상청".equals(organization)) {
            return ResponseEntity.ok(stationMetadataService.getKmaStationList());
        } else if ("환경부".equals(organization)) {
            return ResponseEntity.ok(stationMetadataService.getFirstBasins());
        } else {
            return ResponseEntity.badRequest().body("지원하지 않는 기관입니다.");
        }
    }

    @GetMapping("/major-basins")
    public ResponseEntity<List<String>> getMajorBasins(@RequestParam("firstBasin") String firstBasin) {
        System.out.println("Received firstBasin in Controller: " + firstBasin); // 여기서 값 확인

        try {
            String decodedFirstBasin = URLDecoder.decode(firstBasin, "UTF-8");
            System.out.println("Decoded firstBasin: " + decodedFirstBasin); // 디코딩 후 값 확인

            if (decodedFirstBasin.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(List.of("firstBasin 값이 비어있습니다."));
            }

            List<String> majorBasins = stationMetadataService.getMajorBasinsByFirst(decodedFirstBasin);
            return ResponseEntity.ok(majorBasins);

        } catch (UnsupportedEncodingException e) {
            System.err.println("디코딩 오류 발생: " + e.getMessage());
            return ResponseEntity.status(500).build();
        }
    }



    @GetMapping("/mid-basins")
    public ResponseEntity<List<String>> getMidBasins(@RequestParam String majorBasin) {
        return ResponseEntity.ok(stationMetadataService.getMidBasinsByMajor(majorBasin));
    }

    @GetMapping("/stations-by-mid")
    public ResponseEntity<List<String>> getStationsByMid(@RequestParam String midBasin) {
        return ResponseEntity.ok(stationMetadataService.getStationsByMidBasin(midBasin));
    }
    
    
//    @GetMapping("/search-data")
//    public ResponseEntity<List<Map<String, Object>>> getDataByConditions(
//        @RequestParam String searchData, 
//        @RequestParam String tableName, 
//        @RequestParam String startDate, 
//        @RequestParam String endDate, 
//        @RequestParam String organization, 
//        @RequestParam String firstBasin, 
//        @RequestParam String majorBasin, 
//        @RequestParam String midBasin, 
//        @RequestParam List<String> stations) {
//
//        try {
//            List<Map<String, Object>> data = stationMetadataService.getDataByConditions(
//                searchData, tableName, startDate, endDate, organization, firstBasin, majorBasin, midBasin, stations);
//            return ResponseEntity.ok(data);
//        } catch (Exception e) {
//            return ResponseEntity.status(500).body(null);  // 오류 처리
//        }
//    }

}
