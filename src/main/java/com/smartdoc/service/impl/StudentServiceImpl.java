package com.smartdoc.service.impl;

import com.smartdoc.dto.response.StudentProfileDto;
import com.smartdoc.entity.Faculty;
import com.smartdoc.entity.Student;
import com.smartdoc.exception.StudentNotFoundException;
import com.smartdoc.repository.FacultyRepository;
import com.smartdoc.repository.StudentRepository;
import com.smartdoc.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService {

    private final StudentRepository studentRepository;
    private final FacultyRepository facultyRepository;

    @Override
    public Student findById(Long id) {
        return studentRepository.findById(id)
                .orElseThrow(() -> new StudentNotFoundException("Student not found with id: " + id));
    }

    @Override
    public Student findByUserId(Long userId) {
        return studentRepository.findByUserId(userId)
                .orElseThrow(() -> new StudentNotFoundException("Student profile not found for user id: " + userId));
    }

    @Override
    public Student findByEnrollmentNo(String enrollmentNo) {
        return studentRepository.findByEnrollmentNo(enrollmentNo)
                .orElseThrow(() -> new StudentNotFoundException("Student not found with enrollment no: " + enrollmentNo));
    }

    @Override
    public List<Student> findAllStudents() {
        return studentRepository.findAll();
    }

    @Override
    public List<Student> findByDepartment(Long departmentId) {
        return studentRepository.findByDepartmentId(departmentId);
    }

    @Override
    public List<Student> findByAssignedFaculty(Long facultyId) {
        return studentRepository.findByAssignedFacultyId(facultyId);
    }

    @Override
    public List<Student> searchStudents(String query, Long deptId, Long courseId) {
        return studentRepository.searchStudents(query, deptId, courseId);
    }

    @Override
    public StudentProfileDto getProfileDto(Long studentId) {
        Student s = findById(studentId);
        return StudentProfileDto.builder()
                .id(s.getId())
                .userId(s.getUser().getId())
                .username(s.getUser().getUsername())
                .email(s.getUser().getEmail())
                .enrollmentNo(s.getEnrollmentNo())
                .rollNo(s.getRollNo())
                .firstName(s.getFirstName())
                .lastName(s.getLastName())
                .fullName(s.getFullName())
                .dob(s.getDob())
                .gender(s.getGender())
                .phone(s.getPhone())
                .departmentName(s.getDepartment() != null ? s.getDepartment().getDeptName() : "General Engineering")
                .deptCode(s.getDepartment() != null ? s.getDepartment().getDeptCode() : "GEN")
                .courseName(s.getCourse() != null ? s.getCourse().getCourseName() : "B.Tech Computer Science")
                .courseCode(s.getCourse() != null ? s.getCourse().getCourseCode() : "CSE")
                .academicYear(s.getAcademicYear() != null ? s.getAcademicYear().getYearName() : "2023-2027")
                .semesterNumber(s.getCurrentSemester() != null ? s.getCurrentSemester().getSemesterNumber() : 1)
                .facultyAdvisorName(s.getAssignedFaculty() != null ? s.getAssignedFaculty().getFullName() : "Not Assigned")
                .completenessScore(s.getCompletenessScore() != null ? s.getCompletenessScore() : java.math.BigDecimal.ZERO)
                .completenessTier(s.getCompletenessTier() != null ? s.getCompletenessTier() : com.smartdoc.entity.enums.CompletenessTier.CRITICAL)
                .profileImagePath(s.getProfileImagePath())
                .build();
    }

    @Override
    @Transactional
    public Student updateProfile(Long studentId, String phone, String profileImagePath) {
        Student s = findById(studentId);
        if (phone != null) s.setPhone(phone);
        if (profileImagePath != null) s.setProfileImagePath(profileImagePath);
        return studentRepository.save(s);
    }

    @Override
    @Transactional
    public void assignFacultyAdvisor(Long studentId, Long facultyId) {
        Student s = findById(studentId);
        Faculty f = facultyRepository.findById(facultyId)
                .orElseThrow(() -> new IllegalArgumentException("Faculty not found"));
        s.setAssignedFaculty(f);
        studentRepository.save(s);
    }
}
