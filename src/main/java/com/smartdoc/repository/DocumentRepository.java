package com.smartdoc.repository;

import com.smartdoc.entity.Document;
import com.smartdoc.entity.enums.DocumentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface DocumentRepository extends JpaRepository<Document, Long> {
    Optional<Document> findByDocumentCode(String documentCode);
    Optional<Document> findByVerificationToken(String verificationToken);
    List<Document> findByStudentId(Long studentId);
    List<Document> findByStudentIdAndStatus(Long studentId, DocumentStatus status);
    List<Document> findByStudentIdAndDocumentTypeCategoryId(Long studentId, Long categoryId);
    List<Document> findByStatus(DocumentStatus status);
    long countByStatus(DocumentStatus status);
    boolean existsBySha256Hash(String sha256Hash);
    Optional<Document> findByStudentIdAndDocumentTypeId(Long studentId, Long documentTypeId);

    @Query("SELECT d FROM Document d WHERE d.student.assignedFaculty.id = :facultyId AND d.status = 'UNDER_REVIEW'")
    List<Document> findPendingForFaculty(@Param("facultyId") Long facultyId);

    @Query("SELECT d FROM Document d WHERE d.status = 'ACTIVE' AND d.expiryDate IS NOT NULL AND d.expiryDate <= :targetDate")
    List<Document> findExpiringDocuments(@Param("targetDate") LocalDate targetDate);

    @Query("SELECT d FROM Document d WHERE (d.status = 'ACTIVE' OR d.status = 'EXPIRING') AND d.expiryDate IS NOT NULL AND d.expiryDate < :today")
    List<Document> findExpiredDocuments(@Param("today") LocalDate today);

    @Query("SELECT SUM(d.fileSizeBytes) FROM Document d")
    Long getTotalStorageUsedBytes();

    @Query("SELECT d FROM Document d WHERE " +
           "(:status IS NULL OR d.status = :status) AND " +
           "(:typeId IS NULL OR d.documentType.id = :typeId) AND " +
           "(:deptId IS NULL OR d.student.department.id = :deptId) AND " +
           "(:query IS NULL OR LOWER(d.title) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(d.student.firstName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(d.student.enrollmentNo) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<Document> searchDocuments(@Param("query") String query,
                                  @Param("status") DocumentStatus status,
                                  @Param("typeId") Long typeId,
                                  @Param("deptId") Long deptId);
}
