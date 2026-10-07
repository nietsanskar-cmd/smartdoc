package com.smartdoc.service;

import com.smartdoc.entity.Department;
import java.util.List;

public interface DepartmentService {
    List<Department> findAllActive();
    List<Department> findAll();
    Department findById(Long id);
    Department create(Department department);
    Department update(Long id, Department department);
    void toggleStatus(Long id);
}
