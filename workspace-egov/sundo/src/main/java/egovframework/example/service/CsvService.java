package egovframework.example.service;

import org.springframework.web.multipart.MultipartFile;

public interface CsvService {
    void saveCsvToDatabase(MultipartFile file, String dataType) throws Exception;
}