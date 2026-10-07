package com.smartdoc.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentRegistrationDto {
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    private String username;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    @NotBlank(message = "Email is required")
    @Email(message = "Please provide a valid email address")
    private String email;

    @NotBlank(message = "Enrollment Number is required")
    private String enrollmentNo;

    @NotBlank(message = "Roll Number is required")
    private String rollNo;

    @NotBlank(message = "First name is required")
    private String firstName;

    @NotBlank(message = "Last name is required")
    private String lastName;

    private LocalDate dob;
    private String gender;
    private String phone;

    @NotNull(message = "Department is required")
    private Long departmentId;

    @NotNull(message = "Course is required")
    private Long courseId;

    @NotNull(message = "Academic Year is required")
    private Long academicYearId;

    @NotNull(message = "Semester is required")
    private Long currentSemesterId;

    private Long assignedFacultyId;
}
