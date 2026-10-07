package com.smartdoc.dto.response;

import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PublicVerificationDto {
    private boolean isValid;
    private String verificationToken;
    private String documentCode;
    private String documentTypeName;
    private String categoryName;
    private String studentMaskedName;
    private String enrollmentNoMasked;
    private String departmentName;
    private String institutionName;
    private String status;
    private LocalDateTime verifiedAt;
    private String verifiedByDesignation;
    private LocalDate issueDate;
    private LocalDate expiryDate;
    private String sha256Fingerprint;
}
