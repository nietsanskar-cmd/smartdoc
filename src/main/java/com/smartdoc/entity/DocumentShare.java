package com.smartdoc.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "document_shares")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentShare {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "document_id", nullable = false)
    private Document document;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(name = "share_token", length = 100, nullable = false, unique = true)
    private String shareToken;

    @Column(name = "recipient_email", length = 150)
    private String recipientEmail;

    @Column(name = "access_passcode_hash", length = 255)
    private String accessPasscodeHash;

    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    @Column(name = "max_access_count")
    @Builder.Default
    private Integer maxAccessCount = 10;

    @Column(name = "current_access_count")
    @Builder.Default
    private Integer currentAccessCount = 0;

    @Column(name = "is_revoked")
    @Builder.Default
    private Boolean isRevoked = false;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public boolean isExpired() {
        return (expiresAt != null && LocalDateTime.now().isAfter(expiresAt)) ||
               (maxAccessCount != null && currentAccessCount >= maxAccessCount) ||
               Boolean.TRUE.equals(isRevoked);
    }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (maxAccessCount == null) maxAccessCount = 10;
        if (currentAccessCount == null) currentAccessCount = 0;
        if (isRevoked == null) isRevoked = false;
    }
}
