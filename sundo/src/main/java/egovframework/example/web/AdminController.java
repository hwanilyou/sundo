package egovframework.example.web;

import egovframework.example.model.Metadata;
import egovframework.example.service.MetadataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminController {

    private final MetadataService metadataService;

    @GetMapping("/adminpage.do")
    public String adminPage(Model model) {
        try {
            List<Metadata> metadataList = metadataService.findAll(); // 메타데이터 조회
            if (metadataList.isEmpty()) {
                model.addAttribute("error", "조회된 데이터가 없습니다.");
            } else {
                model.addAttribute("metadataList", metadataList);  // 메타데이터 리스트를 모델에 추가
            }
        } catch (Exception e) {
            model.addAttribute("error", "메타데이터 목록 조회 실패: " + e.getMessage());
            log.error("메타데이터 목록 조회 실패", e);
        }
        return "admin-dashboard"; // admin-dashboard.jsp로 이동
    }

    @PostMapping("/admin/update")
    public String updateMetadata(
            @RequestParam("id") Long id,
            @RequestParam("tableName") String tableName,
            @RequestParam("title") String title,
            @RequestParam("organization") String organization,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(value = "description", required = false) String description,  // description 필드 optional
            @RequestParam(value = "externalUrl", required = false) String externalUrl,   // externalUrl 필드 optional
            @RequestParam(value = "dataInformation", required = false) String dataInformation,  // dataInformation 필드 optional
            @RequestParam(value = "category", required = false) String category  // 카테고리 필드 추가
    ) {
        try {
            // 1. 기존 메타데이터 조회
            Metadata metadata = metadataService.findById(id);  // id로 기존 메타데이터 찾기

            // 2. 수정할 메타데이터 값 설정
            metadata.setTableName(tableName);
            metadata.setTitle(title);
            metadata.setOrganization(organization);
            metadata.setStartDate(startDate);
            metadata.setEndDate(endDate);
            metadata.setDescription(description != null ? description : "");  // null이 아닌 경우에만 description 설정
            metadata.setExternalUrl(externalUrl);
            metadata.setDataInformation(dataInformation);
            metadata.setCategory(category != null ? category : "");  // category 처리: null일 경우 빈 문자열 설정

            // createdAt은 수정하지 않도록 합니다. -> 기존 값 유지
            // metadata.setCreatedAt(LocalDateTime.now()); // 이 부분은 제거해야 합니다.

            // 3. 메타데이터 업데이트
            metadataService.update(metadata);  // 수정된 메타데이터를 업데이트

            // 4. 성공 메시지 리다이렉트
            String message = URLEncoder.encode("수정 성공", StandardCharsets.UTF_8);
            return "redirect:/adminpage.do?message=" + message;

        } catch (Exception e) {
            log.error("❌ 메타데이터 수정 실패", e);
            String error = URLEncoder.encode("수정 실패", StandardCharsets.UTF_8);
            return "redirect:/adminpage.do?error=" + error;
        }
    }



    @PostMapping("/admin/delete")
    @ResponseBody
    public ResponseEntity<?> deleteMetadata(@RequestParam Long id) {
        try {
            metadataService.deleteById(id);  // 메타데이터 삭제
            return ResponseEntity.ok("삭제 완료");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제 실패: " + e.getMessage());
        }
    }

    @GetMapping("/admin/view")
    public String viewMetadataTable(@RequestParam Long id, Model model) {
        try {
            // 1. 메타데이터 조회
            Metadata metadata = metadataService.findById(id);

            // 2. 테이블명 가져오기
            String tableName = metadata.getTableName();

            // 3. 실제 테이블 데이터 조회
            List<Map<String, Object>> tableData = metadataService.getTableData(tableName);

            // 4. 모델에 데이터 전달
            model.addAttribute("metadata", metadata);
            model.addAttribute("tableData", tableData);

        } catch (Exception e) {
            model.addAttribute("error", "데이터 조회 실패: " + e.getMessage());
        }

        return "admin-table-view";  // 해당 JSP에서 메타데이터 및 테이블 데이터 출력
    }


    @ResponseBody
    @GetMapping("/admin/table-data")
    public List<List<String>> getTableData(@RequestParam String tableName) {
        return metadataService.fetchTableDataPreview(tableName);  // 테이블 미리보기 데이터 조회
    }
}
