package com.smartdoc.service.impl;

import com.smartdoc.dto.request.FacultyRegistrationDto;
import com.smartdoc.dto.request.LoginRequestDto;
import com.smartdoc.dto.request.StudentRegistrationDto;
import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.AuditAction;
import com.smartdoc.entity.enums.CompletenessTier;
import com.smartdoc.entity.enums.RoleType;
import com.smartdoc.exception.UnauthorizedAccessException;
import com.smartdoc.exception.UserNotFoundException;
import com.smartdoc.repository.*;
import com.smartdoc.security.PasswordEncoderUtil;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.AuditLogService;
import com.smartdoc.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final StudentRepository studentRepository;
    private final FacultyRepository facultyRepository;
    private final DepartmentRepository departmentRepository;
    private final CourseRepository courseRepository;
    private final AcademicYearRepository academicYearRepository;
    private final SemesterRepository semesterRepository;
    private final LoginHistoryRepository loginHistoryRepository;
    private final PasswordEncoderUtil passwordEncoder;
    private final AuditLogService auditLogService;
    private final com.smartdoc.service.OtpService otpService;

    @Override
    @Transactional
    public UserSession authenticate(LoginRequestDto loginDto, String ipAddress, String userAgent) {
        String identifier = loginDto.getUsername() != null ? loginDto.getUsername().trim() : "";

        // If identifier contains @, enforce @niet.co.in validation
        if (identifier.contains("@")) {
            otpService.validateNietDomain(identifier);
        }

        User user = userRepository.findByUsernameOrEmail(identifier, identifier)
                .or(() -> studentRepository.findByRollNo(identifier).map(Student::getUser))
                .or(() -> studentRepository.findByEnrollmentNo(identifier).map(Student::getUser))
                .orElseThrow(() -> {
                    auditLogService.logAction(null, AuditAction.LOGIN_FAILED, "USER", null, ipAddress, "Failed login attempt for identifier: " + identifier);
                    return new UnauthorizedAccessException("Invalid college ID or password");
                });

        if (!Boolean.TRUE.equals(user.getIsActive())) {
            throw new UnauthorizedAccessException("Account is suspended. Please contact administrator.");
        }

        if (!Boolean.TRUE.equals(user.getEmailVerified())) {
            throw new UnauthorizedAccessException("Please verify your college email before logging in.");
        }

        if (!passwordEncoder.matches(loginDto.getPassword(), user.getPasswordHash())) {
            auditLogService.logAction(user, AuditAction.LOGIN_FAILED, "USER", user.getId(), ipAddress, "Incorrect password attempt");
            throw new UnauthorizedAccessException("Invalid college ID or password");
        }

        // Record successful login history
        LoginHistory history = LoginHistory.builder()
                .user(user)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .status("SUCCESS")
                .build();
        loginHistoryRepository.save(history);

        auditLogService.logAction(user, AuditAction.LOGIN, "USER", user.getId(), ipAddress, "User logged in successfully");

        UserSession.UserSessionBuilder sessionBuilder = UserSession.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .role(user.getRole().getRoleName())
                .loginTime(LocalDateTime.now());

        if (RoleType.ROLE_STUDENT.equals(user.getRole().getRoleName())) {
            studentRepository.findByUserId(user.getId()).ifPresent(s -> {
                sessionBuilder.studentId(s.getId());
                sessionBuilder.fullName(s.getFullName() != null && !s.getFullName().trim().isEmpty() ? s.getFullName().trim() : user.getUsername());
                sessionBuilder.departmentName(s.getDepartment() != null ? s.getDepartment().getDeptName() : "General Engineering");
            });
        } else if (RoleType.ROLE_FACULTY.equals(user.getRole().getRoleName())) {
            facultyRepository.findByUserId(user.getId()).ifPresent(f -> {
                sessionBuilder.facultyId(f.getId());
                sessionBuilder.fullName(f.getFullName() != null && !f.getFullName().trim().isEmpty() ? f.getFullName().trim() : user.getUsername());
                sessionBuilder.departmentName(f.getDepartment() != null ? f.getDepartment().getDeptName() : "Faculty of Engineering");
            });
        } else {
            sessionBuilder.fullName("Administrator");
            sessionBuilder.departmentName("Administration");
        }

        return sessionBuilder.build();
    }

    @Override
    @Transactional
    public User registerStudent(StudentRegistrationDto dto) {
        if (userRepository.existsByUsername(dto.getUsername())) {
            throw new IllegalArgumentException("Username already exists: " + dto.getUsername());
        }
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + dto.getEmail());
        }

        Role role = roleRepository.findByRoleName(RoleType.ROLE_STUDENT)
                .orElseThrow(() -> new IllegalStateException("Student role not configured"));

        User user = User.builder()
                .username(dto.getUsername())
                .passwordHash(passwordEncoder.encode(dto.getPassword()))
                .email(dto.getEmail())
                .role(role)
                .isActive(true)
                .build();
        user = userRepository.save(user);

        Department dept = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new IllegalArgumentException("Invalid department ID"));
        Course course = courseRepository.findById(dto.getCourseId())
                .orElseThrow(() -> new IllegalArgumentException("Invalid course ID"));
        AcademicYear year = academicYearRepository.findById(dto.getAcademicYearId())
                .orElseThrow(() -> new IllegalArgumentException("Invalid academic year ID"));
        Semester sem = semesterRepository.findById(dto.getCurrentSemesterId())
                .orElseThrow(() -> new IllegalArgumentException("Invalid semester ID"));

        Faculty faculty = null;
        if (dto.getAssignedFacultyId() != null) {
            faculty = facultyRepository.findById(dto.getAssignedFacultyId()).orElse(null);
        }

        Student student = Student.builder()
                .user(user)
                .enrollmentNo(dto.getEnrollmentNo())
                .rollNo(dto.getRollNo())
                .firstName(dto.getFirstName())
                .lastName(dto.getLastName())
                .dob(dto.getDob())
                .gender(dto.getGender())
                .phone(dto.getPhone())
                .department(dept)
                .course(course)
                .academicYear(year)
                .currentSemester(sem)
                .assignedFaculty(faculty)
                .completenessScore(BigDecimal.ZERO)
                .completenessTier(CompletenessTier.CRITICAL)
                .build();
        studentRepository.save(student);

        auditLogService.logAction(user, AuditAction.CREATE_USER, "STUDENT", student.getId(), "127.0.0.1", "Registered new student account: " + dto.getEnrollmentNo());

        return user;
    }

    @Override
    @Transactional
    public User registerFaculty(FacultyRegistrationDto dto) {
        if (userRepository.existsByUsername(dto.getUsername())) {
            throw new IllegalArgumentException("Username already exists: " + dto.getUsername());
        }
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + dto.getEmail());
        }

        Role role = roleRepository.findByRoleName(RoleType.ROLE_FACULTY)
                .orElseThrow(() -> new IllegalStateException("Faculty role not configured"));

        User user = User.builder()
                .username(dto.getUsername())
                .passwordHash(passwordEncoder.encode(dto.getPassword()))
                .email(dto.getEmail())
                .role(role)
                .isActive(true)
                .build();
        user = userRepository.save(user);

        Department dept = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new IllegalArgumentException("Invalid department ID"));

        Faculty faculty = Faculty.builder()
                .user(user)
                .employeeCode(dto.getEmployeeCode())
                .firstName(dto.getFirstName())
                .lastName(dto.getLastName())
                .phone(dto.getPhone())
                .department(dept)
                .designation(dto.getDesignation())
                .qualification(dto.getQualification())
                .build();
        facultyRepository.save(faculty);

        auditLogService.logAction(user, AuditAction.CREATE_USER, "FACULTY", faculty.getId(), "127.0.0.1", "Registered new faculty account: " + dto.getEmployeeCode());

        return user;
    }

    @Override
    @Transactional
    public void toggleUserStatus(Long userId) {
        User user = findById(userId);
        user.setIsActive(!Boolean.TRUE.equals(user.getIsActive()));
        userRepository.save(user);
        auditLogService.logAction(user, user.getIsActive() ? AuditAction.ACTIVATE_USER : AuditAction.DEACTIVATE_USER, "USER", user.getId(), "127.0.0.1", "User status changed to " + user.getIsActive());
    }

    @Override
    @Transactional
    public void resetPassword(Long userId, String newPassword) {
        User user = findById(userId);
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        auditLogService.logAction(user, AuditAction.UPDATE_USER, "USER", user.getId(), "127.0.0.1", "Administrator reset password for user: " + user.getUsername());
    }

    @Override
    @Transactional
    public void updatePassword(Long userId, String oldPassword, String newPassword) {
        User user = findById(userId);
        if (!passwordEncoder.matches(oldPassword, user.getPasswordHash())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        auditLogService.logAction(user, AuditAction.UPDATE_USER, "USER", user.getId(), "127.0.0.1", "User updated their own password");
    }

    @Override
    @Transactional
    public User registerStudentWithVerifiedEmail(com.smartdoc.dto.request.CreatePasswordDto dto) {
        String email = dto.getEmail() != null ? dto.getEmail().trim().toLowerCase() : "";
        otpService.validateNietDomain(email);

        if (!otpService.isOtpVerified(email, com.smartdoc.entity.enums.OtpPurpose.REGISTRATION)) {
            throw new IllegalArgumentException("Please complete OTP verification before creating your password.");
        }

        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new IllegalArgumentException("Passwords do not match.");
        }

        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("This college ID is already registered. Please login instead.");
        }

        String username = email.substring(0, email.indexOf("@"));
        if (userRepository.existsByUsername(username)) {
            username = username + "_" + System.currentTimeMillis() % 1000;
        }

        Role role = roleRepository.findByRoleName(RoleType.ROLE_STUDENT)
                .orElseThrow(() -> new IllegalStateException("Student role not configured in database"));

        User user = User.builder()
                .username(username)
                .passwordHash(passwordEncoder.encode(dto.getPassword()))
                .email(email)
                .role(role)
                .isActive(true)
                .emailVerified(true)
                .build();
        user = userRepository.save(user);

        // Auto-assign default department, course, year, semester so student features work immediately
        Department dept = departmentRepository.findAll().stream().findFirst().orElse(null);
        Course course = courseRepository.findAll().stream().findFirst().orElse(null);
        AcademicYear year = academicYearRepository.findAll().stream().findFirst().orElse(null);
        Semester sem = semesterRepository.findAll().stream().findFirst().orElse(null);

        String firstName = (dto.getFirstName() != null && !dto.getFirstName().trim().isEmpty())
                ? dto.getFirstName().trim()
                : (username.toUpperCase());
        String lastName = (dto.getLastName() != null && !dto.getLastName().trim().isEmpty())
                ? dto.getLastName().trim()
                : "Student";

        String rawRollNo = (dto.getRollNo() != null && !dto.getRollNo().trim().isEmpty())
                ? dto.getRollNo().trim().toUpperCase()
                : username.toUpperCase();
        
        String rollNo = rawRollNo;
        if (studentRepository.existsByRollNo(rollNo)) {
            rollNo = rawRollNo + "_" + (System.currentTimeMillis() % 1000);
        }

        String enrollmentNo = username.toUpperCase();
        if (studentRepository.existsByEnrollmentNo(enrollmentNo)) {
            enrollmentNo = username.toUpperCase() + "_" + (System.currentTimeMillis() % 1000);
        }

        Student student = Student.builder()
                .user(user)
                .enrollmentNo(enrollmentNo)
                .rollNo(rollNo)
                .firstName(firstName)
                .lastName(lastName)
                .department(dept)
                .course(course)
                .academicYear(year)
                .currentSemester(sem)
                .completenessScore(BigDecimal.ZERO)
                .completenessTier(CompletenessTier.CRITICAL)
                .build();
        studentRepository.save(student);

        auditLogService.logAction(user, AuditAction.CREATE_USER, "USER", user.getId(), "127.0.0.1", "Registered new verified student account via OTP: " + email);

        otpService.invalidateOtp(email, com.smartdoc.entity.enums.OtpPurpose.REGISTRATION);
        return user;
    }

    @Override
    @Transactional
    public void resetPasswordWithVerifiedEmail(com.smartdoc.dto.request.ResetPasswordDto dto) {
        String email = dto.getEmail() != null ? dto.getEmail().trim().toLowerCase() : "";
        otpService.validateNietDomain(email);

        if (!otpService.isOtpVerified(email, com.smartdoc.entity.enums.OtpPurpose.PASSWORD_RESET)) {
            throw new IllegalArgumentException("Please complete OTP verification before resetting your password.");
        }

        if (!dto.getNewPassword().equals(dto.getConfirmPassword())) {
            throw new IllegalArgumentException("Passwords do not match.");
        }

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException("No registered account found with email: " + email));

        user.setPasswordHash(passwordEncoder.encode(dto.getNewPassword()));
        user.setEmailVerified(true);
        userRepository.save(user);

        auditLogService.logAction(user, AuditAction.UPDATE_USER, "USER", user.getId(), "127.0.0.1", "Password reset successfully via OTP for: " + email);

        otpService.invalidateOtp(email, com.smartdoc.entity.enums.OtpPurpose.PASSWORD_RESET);
    }

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmail(email != null ? email.trim().toLowerCase() : "")
                .orElseThrow(() -> new UserNotFoundException("User not found with email: " + email));
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with id: " + id));
    }

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new UserNotFoundException("User not found with username: " + username));
    }

    @Override
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    @Override
    @Transactional
    public void recordLogout(Long userId) {
        if (userId != null) {
            userRepository.findById(userId).ifPresent(user -> {
                auditLogService.logAction(user, AuditAction.LOGOUT, "USER", user.getId(), "127.0.0.1", "User logged out");
            });
        }
    }
}
