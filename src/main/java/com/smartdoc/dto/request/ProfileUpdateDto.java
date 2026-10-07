package com.smartdoc.dto.request;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProfileUpdateDto {
    private String firstName;
    private String lastName;
    private String phone;
    private String currentPassword;
    private String newPassword;
}
