package com.smartdoc.dto.response;

import com.smartdoc.entity.enums.CompletenessTier;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentProfileDto {
    private Long id;
    private Long userId;
    private String username;
    private String email;
    private String enrollmentNo;
    private String rollNo;
    private String firstName;
    private String lastName;
    private String fullName;
    private LocalDate dob;
    private String gender;
    private String phone;
    private String departmentName;
    private String deptCode;
    private String courseName;
    private String courseCode;
    private String academicYear;
    private Integer semesterNumber;
    private String facultyAdvisorName;
    private BigDecimal completenessScore;
    private CompletenessTier completenessTier;
    private String profileImagePath;
}
