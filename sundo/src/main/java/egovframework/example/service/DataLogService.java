package egovframework.example.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import egovframework.example.dto.DataLogDTO;
import egovframework.example.entity.DataLogEntity;
import egovframework.example.repository.DataLogRepository;

@Service
public class DataLogService {

    private final DataLogRepository dataLogRepository;

    public DataLogService(DataLogRepository dataLogRepository) {
        this.dataLogRepository = dataLogRepository;
    }

    public List<DataLogDTO> getUpdateLogs() {
        List<DataLogEntity> entities = dataLogRepository.findAllByOrderByExecutedAtDesc();

        return entities.stream()
                .map(e -> new DataLogDTO(
                        e.getId(),
                        e.getOrganization(),
                        e.getDataName(),
                        e.getDataCount(),
                        e.getStatus(),
                        e.getExecutedAt(),
                        e.getSuccessCount(),
                        e.getErrorCount(),
                        e.getBaseDate(),
                        e.getLastUpdated(),
                        e.getNextUpdate()
                ))
                .collect(Collectors.toList());
    }
    
    public List<DataLogDTO> getLatestLogsByDataName() {
        List<DataLogEntity> entities = dataLogRepository.findLatestByDataName();

        return entities.stream()
                .map(e -> new DataLogDTO(
                        e.getId(),
                        e.getOrganization(),
                        e.getDataName(),
                        e.getDataCount(),
                        e.getStatus(),
                        e.getExecutedAt(),
                        e.getSuccessCount(),
                        e.getErrorCount(),
                        e.getBaseDate(),
                        e.getLastUpdated(),
                        e.getNextUpdate()
                ))
                .collect(Collectors.toList());
    }
}
