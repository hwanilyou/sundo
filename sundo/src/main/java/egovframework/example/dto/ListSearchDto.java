package egovframework.example.dto;

import java.time.LocalDate;

import egovframework.example.model.Metadata;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ListSearchDto {
    private String tableName;
    private String startDate;
    private String endDate;
    private String location;
}