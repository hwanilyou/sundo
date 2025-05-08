package egovframework.example.service;


import org.springframework.web.multipart.MultipartFile;

public interface ShpService {
    void importShpToPostGIS(MultipartFile zipFile, String dataType) throws Exception;
}