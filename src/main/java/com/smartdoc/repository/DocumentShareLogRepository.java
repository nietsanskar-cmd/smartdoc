package com.smartdoc.repository;

import com.smartdoc.entity.DocumentShareLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DocumentShareLogRepository extends JpaRepository<DocumentShareLog, Long> {
    List<DocumentShareLog> findByDocumentShareIdOrderByAccessedAtDesc(Long shareId);
}
