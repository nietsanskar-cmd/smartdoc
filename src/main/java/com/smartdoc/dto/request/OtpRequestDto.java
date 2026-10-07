package com.smartdoc.dto.request;

import com.smartdoc.entity.enums.OtpPurpose;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OtpRequestDto {

    @NotBlank(message = "College email is required")
    @Email(message = "Please enter a valid email address")
    private String email;

    @NotNull(message = "Purpose is required")
    private OtpPurpose purpose;
}