package com.smartdoc.service;

import com.smartdoc.entity.Course;
import java.util.List;

public interface CourseService {
    List<Course> findAllActive();
    List<Course> findAll();
    List<Course> findByDepartment(Long departmentId);
    Course findById(Long id);
    Course create(Course course);
    Course update(Long id, Course course);
    void toggleStatus(Long id);
}
