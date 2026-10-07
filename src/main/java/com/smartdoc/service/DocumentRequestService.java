package com.smartdoc.service;

import com.smartdoc.dto.request.DocumentRequestCreateDto;
import com.smartdoc.entity.DocumentRequest;
import com.smartdoc.entity.enums.RequestStatus;
import java.util.List;

public interface DocumentRequestService {
    DocumentRequest submitRequest(Long studentId, DocumentRequestCreateDto dto);
    DocumentRequest processRequest(Long requestId, RequestStatus status, String adminRemarks, Long adminUserId, String ipAddress);
    DocumentRequest findById(Long id);
    List<DocumentRequest> findByStudent(Long studentId);
    List<DocumentRequest> findAllRequests();
    List<DocumentRequest> findByStatus(RequestStatus status);
}
