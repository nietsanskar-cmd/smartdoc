package com.smartdoc.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentRequestCreateDto {
    @NotNull(message = "Document Type is required")
    private Long documentTypeId;

    @NotBlank(message = "Purpose is required")
    private String purpose;
}
