package com.smartdoc.service.impl;

import com.smartdoc.entity.Course;
import com.smartdoc.exception.ResourceNotFoundException;
import com.smartdoc.repository.CourseRepository;
import com.smartdoc.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;

    @Override
    public List<Course> findAllActive() {
        return courseRepository.findByIsActiveTrue();
    }

    @Override
    public List<Course> findAll() {
        return courseRepository.findAll();
    }

    @Override
    public List<Course> findByDepartment(Long departmentId) {
        return courseRepository.findByDepartmentId(departmentId);
    }

    @Override
    public Course findById(Long id) {
        return courseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Course not found with id: " + id));
    }

    @Override
    @Transactional
    public Course create(Course course) {
        if (courseRepository.existsByCourseCode(course.getCourseCode())) {
            throw new IllegalArgumentException("Course code already exists: " + course.getCourseCode());
        }
        return courseRepository.save(course);
    }

    @Override
    @Transactional
    public Course update(Long id, Course course) {
        Course existing = findById(id);
        existing.setCourseName(course.getCourseName());
        existing.setTotalSemesters(course.getTotalSemesters());
        existing.setDegreeLevel(course.getDegreeLevel());
        existing.setDepartment(course.getDepartment());
        return courseRepository.save(existing);
    }

    @Override
    @Transactional
    public void toggleStatus(Long id) {
        Course course = findById(id);
        course.setIsActive(!Boolean.TRUE.equals(course.getIsActive()));
        courseRepository.save(course);
    }
}
