package com.smartdoc.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "document_share_logs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentShareLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "share_id", nullable = false)
    private DocumentShare documentShare;

    @Column(name = "accessed_at")
    private LocalDateTime accessedAt;

    @Column(name = "ip_address", length = 50)
    private String ipAddress;

    @Column(name = "user_agent", length = 255)
    private String userAgent;

    @Column(name = "access_status", length = 50, nullable = false)
    private String accessStatus;

    @PrePersist
    protected void onCreate() {
        if (accessedAt == null) accessedAt = LocalDateTime.now();
    }
}
