package com.smartdoc.dto.response;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VerificationQueueDto {
    private Long documentId;
    private String documentCode;
    private String title;
    private String documentTypeName;
    private String categoryName;
    private String studentName;
    private String enrollmentNo;
    private String departmentName;
    private String fileName;
    private String mimeType;
    private LocalDateTime submittedAt;
    private Integer versionNumber;
}
