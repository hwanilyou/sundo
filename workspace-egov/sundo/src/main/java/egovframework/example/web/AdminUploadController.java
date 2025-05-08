//package egovframework.example.web;
//
//import egovframework.example.service.CsvService;
//import egovframework.example.service.ShpService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//@Controller
//@RequestMapping("/admin")
//public class AdminUploadController {
//
//    private final CsvService csvService;
//    private final ShpService shpService;
//
//    @Autowired
//    public AdminUploadController(CsvService csvService, ShpService shpService) {
//        this.csvService = csvService;
//        this.shpService = shpService;
//    }
//
//    @PostMapping("/upload")
//    public String handleFileUpload(@RequestParam("file") MultipartFile file,
//                                   @RequestParam("dataType") String dataType,
//                                   Model model) {
//
//        String fileName = file.getOriginalFilename();
//
//        try {
//            if (fileName != null && fileName.endsWith(".csv")) {
//                csvService.saveCsvToDatabase(file, dataType);
//            } else if (fileName != null && fileName.endsWith(".zip")) {
//                shpService.importShpToPostGIS(file, dataType);
//            } else {
//                throw new IllegalArgumentException("지원되지 않는 파일 형식입니다.");
//            }
//            model.addAttribute("message", "파일 업로드 성공");
//        } catch (Exception e) {
//            model.addAttribute("error", "업로드 실패: " + e.getMessage());
//        }
//
//        return "redirect:/adminpage.do";
//    }
//}
