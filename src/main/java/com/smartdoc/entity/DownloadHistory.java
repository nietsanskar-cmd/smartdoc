package com.smartdoc.entity;

import com.smartdoc.entity.enums.DownloadType;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "download_history")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DownloadHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "document_id", nullable = false)
    private Document document;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "downloaded_by_user_id")
    private User downloadedByUser;

    @Enumerated(EnumType.STRING)
    @Column(name = "download_type", length = 50, nullable = false)
    private DownloadType downloadType;

    @Column(name = "ip_address", length = 50)
    private String ipAddress;

    @Column(name = "downloaded_at", updatable = false)
    private LocalDateTime downloadedAt;

    @PrePersist
    protected void onCreate() {
        if (downloadedAt == null) downloadedAt = LocalDateTime.now();
    }
}
