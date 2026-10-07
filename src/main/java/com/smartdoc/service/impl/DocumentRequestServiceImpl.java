package com.smartdoc.service.impl;

import com.smartdoc.dto.request.DocumentRequestCreateDto;
import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.*;
import com.smartdoc.exception.DocumentRequestNotFoundException;
import com.smartdoc.exception.ResourceNotFoundException;
import com.smartdoc.exception.StudentNotFoundException;
import com.smartdoc.repository.*;
import com.smartdoc.service.*;
import com.smartdoc.util.TokenGenerator;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DocumentRequestServiceImpl implements DocumentRequestService {

    private final DocumentRequestRepository requestRepository;
    private final StudentRepository studentRepository;
    private final DocumentTypeRepository documentTypeRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;
    private final AuditLogService auditLogService;

    @Override
    @Transactional
    public DocumentRequest submitRequest(Long studentId, DocumentRequestCreateDto dto) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new StudentNotFoundException("Student not found"));
        DocumentType docType = documentTypeRepository.findById(dto.getDocumentTypeId())
                .orElseThrow(() -> new ResourceNotFoundException("Document type not found"));

        String requestNo = TokenGenerator.generateRequestNo();

        DocumentRequest request = DocumentRequest.builder()
                .requestNo(requestNo)
                .student(student)
                .documentType(docType)
                .purpose(dto.getPurpose())
                .status(RequestStatus.REQUESTED)
                .requestedAt(LocalDateTime.now())
                .build();
        request = requestRepository.save(request);

        notificationService.createNotification(student.getUser(), "Document Request Submitted",
                "Your request (" + requestNo + ") for " + docType.getTypeName() + " has been submitted to the admin office.",
                NotificationType.REQUEST, "/student/requests");

        auditLogService.logAction(student.getUser(), AuditAction.REQUEST_DOC, "DOCUMENT_REQUEST", request.getId(), "127.0.0.1",
                "Submitted official request " + requestNo + " for " + docType.getTypeName());

        return request;
    }

    @Override
    @Transactional
    public DocumentRequest processRequest(Long requestId, RequestStatus status, String adminRemarks, Long adminUserId, String ipAddress) {
        DocumentRequest request = findById(requestId);
        User admin = userRepository.findById(adminUserId).orElse(null);

        request.setStatus(status);
        request.setAdminRemarks(adminRemarks);
        if (RequestStatus.COMPLETED.equals(status) || RequestStatus.APPROVED.equals(status)) {
            request.setCompletedAt(LocalDateTime.now());
        }

        request = requestRepository.save(request);

        String title = "Document Request Update";
        String message = "Your document request (" + request.getRequestNo() + ") status is now: " + status + ". Remarks: " + (adminRemarks != null ? adminRemarks : "None");
        notificationService.createNotification(request.getStudent().getUser(), title, message, NotificationType.REQUEST, "/student/requests");

        auditLogService.logAction(admin, AuditAction.PROCESS_REQUEST, "DOCUMENT_REQUEST", request.getId(), ipAddress,
                "Updated request " + request.getRequestNo() + " to status " + status);

        return request;
    }

    @Override
    public DocumentRequest findById(Long id) {
        return requestRepository.findById(id)
                .orElseThrow(() -> new DocumentRequestNotFoundException("Document request not found with id: " + id));
    }

    @Override
    public List<DocumentRequest> findByStudent(Long studentId) {
        return requestRepository.findByStudentIdOrderByRequestedAtDesc(studentId);
    }

    @Override
    public List<DocumentRequest> findAllRequests() {
        return requestRepository.findAll();
    }

    @Override
    public List<DocumentRequest> findByStatus(RequestStatus status) {
        return requestRepository.findByStatusOrderByRequestedAtDesc(status);
    }
}
