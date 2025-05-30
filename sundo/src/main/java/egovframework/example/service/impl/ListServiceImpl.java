package egovframework.example.service.impl;

import egovframework.example.dto.ListSearchDto;
import egovframework.example.model.Metadata;
import egovframework.example.repository.MetadataRepository;
import egovframework.example.service.GeoServerWfsService;
import egovframework.example.service.ListService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ListServiceImpl implements ListService {

    private final MetadataRepository metadataRepository;
    private final GeoServerWfsService geoServerWfsService;

    @Override
    public List<Map<String, Object>> search(String tableName, String dateColumn, String regionColumn,
                                            String startDate, String endDate, String location) {
        return geoServerWfsService.fetchFeatures(tableName, dateColumn, startDate, endDate, location, 9999, 0);
    }

    @Override
    public List<Map<String, Object>> searchPaged(String tableName, String dateColumn, String regionColumn,
                                                 String startDate, String endDate, String location,
                                                 int limit, int offset) {
        return geoServerWfsService.fetchFeatures(tableName, dateColumn, startDate, endDate, location, limit, offset);
    }

    @Override
    public int count(String tableName, String dateColumn, String regionColumn,
                     String startDate, String endDate, String location) {
        return geoServerWfsService.countFeatures(tableName, dateColumn, startDate, endDate, location);
    }

    @Override
    public List<String> getAllCategories() {
        return metadataRepository.findAll().stream()
                .map(Metadata::getCategory)
                .distinct()
                .collect(Collectors.toList());
    }

    @Override
    public List<String> getTableNamesByCategory(String category) {
        return metadataRepository.findByCategory(category).stream()
                .map(Metadata::getTableName)
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> searchData(ListSearchDto dto) throws Exception {
        return searchData(dto.getTableName(), dto.getStartDate(), dto.getEndDate(), dto.getLocation());
    }

    @Override
    public List<Map<String, Object>> searchData(String tableName, String startDate, String endDate, String location) {
        Metadata metadata = metadataRepository.findByTableName(tableName).orElse(null);
        String dateColumn = metadata != null ? metadata.getDateColumn() : "date";
        String regionColumn = metadata != null ? metadata.getRegionColumn() : null;
        return search(tableName, dateColumn, regionColumn, startDate, endDate, location);
    }
    
    
    
    
    
}
