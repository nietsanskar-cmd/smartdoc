package com.smartdoc.dto.response;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShareDetailsDto {
    private Long id;
    private Long documentId;
    private String documentTitle;
    private String documentTypeName;
    private String shareToken;
    private String shareUrl;
    private String recipientEmail;
    private boolean hasPasscode;
    private LocalDateTime expiresAt;
    private Integer maxAccessCount;
    private Integer currentAccessCount;
    private Boolean isRevoked;
    private boolean isExpired;
    private LocalDateTime createdAt;
}
