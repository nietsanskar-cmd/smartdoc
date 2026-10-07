package com.smartdoc.entity;

import com.smartdoc.entity.enums.CompletenessTier;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "students")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "enrollment_no", length = 50, nullable = false, unique = true)
    private String enrollmentNo;

    @Column(name = "roll_no", length = 50, nullable = false, unique = true)
    private String rollNo;

    @Column(name = "first_name", length = 100, nullable = false)
    private String firstName;

    @Column(name = "last_name", length = 100, nullable = false)
    private String lastName;

    @Column(name = "dob")
    private LocalDate dob;

    @Column(name = "gender", length = 20)
    private String gender;

    @Column(name = "phone", length = 20)
    private String phone;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "academic_year_id", nullable = false)
    private AcademicYear academicYear;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "current_semester_id", nullable = false)
    private Semester currentSemester;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "assigned_faculty_id")
    private Faculty assignedFaculty;

    @Column(name = "completeness_score", precision = 5, scale = 2)
    @Builder.Default
    private BigDecimal completenessScore = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(name = "completeness_tier", length = 30)
    @Builder.Default
    private CompletenessTier completenessTier = CompletenessTier.CRITICAL;

    @Column(name = "profile_image_path", length = 255)
    private String profileImagePath;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public String getFullName() {
        return (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (completenessScore == null) completenessScore = BigDecimal.ZERO;
        if (completenessTier == null) completenessTier = CompletenessTier.CRITICAL;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
