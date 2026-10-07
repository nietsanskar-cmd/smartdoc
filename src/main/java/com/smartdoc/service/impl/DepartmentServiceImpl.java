package com.smartdoc.service.impl;

import com.smartdoc.entity.Department;
import com.smartdoc.exception.ResourceNotFoundException;
import com.smartdoc.repository.DepartmentRepository;
import com.smartdoc.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DepartmentServiceImpl implements DepartmentService {

    private final DepartmentRepository departmentRepository;

    @Override
    public List<Department> findAllActive() {
        return departmentRepository.findByIsActiveTrue();
    }

    @Override
    public List<Department> findAll() {
        return departmentRepository.findAll();
    }

    @Override
    public Department findById(Long id) {
        return departmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Department not found with id: " + id));
    }

    @Override
    @Transactional
    public Department create(Department department) {
        if (departmentRepository.existsByDeptCode(department.getDeptCode())) {
            throw new IllegalArgumentException("Department code already exists: " + department.getDeptCode());
        }
        return departmentRepository.save(department);
    }

    @Override
    @Transactional
    public Department update(Long id, Department department) {
        Department existing = findById(id);
        existing.setDeptName(department.getDeptName());
        existing.setDescription(department.getDescription());
        return departmentRepository.save(existing);
    }

    @Override
    @Transactional
    public void toggleStatus(Long id) {
        Department dept = findById(id);
        dept.setIsActive(!Boolean.TRUE.equals(dept.getIsActive()));
        departmentRepository.save(dept);
    }
}
