package com.smartdoc.service.impl;

import com.smartdoc.dto.request.DocumentVerificationDto;
import com.smartdoc.dto.response.VerificationQueueDto;
import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.*;
import com.smartdoc.exception.DocumentNotFoundException;
import com.smartdoc.exception.DocumentVerificationException;
import com.smartdoc.repository.*;
import com.smartdoc.service.AuditLogService;
import com.smartdoc.service.CompletenessScoreService;
import com.smartdoc.service.NotificationService;
import com.smartdoc.service.QRCodeService;
import com.smartdoc.service.VerificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VerificationServiceImpl implements VerificationService {

    private final DocumentRepository documentRepository;
    private final DocumentVerificationRepository verificationRepository;
    private final FacultyRepository facultyRepository;
    private final UserRepository userRepository;
    private final QRCodeService qrCodeService;
    private final CompletenessScoreService completenessScoreService;
    private final NotificationService notificationService;
    private final AuditLogService auditLogService;

    @Override
    @Transactional
    public Document processVerification(Long documentId, Long facultyUserId, DocumentVerificationDto dto, String ipAddress) {
        Document doc = documentRepository.findById(documentId)
                .orElseThrow(() -> new DocumentNotFoundException("Document not found with id: " + documentId));

        User user = userRepository.findById(facultyUserId)
                .orElseThrow(() -> new DocumentVerificationException("Verifier user account not found"));

        Faculty faculty = facultyRepository.findByUserId(facultyUserId).orElse(null);

        if (dto.getAction() == null) {
            throw new DocumentVerificationException("Verification action is required");
        }

        if (VerificationAction.APPROVED.equals(dto.getAction())) {
            doc.setStatus(DocumentStatus.VERIFIED);
            doc.setVerifiedAt(LocalDateTime.now());
            doc.setVerifiedByUser(user);
            doc.setRejectionReason(null);
            doc.setRejectionRemarks(null);

            String qrPath = qrCodeService.generateVerificationQRCode(doc.getVerificationToken());
            doc.setQrCodePath(qrPath);

            notificationService.createNotification(doc.getStudent().getUser(), "Document Verified",
                    "Your document '" + doc.getTitle() + "' has been verified successfully.",
                    NotificationType.VERIFICATION, "/student/vault");

            auditLogService.logAction(user, AuditAction.VERIFY_DOC, "DOCUMENT", doc.getId(), ipAddress,
                    "Approved document " + doc.getDocumentCode() + " with QR verification code");

        } else if (VerificationAction.REJECTED.equals(dto.getAction())) {
            if (dto.getRemarks() == null || dto.getRemarks().trim().isEmpty()) {
                throw new DocumentVerificationException("Mandatory remarks must be supplied when rejecting a document.");
            }
            doc.setStatus(DocumentStatus.REJECTED);
            doc.setRejectionReason(dto.getReasonCode() != null ? dto.getReasonCode() : "UNSATISFACTORY_QUALITY");
            doc.setRejectionRemarks(dto.getRemarks());

            notificationService.createNotification(doc.getStudent().getUser(), "Document Rejected",
                    "Your document '" + doc.getTitle() + "' was rejected. Reason: " + dto.getRemarks(),
                    NotificationType.REJECTION, "/student/upload");

            auditLogService.logAction(user, AuditAction.REJECT_DOC, "DOCUMENT", doc.getId(), ipAddress,
                    "Rejected document " + doc.getDocumentCode() + " (Reason: " + doc.getRejectionReason() + ")");

        } else if (VerificationAction.REUPLOAD_REQUESTED.equals(dto.getAction())) {
            doc.setStatus(DocumentStatus.UNDER_REVIEW);
            doc.setRejectionRemarks("Re-upload requested: " + dto.getRemarks());

            notificationService.createNotification(doc.getStudent().getUser(), "Re-upload Requested",
                    "Reviewer requested a re-upload for '" + doc.getTitle() + "'. Remarks: " + dto.getRemarks(),
                    NotificationType.REJECTION, "/student/upload");

            auditLogService.logAction(user, AuditAction.REUPLOAD_REQUEST, "DOCUMENT", doc.getId(), ipAddress,
                    "Requested re-upload for document " + doc.getDocumentCode());
        }

        doc = documentRepository.save(doc);

        DocumentVerification verificationRecord = DocumentVerification.builder()
                .document(doc)
                .faculty(faculty)
                .action(dto.getAction())
                .remarks(dto.getRemarks())
                .reasonCode(dto.getReasonCode())
                .decisionDate(LocalDateTime.now())
                .build();
        verificationRepository.save(verificationRecord);

        completenessScoreService.calculateScore(doc.getStudent().getId());

        return doc;
    }

    @Override
    public List<VerificationQueueDto> getQueueForFaculty(Long facultyId) {
        List<Document> list = documentRepository.findPendingForFaculty(facultyId);
        return mapToQueueDtos(list);
    }

    @Override
    public List<VerificationQueueDto> getAllPendingQueue() {
        List<Document> list = documentRepository.findByStatus(DocumentStatus.UNDER_REVIEW);
        return mapToQueueDtos(list);
    }

    private List<VerificationQueueDto> mapToQueueDtos(List<Document> documents) {
        List<VerificationQueueDto> dtos = new ArrayList<>();
        for (Document d : documents) {
            dtos.add(VerificationQueueDto.builder()
                    .documentId(d.getId())
                    .documentCode(d.getDocumentCode())
                    .title(d.getTitle())
                    .documentTypeName(d.getDocumentType().getTypeName())
                    .categoryName(d.getDocumentType().getCategory().getCategoryName())
                    .studentName(d.getStudent().getFullName())
                    .enrollmentNo(d.getStudent().getEnrollmentNo())
                    .departmentName(d.getStudent().getDepartment().getDeptName())
                    .fileName(d.getFileName())
                    .mimeType(d.getMimeType())
                    .submittedAt(d.getCreatedAt())
                    .versionNumber(d.getCurrentVersion())
                    .build());
        }
        return dtos;
    }
}
