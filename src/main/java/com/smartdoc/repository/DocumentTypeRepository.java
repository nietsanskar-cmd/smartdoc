package com.smartdoc.repository;

import com.smartdoc.entity.DocumentType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface DocumentTypeRepository extends JpaRepository<DocumentType, Long> {
    Optional<DocumentType> findByTypeCode(String typeCode);
    List<DocumentType> findByCategoryId(Long categoryId);
    List<DocumentType> findByIsActiveTrue();
    boolean existsByTypeCode(String typeCode);
}
