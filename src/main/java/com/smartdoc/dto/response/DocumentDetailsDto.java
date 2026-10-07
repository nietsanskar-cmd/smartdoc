package com.smartdoc.dto.response;

import com.smartdoc.entity.enums.DocumentStatus;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentDetailsDto {
    private Long id;
    private String documentCode;
    private Long studentId;
    private String studentName;
    private String enrollmentNo;
    private Long documentTypeId;
    private String documentTypeName;
    private String categoryName;
    private String iconClass;
    private String title;
    private Integer currentVersion;
    private DocumentStatus status;
    private String fileName;
    private Long fileSizeBytes;
    private String formattedFileSize;
    private String mimeType;
    private String sha256Hash;
    private String verificationToken;
    private String qrCodePath;
    private LocalDate issueDate;
    private LocalDate expiryDate;
    private LocalDateTime verifiedAt;
    private String verifiedByName;
    private String rejectionReason;
    private String rejectionRemarks;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
