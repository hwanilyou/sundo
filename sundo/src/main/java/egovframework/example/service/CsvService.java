package egovframework.example.service;

import org.springframework.web.multipart.MultipartFile;

public interface CsvService {
    void saveCsvToDatabase(MultipartFile file, String dataType) throws Exception;
    
    void createTableAndInsert(MultipartFile file, String tableName) throws Exception;
    
    void updateTableWithCsv(MultipartFile file, String tableName) throws Exception;
    
    void updateCsvToTable(MultipartFile file, String tableName) throws Exception;


}