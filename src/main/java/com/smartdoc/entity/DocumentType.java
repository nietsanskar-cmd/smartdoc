package com.smartdoc.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "document_types")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id", nullable = false)
    private DocumentCategory category;

    @Column(name = "type_code", length = 50, nullable = false, unique = true)
    private String typeCode;

    @Column(name = "type_name", length = 150, nullable = false)
    private String typeName;

    @Column(name = "description", length = 255)
    private String description;

    @Column(name = "is_expiry_applicable")
    @Builder.Default
    private Boolean isExpiryApplicable = false;

    @Column(name = "default_validity_months")
    @Builder.Default
    private Integer defaultValidityMonths = 0;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (isExpiryApplicable == null) isExpiryApplicable = false;
        if (defaultValidityMonths == null) defaultValidityMonths = 0;
        if (isActive == null) isActive = true;
    }

    public Boolean getIsExpiryApplicable() {
        return isExpiryApplicable != null && isExpiryApplicable;
    }

    public boolean isExpiryApplicable() {
        return Boolean.TRUE.equals(isExpiryApplicable);
    }

    public Boolean getIsActive() {
        return isActive == null || isActive;
    }

    public boolean isActive() {
        return isActive == null || isActive;
    }
}
