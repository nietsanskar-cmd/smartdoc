package com.smartdoc.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentUploadDto {
    @NotBlank(message = "Title is required")
    private String title;

    @NotNull(message = "Document Type is required")
    private Long documentTypeId;

    private LocalDate issueDate;
    private LocalDate expiryDate;

    private MultipartFile file;
    private String changeSummary;
}
