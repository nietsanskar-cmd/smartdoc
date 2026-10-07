package com.smartdoc.service.impl;

import com.smartdoc.dto.request.DocumentShareCreateDto;
import com.smartdoc.dto.response.ShareDetailsDto;
import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.AuditAction;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.exception.*;
import com.smartdoc.repository.*;
import com.smartdoc.security.PasswordEncoderUtil;
import com.smartdoc.service.*;
import com.smartdoc.util.TokenGenerator;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DocumentShareServiceImpl implements DocumentShareService {

    private final DocumentShareRepository shareRepository;
    private final DocumentShareLogRepository shareLogRepository;
    private final DocumentRepository documentRepository;
    private final StudentRepository studentRepository;
    private final StorageService storageService;
    private final PasswordEncoderUtil passwordEncoder;
    private final AuditLogService auditLogService;

    @Value("${smartdoc.app.base-url:http://localhost:8080}")
    private String appBaseUrl;

    @Override
    @Transactional
    public DocumentShare createShare(Long studentId, DocumentShareCreateDto dto) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new StudentNotFoundException("Student not found"));

        Document doc = documentRepository.findById(dto.getDocumentId())
                .orElseThrow(() -> new DocumentNotFoundException("Document not found"));

        if (!doc.getStudent().getId().equals(studentId)) {
            throw new UnauthorizedAccessException("You are only authorized to share your own documents");
        }

        if (!DocumentStatus.VERIFIED.equals(doc.getStatus()) && !DocumentStatus.ACTIVE.equals(doc.getStatus())) {
            throw new IllegalArgumentException("Only verified and active documents can be shared");
        }

        int hours = (dto.getDurationHours() != null && dto.getDurationHours() > 0) ? dto.getDurationHours() : 48;
        int maxAccess = (dto.getMaxAccessCount() != null && dto.getMaxAccessCount() > 0) ? dto.getMaxAccessCount() : 10;
        String passcodeHash = null;
        if (dto.getAccessPasscode() != null && !dto.getAccessPasscode().trim().isEmpty()) {
            passcodeHash = passwordEncoder.encode(dto.getAccessPasscode().trim());
        }

        String shareToken = TokenGenerator.generateShareToken();

        DocumentShare share = DocumentShare.builder()
                .document(doc)
                .student(student)
                .shareToken(shareToken)
                .recipientEmail(dto.getRecipientEmail())
                .accessPasscodeHash(passcodeHash)
                .expiresAt(LocalDateTime.now().plusHours(hours))
                .maxAccessCount(maxAccess)
                .currentAccessCount(0)
                .isRevoked(false)
                .build();
        share = shareRepository.save(share);

        auditLogService.logAction(student.getUser(), AuditAction.SHARE_DOC, "DOCUMENT_SHARE", share.getId(), "127.0.0.1",
                "Created secure share link for document " + doc.getDocumentCode() + " expiring in " + hours + " hours");

        return share;
    }

    @Override
    public DocumentShare findByToken(String shareToken) {
        return shareRepository.findByShareToken(shareToken)
                .orElseThrow(() -> new ResourceNotFoundException("Share link not found or invalid"));
    }

    @Override
    public boolean validatePasscode(DocumentShare share, String rawPasscode) {
        if (share.getAccessPasscodeHash() == null || share.getAccessPasscodeHash().isEmpty()) {
            return true;
        }
        return passwordEncoder.matches(rawPasscode, share.getAccessPasscodeHash());
    }

    @Override
    @Transactional
    public Resource accessSharedDocument(String shareToken, String passcode, String ipAddress, String userAgent) {
        DocumentShare share = findByToken(shareToken);

        if (share.isExpired()) {
            recordShareLog(share, ipAddress, userAgent, "EXPIRED_OR_REVOKED");
            throw new ShareLinkExpiredException("This secure document link has expired or reached maximum access limits.");
        }

        if (share.getAccessPasscodeHash() != null && !share.getAccessPasscodeHash().isEmpty()) {
            if (!validatePasscode(share, passcode)) {
                recordShareLog(share, ipAddress, userAgent, "INVALID_PASSCODE");
                throw new UnauthorizedAccessException("Incorrect document access passcode provided.");
            }
        }

        share.setCurrentAccessCount(share.getCurrentAccessCount() + 1);
        shareRepository.save(share);

        recordShareLog(share, ipAddress, userAgent, "SUCCESS");

        return storageService.loadAsResource(share.getDocument().getStoredFilePath());
    }

    private void recordShareLog(DocumentShare share, String ipAddress, String userAgent, String status) {
        DocumentShareLog log = DocumentShareLog.builder()
                .documentShare(share)
                .accessedAt(LocalDateTime.now())
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .accessStatus(status)
                .build();
        shareLogRepository.save(log);
    }

    @Override
    @Transactional
    public void revokeShare(Long shareId, Long studentId) {
        DocumentShare share = shareRepository.findById(shareId)
                .orElseThrow(() -> new ResourceNotFoundException("Share record not found"));

        if (!share.getStudent().getId().equals(studentId)) {
            throw new UnauthorizedAccessException("You are not authorized to revoke this share link");
        }

        share.setIsRevoked(true);
        shareRepository.save(share);

        auditLogService.logAction(share.getStudent().getUser(), AuditAction.REVOKE_SHARE, "DOCUMENT_SHARE", share.getId(), "127.0.0.1",
                "Revoked share link for document " + share.getDocument().getDocumentCode());
    }

    @Override
    public List<ShareDetailsDto> getStudentShares(Long studentId) {
        List<DocumentShare> list = shareRepository.findByStudentIdOrderByCreatedAtDesc(studentId);
        List<ShareDetailsDto> dtos = new ArrayList<>();
        for (DocumentShare s : list) {
            dtos.add(ShareDetailsDto.builder()
                    .id(s.getId())
                    .documentId(s.getDocument().getId())
                    .documentTitle(s.getDocument().getTitle())
                    .documentTypeName(s.getDocument().getDocumentType().getTypeName())
                    .shareToken(s.getShareToken())
                    .shareUrl(appBaseUrl + "/shared/" + s.getShareToken())
                    .recipientEmail(s.getRecipientEmail())
                    .hasPasscode(s.getAccessPasscodeHash() != null && !s.getAccessPasscodeHash().isEmpty())
                    .expiresAt(s.getExpiresAt())
                    .maxAccessCount(s.getMaxAccessCount())
                    .currentAccessCount(s.getCurrentAccessCount())
                    .isRevoked(s.getIsRevoked())
                    .isExpired(s.isExpired())
                    .createdAt(s.getCreatedAt())
                    .build());
        }
        return dtos;
    }
}
