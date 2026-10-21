package com.smartdoc.config;

import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.CompletenessTier;
import com.smartdoc.entity.enums.RoleType;
import com.smartdoc.repository.*;
import com.smartdoc.security.PasswordEncoderUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;

@Component
@Slf4j
public class DataSeeder {

    private final RoleRepository roleRepository;
    private final DepartmentRepository departmentRepository;
    private final CourseRepository courseRepository;
    private final AcademicYearRepository academicYearRepository;
    private final SemesterRepository semesterRepository;
    private final DocumentCategoryRepository categoryRepository;
    private final DocumentTypeRepository documentTypeRepository;
    private final RequiredDocumentRepository requiredDocRepository;
    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final FacultyRepository facultyRepository;
    private final PasswordEncoderUtil passwordEncoder;

    @Autowired
    public DataSeeder(RoleRepository roleRepository,
                      DepartmentRepository departmentRepository,
                      CourseRepository courseRepository,
                      AcademicYearRepository academicYearRepository,
                      SemesterRepository semesterRepository,
                      DocumentCategoryRepository categoryRepository,
                      DocumentTypeRepository documentTypeRepository,
                      RequiredDocumentRepository requiredDocRepository,
                      UserRepository userRepository,
                      StudentRepository studentRepository,
                      FacultyRepository facultyRepository,
                      PasswordEncoderUtil passwordEncoder) {
        this.roleRepository = roleRepository;
        this.departmentRepository = departmentRepository;
        this.courseRepository = courseRepository;
        this.academicYearRepository = academicYearRepository;
        this.semesterRepository = semesterRepository;
        this.categoryRepository = categoryRepository;
        this.documentTypeRepository = documentTypeRepository;
        this.requiredDocRepository = requiredDocRepository;
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.facultyRepository = facultyRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void onApplicationReady() {
        Thread seederThread = new Thread(() -> {
            try {
                Thread.sleep(3000);
                seedAll();
            } catch (Throwable t) {
                log.warn("[SDMS-SEEDER] Background seeding notice: {}", t.getMessage());
            }
        }, "AsyncDataSeeder");
        seederThread.setDaemon(true);
        seederThread.start();
    }

    public synchronized String seedAll() {
        StringBuilder report = new StringBuilder();
        log.info("[SDMS-SEEDER] Starting database verification and seeding...");
        try { seedRoles(); report.append("Roles: OK. "); } catch (Throwable t) { report.append("Roles: ").append(t.getMessage()).append(". "); }
        try { seedDepartments(); report.append("Depts: OK. "); } catch (Throwable t) { report.append("Depts: ").append(t.getMessage()).append(". "); }
        try { seedCourses(); report.append("Courses: OK. "); } catch (Throwable t) { report.append("Courses: ").append(t.getMessage()).append(". "); }
        try { seedAcademicYears(); report.append("Years: OK. "); } catch (Throwable t) { report.append("Years: ").append(t.getMessage()).append(". "); }
        try { seedSemesters(); report.append("Semesters: OK. "); } catch (Throwable t) { report.append("Semesters: ").append(t.getMessage()).append(". "); }
        try { seedCategoriesAndDocTypes(); report.append("DocTypes: OK. "); } catch (Throwable t) { report.append("DocTypes: ").append(t.getMessage()).append(". "); }
        try { seedUsersAndProfiles(); report.append("Users & Students: OK. "); } catch (Throwable t) { report.append("Users: ").append(t.getMessage()).append(". "); }
        log.info("[SDMS-SEEDER] Seeding result: {}", report.toString());
        return report.toString();
    }

    private void seedRoles() {
        if (roleRepository.count() == 0) {
            roleRepository.save(Role.builder().roleName(RoleType.ROLE_ADMIN).description("Institutional Administrator").build());
            roleRepository.save(Role.builder().roleName(RoleType.ROLE_FACULTY).description("Academic Faculty Reviewer").build());
            roleRepository.save(Role.builder().roleName(RoleType.ROLE_STUDENT).description("Enrolled Student").build());
            log.info("[SDMS-SEEDER] Seeded default roles.");
        }
    }

    private void seedDepartments() {
        if (departmentRepository.count() == 0) {
            departmentRepository.save(Department.builder().deptCode("CSE").deptName("Computer Science and Engineering").description("Department of Computing, AI and Software Systems").isActive(true).build());
            departmentRepository.save(Department.builder().deptCode("ECE").deptName("Electronics and Communication Engineering").description("Department of VLSI, Embedded Systems and IoT").isActive(true).build());
            departmentRepository.save(Department.builder().deptCode("ME").deptName("Mechanical Engineering").description("Department of Robotics and Design").isActive(true).build());
            departmentRepository.save(Department.builder().deptCode("IT").deptName("Information Technology").description("Department of Web and Enterprise Computing").isActive(true).build());
            log.info("[SDMS-SEEDER] Seeded default departments.");
        }
    }

    private void seedCourses() {
        if (courseRepository.count() == 0) {
            Department cse = departmentRepository.findByDeptCode("CSE").orElseGet(() -> departmentRepository.findAll().stream().findFirst().orElse(null));
            Department ece = departmentRepository.findByDeptCode("ECE").orElse(cse);
            Department it = departmentRepository.findByDeptCode("IT").orElse(cse);

            if (cse != null) {
                courseRepository.save(Course.builder().courseCode("BTECH_CSE").courseName("B.Tech in Computer Science and Engineering").department(cse).totalSemesters(8).degreeLevel("Undergraduate").isActive(true).build());
                courseRepository.save(Course.builder().courseCode("MTECH_CSE").courseName("M.Tech in Advanced Computer Science").department(cse).totalSemesters(4).degreeLevel("Postgraduate").isActive(true).build());
            }
            if (ece != null) {
                courseRepository.save(Course.builder().courseCode("BTECH_ECE").courseName("B.Tech in Electronics and Communication").department(ece).totalSemesters(8).degreeLevel("Undergraduate").isActive(true).build());
            }
            if (it != null) {
                courseRepository.save(Course.builder().courseCode("MCA").courseName("Master of Computer Applications").department(it).totalSemesters(4).degreeLevel("Postgraduate").isActive(true).build());
            }
            log.info("[SDMS-SEEDER] Seeded default courses.");
        }
    }

    private void seedAcademicYears() {
        if (academicYearRepository.count() == 0) {
            academicYearRepository.save(AcademicYear.builder()
                    .yearName("2024-2025")
                    .startDate(LocalDate.of(2024, 7, 1))
                    .endDate(LocalDate.of(2025, 6, 30))
                    .isCurrent(false)
                    .build());
            academicYearRepository.save(AcademicYear.builder()
                    .yearName("2025-2026")
                    .startDate(LocalDate.of(2025, 7, 1))
                    .endDate(LocalDate.of(2026, 6, 30))
                    .isCurrent(true)
                    .build());
            log.info("[SDMS-SEEDER] Seeded academic years.");
        }
    }

    private void seedSemesters() {
        if (semesterRepository.count() == 0) {
            for (int i = 1; i <= 8; i++) {
                semesterRepository.save(Semester.builder().semesterNumber(i).semesterName("Semester " + i).build());
            }
            log.info("[SDMS-SEEDER] Seeded semesters 1 through 8.");
        }
    }

    private void seedCategoriesAndDocTypes() {
        if (categoryRepository.count() == 0) {
            DocumentCategory identity = categoryRepository.save(DocumentCategory.builder().categoryName("IDENTITY").description("Government and Institutional Identity").iconClass("bi-person-badge").build());
            DocumentCategory academic = categoryRepository.save(DocumentCategory.builder().categoryName("ACADEMIC").description("Secondary and University Marksheets").iconClass("bi-mortarboard").build());
            DocumentCategory college = categoryRepository.save(DocumentCategory.builder().categoryName("COLLEGE").description("Campus IDs and Admission Proofs").iconClass("bi-building").build());
            categoryRepository.save(DocumentCategory.builder().categoryName("CERTIFICATES").description("Certifications and Projects").iconClass("bi-award").build());

            DocumentType aadhaar = documentTypeRepository.save(DocumentType.builder().category(identity).typeCode("AADHAAR_CARD").typeName("Aadhaar Card").description("Government Issued National UID").isExpiryApplicable(false).isActive(true).build());
            DocumentType mark10 = documentTypeRepository.save(DocumentType.builder().category(academic).typeCode("MARKSHEET_10TH").typeName("10th Standard Marksheet").description("Class 10 Matriculation Certificate").isExpiryApplicable(false).isActive(true).build());
            DocumentType mark12 = documentTypeRepository.save(DocumentType.builder().category(academic).typeCode("MARKSHEET_12TH").typeName("12th Standard Marksheet").description("Class 12 Higher Secondary Certificate").isExpiryApplicable(false).isActive(true).build());
            DocumentType colId = documentTypeRepository.save(DocumentType.builder().category(college).typeCode("COLLEGE_ID").typeName("Student College ID Card").description("Institutional Smart ID Card").isExpiryApplicable(true).defaultValidityMonths(12).isActive(true).build());
            DocumentType admLetter = documentTypeRepository.save(DocumentType.builder().category(college).typeCode("ADMISSION_LETTER").typeName("Admission Offer Letter").description("Official NIET Admission Confirmation").isExpiryApplicable(false).isActive(true).build());

            // Required documents
            requiredDocRepository.save(RequiredDocument.builder().documentType(aadhaar).isMandatory(true).weightage(20).build());
            requiredDocRepository.save(RequiredDocument.builder().documentType(mark10).isMandatory(true).weightage(20).build());
            requiredDocRepository.save(RequiredDocument.builder().documentType(mark12).isMandatory(true).weightage(20).build());
            requiredDocRepository.save(RequiredDocument.builder().documentType(colId).isMandatory(true).weightage(20).build());
            requiredDocRepository.save(RequiredDocument.builder().documentType(admLetter).isMandatory(true).weightage(20).build());
            log.info("[SDMS-SEEDER] Seeded document categories and types.");
        }
    }

    private void seedUsersAndProfiles() {
        Role adminRole = roleRepository.findByRoleName(RoleType.ROLE_ADMIN).orElse(null);
        Role facultyRole = roleRepository.findByRoleName(RoleType.ROLE_FACULTY).orElse(null);
        Role studentRole = roleRepository.findByRoleName(RoleType.ROLE_STUDENT).orElse(null);

        Department dept = departmentRepository.findByDeptCode("CSE").orElseGet(() ->
                departmentRepository.findAll().stream().findFirst().orElseGet(() ->
                        departmentRepository.save(Department.builder().deptCode("CSE").deptName("Computer Science and Engineering").isActive(true).build())
                )
        );

        Course course = courseRepository.findByCourseCode("BTECH_CSE").orElseGet(() ->
                courseRepository.findAll().stream().findFirst().orElseGet(() ->
                        courseRepository.save(Course.builder().courseCode("BTECH_CSE").courseName("B.Tech in Computer Science and Engineering").department(dept).totalSemesters(8).degreeLevel("Undergraduate").isActive(true).build())
                )
        );

        AcademicYear year = academicYearRepository.findByIsCurrentTrue().orElseGet(() ->
                academicYearRepository.findAll().stream().findFirst().orElseGet(() ->
                        academicYearRepository.save(AcademicYear.builder()
                                .yearName("2025-2026")
                                .startDate(LocalDate.of(2025, 7, 1))
                                .endDate(LocalDate.of(2026, 6, 30))
                                .isCurrent(true)
                                .build())
                )
        );

        Semester sem = semesterRepository.findBySemesterNumber(4).orElseGet(() ->
                semesterRepository.findAll().stream().findFirst().orElseGet(() ->
                        semesterRepository.save(Semester.builder().semesterNumber(4).semesterName("Semester 4").build())
                )
        );

        // 1. Admin Account: admin / admin@niet.co.in (Password: Admin@2026)
        if (adminRole != null && userRepository.findByUsername("admin").isEmpty()) {
            userRepository.save(User.builder()
                    .username("admin")
                    .email("admin@niet.co.in")
                    .passwordHash(passwordEncoder.encode("Admin@2026"))
                    .role(adminRole)
                    .isActive(true)
                    .emailVerified(true)
                    .build());
            log.info("[SDMS-SEEDER] Seeded Admin account: admin / Admin@2026");
        }

        // 2. Faculty Account: dr.sharma / sharma@niet.co.in (Password: Password@123)
        Faculty faculty = facultyRepository.findByEmployeeCode("FAC_CSE_001").orElse(null);
        if (facultyRole != null && userRepository.findByUsername("dr.sharma").isEmpty()) {
            User facUser = userRepository.save(User.builder()
                    .username("dr.sharma")
                    .email("sharma@niet.co.in")
                    .passwordHash(passwordEncoder.encode("Password@123"))
                    .role(facultyRole)
                    .isActive(true)
                    .emailVerified(true)
                    .build());

            if (dept != null) {
                faculty = facultyRepository.save(Faculty.builder()
                        .user(facUser)
                        .employeeCode("FAC_CSE_001")
                        .firstName("Dr. Ramesh")
                        .lastName("Sharma")
                        .phone("+91 98765 43210")
                        .department(dept)
                        .designation("Professor & HOD")
                        .qualification("Ph.D. in Computer Science")
                        .build());
                log.info("[SDMS-SEEDER] Seeded Faculty account: dr.sharma / Password@123");
            }
        }

        // 3. Sanskar Khari Student Account: 0241mcsd011 / 0241mcsd011@niet.co.in / Roll: 2401330100550 (Password: Sanskar@2006)
        if (studentRole != null) {
            User studentUser = userRepository.findByUsername("0241mcsd011")
                    .or(() -> userRepository.findByEmail("0241mcsd011@niet.co.in"))
                    .orElseGet(() -> userRepository.save(User.builder()
                            .username("0241mcsd011")
                            .email("0241mcsd011@niet.co.in")
                            .passwordHash(passwordEncoder.encode("Sanskar@2006"))
                            .role(studentRole)
                            .isActive(true)
                            .emailVerified(true)
                            .build()));

            // Always ensure password is updated to Sanskar@2006
            studentUser.setPasswordHash(passwordEncoder.encode("Sanskar@2006"));
            studentUser.setIsActive(true);
            studentUser.setEmailVerified(true);
            userRepository.save(studentUser);

            if (studentRepository.findByUserId(studentUser.getId()).isEmpty()) {
                studentRepository.save(Student.builder()
                        .user(studentUser)
                        .enrollmentNo("0241MCSD011")
                        .rollNo("2401330100550")
                        .firstName("Sanskar")
                        .lastName("Khari")
                        .dob(LocalDate.of(2004, 5, 15))
                        .gender("Male")
                        .phone("+91 91234 56789")
                        .department(dept)
                        .course(course)
                        .academicYear(year)
                        .currentSemester(sem)
                        .assignedFaculty(faculty)
                        .completenessScore(new BigDecimal("80.00"))
                        .completenessTier(CompletenessTier.GOOD)
                        .build());
                log.info("[SDMS-SEEDER] Seeded Student profile: 0241mcsd011 / Roll: 2401330100550");
            }
        }

        // 4. Sample Student: student.aarav / aarav.sharma@niet.co.in / Roll: 23CSE101 (Password: password123)
        if (studentRole != null) {
            User aaravUser = userRepository.findByUsername("student.aarav")
                    .or(() -> userRepository.findByEmail("aarav.sharma@niet.co.in"))
                    .orElseGet(() -> userRepository.save(User.builder()
                            .username("student.aarav")
                            .email("aarav.sharma@niet.co.in")
                            .passwordHash(passwordEncoder.encode("password123"))
                            .role(studentRole)
                            .isActive(true)
                            .emailVerified(true)
                            .build()));

            if (studentRepository.findByUserId(aaravUser.getId()).isEmpty()) {
                studentRepository.save(Student.builder()
                        .user(aaravUser)
                        .enrollmentNo("EN2023CSE0101")
                        .rollNo("23CSE101")
                        .firstName("Aarav")
                        .lastName("Sharma")
                        .dob(LocalDate.of(2004, 8, 20))
                        .gender("Male")
                        .phone("+91 91234 56780")
                        .department(dept)
                        .course(course)
                        .academicYear(year)
                        .currentSemester(sem)
                        .assignedFaculty(faculty)
                        .completenessScore(new BigDecimal("80.00"))
                        .completenessTier(CompletenessTier.GOOD)
                        .build());
                log.info("[SDMS-SEEDER] Seeded Student profile: student.aarav / Roll: 23CSE101");
            }
        }
    }
}