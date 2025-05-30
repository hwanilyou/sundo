package egovframework.example.web;

import egovframework.example.model.Metadata;
import egovframework.example.service.CsvService;
import egovframework.example.service.MetadataService;
import egovframework.example.service.ShpService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Slf4j
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminUploadController {

	private final CsvService csvService;
    private final ShpService shpService;  // ShpService 주입
    private final MetadataService metadataService;
    /**
     * 🔼 [업로드] 기능: 기존 테이블에 데이터 갱신 (파일 내용만 반영)
     */
    @PostMapping("/upload")
    public String handleFileUpload(@RequestParam("file") MultipartFile file,
                                   @RequestParam("tableName") String tableName,
                                   Model model) {
        String fileName = file.getOriginalFilename();

        try {
            if (fileName != null && fileName.endsWith(".csv")) {
                csvService.updateCsvToTable(file, tableName);  // CSV 업로드 처리
            } else if (fileName != null && fileName.endsWith(".zip")) {
                shpService.updateTableWithShp(file, tableName);  // SHP 업로드 처리
            } else {
                throw new IllegalArgumentException("지원되지 않는 파일 형식입니다. (.csv 또는 .zip 만 허용)");
            }

            model.addAttribute("message", "✅ 업로드 성공");
        } catch (Exception e) {
            log.error("❌ 업로드 실패", e);
            model.addAttribute("error", "❌ 업로드 실패: " + e.getMessage());
        }

        return "redirect:/adminpage.do";
    }

    /**
     * 🆕 [등록] 기능: 새로운 테이블 생성 + 메타데이터 저장
     */
    @PostMapping("/register")
    public String handleRegister(@RequestParam("file") MultipartFile file,
                                 @RequestParam("tableName") String tableName,
                                 @RequestParam("title") String title,
                                 @RequestParam("organization") String organization,
                                 @RequestParam(value = "startDate", required = true) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
                                 @RequestParam(value = "endDate", required = true) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
                                 @RequestParam("fileType") String fileType,
                                 @RequestParam(value = "description", required = false) String description,  // description 필드 수정: required=false
                                 @RequestParam(value = "externalUrl", required = false) String externalUrl,
                                 @RequestParam(value = "dataInformation", required = false) String dataInformation,
                                 Model model) {
        // 필수값 체크
        if (startDate == null || endDate == null) {
            model.addAttribute("error", "❌ 시작일과 종료일은 필수 항목입니다.");
            return "redirect:/adminpage.do";
        }

        try {
            // 파일 처리 로직
            if (fileType.equals("csv")) {
                csvService.createTableAndInsert(file, tableName);
            } else if (fileType.equals("shp")) {
                shpService.importShpToPostGIS(file, tableName);
            } else {
                throw new IllegalArgumentException("지원되지 않는 파일 형식입니다.");
            }

            // 메타데이터 등록
            Metadata metadata = Metadata.builder()
                    .tableName(tableName)
                    .title(title)
                    .organization(organization)
                    .startDate(startDate)
                    .endDate(endDate)
                    .description(description != null ? description : "")  // description 처리: null일 경우 빈 문자열로 설정
                    .externalUrl(externalUrl)
                    .dataInformation(dataInformation)
                    .createdAt(LocalDateTime.now())
                    .build();
            metadataService.save(metadata);

            model.addAttribute("message", "✅ 등록 성공");
        } catch (Exception e) {
            model.addAttribute("error", "❌ 등록 실패: " + e.getMessage());
        }

        return "redirect:/adminpage.do";
    }

    
    



}
