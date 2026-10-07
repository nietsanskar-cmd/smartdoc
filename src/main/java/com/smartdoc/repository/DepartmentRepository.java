package com.smartdoc.repository;

import com.smartdoc.entity.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, Long> {
    Optional<Department> findByDeptCode(String deptCode);
    List<Department> findByIsActiveTrue();
    boolean existsByDeptCode(String deptCode);
}
