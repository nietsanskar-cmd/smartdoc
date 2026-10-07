package com.smartdoc.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentShareCreateDto {
    @NotNull(message = "Document ID is required")
    private Long documentId;

    private String recipientEmail;
    private Integer durationHours;
    private Integer maxAccessCount;
    private String accessPasscode;
}
