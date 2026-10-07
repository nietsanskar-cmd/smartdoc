package com.smartdoc.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "courses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "course_code", length = 20, nullable = false, unique = true)
    private String courseCode;

    @Column(name = "course_name", length = 150, nullable = false)
    private String courseName;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @Column(name = "total_semesters", nullable = false)
    @Builder.Default
    private Integer totalSemesters = 8;

    @Column(name = "degree_level", length = 50)
    @Builder.Default
    private String degreeLevel = "Undergraduate";

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (isActive == null) isActive = true;
        if (totalSemesters == null) totalSemesters = 8;
        if (degreeLevel == null) degreeLevel = "Undergraduate";
    }

    public Boolean getIsActive() {
        return isActive == null || isActive;
    }

    public boolean isActive() {
        return isActive == null || isActive;
    }
}
