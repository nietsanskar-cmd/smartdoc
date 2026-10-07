package com.smartdoc.dto.request;

import com.smartdoc.entity.enums.VerificationAction;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentVerificationDto {
    @NotNull(message = "Action is required")
    private VerificationAction action;

    private String remarks;
    private String reasonCode;
}
