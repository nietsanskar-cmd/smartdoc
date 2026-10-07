package com.smartdoc.dto.response;

import com.smartdoc.entity.enums.RoleType;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserSummaryDto {
    private Long id;
    private String username;
    private String email;
    private RoleType role;
    private Boolean isActive;
    private String displayName;
}
