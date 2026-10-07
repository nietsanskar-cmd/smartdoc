package com.smartdoc.repository;

import com.smartdoc.entity.DocumentRequest;
import com.smartdoc.entity.enums.RequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface DocumentRequestRepository extends JpaRepository<DocumentRequest, Long> {
    Optional<DocumentRequest> findByRequestNo(String requestNo);
    List<DocumentRequest> findByStudentIdOrderByRequestedAtDesc(Long studentId);
    List<DocumentRequest> findByStatusOrderByRequestedAtDesc(RequestStatus status);
    long countByStatus(RequestStatus status);
}
