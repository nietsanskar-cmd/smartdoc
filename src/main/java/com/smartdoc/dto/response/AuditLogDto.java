package com.smartdoc.dto.response;

import com.smartdoc.entity.enums.AuditAction;
import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuditLogDto {
    private Long id;
    private String username;
    private AuditAction action;
    private String entityType;
    private Long entityId;
    private String ipAddress;
    private String details;
    private LocalDateTime createdAt;
}
