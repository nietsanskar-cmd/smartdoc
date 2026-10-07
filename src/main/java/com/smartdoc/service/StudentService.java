package com.smartdoc.service;

import com.smartdoc.dto.response.StudentProfileDto;
import com.smartdoc.entity.Student;
import java.util.List;

public interface StudentService {
    Student findById(Long id);
    Student findByUserId(Long userId);
    Student findByEnrollmentNo(String enrollmentNo);
    List<Student> findAllStudents();
    List<Student> findByDepartment(Long departmentId);
    List<Student> findByAssignedFaculty(Long facultyId);
    List<Student> searchStudents(String query, Long deptId, Long courseId);
    StudentProfileDto getProfileDto(Long studentId);
    Student updateProfile(Long studentId, String phone, String profileImagePath);
    void assignFacultyAdvisor(Long studentId, Long facultyId);
}
