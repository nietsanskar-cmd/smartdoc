package com.smartdoc.service.impl;

import com.smartdoc.entity.Faculty;
import com.smartdoc.exception.ResourceNotFoundException;
import com.smartdoc.repository.FacultyRepository;
import com.smartdoc.service.FacultyService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FacultyServiceImpl implements FacultyService {

    private final FacultyRepository facultyRepository;

    @Override
    public Faculty findById(Long id) {
        return facultyRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Faculty member not found with id: " + id));
    }

    @Override
    public Faculty findByUserId(Long userId) {
        return facultyRepository.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Faculty profile not found for user id: " + userId));
    }

    @Override
    public List<Faculty> findAll() {
        return facultyRepository.findAll();
    }

    @Override
    public List<Faculty> findByDepartment(Long departmentId) {
        return facultyRepository.findByDepartmentId(departmentId);
    }

    @Override
    @Transactional
    public Faculty updateProfile(Long facultyId, String phone, String designation, String qualification) {
        Faculty f = findById(facultyId);
        if (phone != null) f.setPhone(phone);
        if (designation != null) f.setDesignation(designation);
        if (qualification != null) f.setQualification(qualification);
        return facultyRepository.save(f);
    }
}
