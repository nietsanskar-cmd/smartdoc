package com.smartdoc.service;

import com.smartdoc.entity.Faculty;
import java.util.List;

public interface FacultyService {
    Faculty findById(Long id);
    Faculty findByUserId(Long userId);
    List<Faculty> findAll();
    List<Faculty> findByDepartment(Long departmentId);
    Faculty updateProfile(Long facultyId, String phone, String designation, String qualification);
}
