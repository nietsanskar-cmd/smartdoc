package com.smartdoc.repository;

import com.smartdoc.entity.DocumentShare;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface DocumentShareRepository extends JpaRepository<DocumentShare, Long> {
    Optional<DocumentShare> findByShareToken(String shareToken);
    List<DocumentShare> findByStudentIdOrderByCreatedAtDesc(Long studentId);
    List<DocumentShare> findByDocumentId(Long documentId);
    
    @Query("SELECT s FROM DocumentShare s WHERE s.isRevoked = false AND s.expiresAt < :now")
    List<DocumentShare> findExpiredActiveShares(@Param("now") LocalDateTime now);
}
