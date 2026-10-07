package com.smartdoc.repository;

import com.smartdoc.entity.Student;
import com.smartdoc.entity.enums.CompletenessTier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByUserId(Long userId);
    Optional<Student> findByEnrollmentNo(String enrollmentNo);
    Optional<Student> findByRollNo(String rollNo);
    boolean existsByRollNo(String rollNo);
    boolean existsByEnrollmentNo(String enrollmentNo);
    List<Student> findByDepartmentId(Long departmentId);
    List<Student> findByCourseId(Long courseId);
    List<Student> findByAssignedFacultyId(Long facultyId);
    List<Student> findByCompletenessTier(CompletenessTier tier);
    long countByCompletenessTier(CompletenessTier tier);
    long countByDepartmentId(Long departmentId);

    @Query("SELECT s FROM Student s WHERE " +
           "(:query IS NULL OR LOWER(s.firstName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(s.lastName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(s.enrollmentNo) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(s.rollNo) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
           "(:deptId IS NULL OR s.department.id = :deptId) AND " +
           "(:courseId IS NULL OR s.course.id = :courseId)")
    List<Student> searchStudents(@Param("query") String query, 
                                 @Param("deptId") Long deptId, 
                                 @Param("courseId") Long courseId);
}
