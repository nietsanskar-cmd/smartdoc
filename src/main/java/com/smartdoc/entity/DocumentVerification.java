package com.smartdoc.entity;

import com.smartdoc.entity.enums.VerificationAction;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "document_verifications")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "document_id", nullable = false)
    private Document document;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "faculty_id")
    private Faculty faculty;

    @Enumerated(EnumType.STRING)
    @Column(name = "action", length = 50, nullable = false)
    private VerificationAction action;

    @Column(name = "remarks", columnDefinition = "TEXT")
    private String remarks;

    @Column(name = "reason_code", length = 100)
    private String reasonCode;

    @Column(name = "decision_date")
    private LocalDateTime decisionDate;

    @PrePersist
    protected void onCreate() {
        if (decisionDate == null) decisionDate = LocalDateTime.now();
    }
}
