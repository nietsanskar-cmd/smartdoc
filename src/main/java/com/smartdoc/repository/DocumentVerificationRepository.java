package com.smartdoc.repository;

import com.smartdoc.entity.DocumentVerification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DocumentVerificationRepository extends JpaRepository<DocumentVerification, Long> {
    List<DocumentVerification> findByDocumentIdOrderByDecisionDateDesc(Long documentId);
    List<DocumentVerification> findByFacultyId(Long facultyId);
}
