package com.smartdoc.service.impl;

import com.smartdoc.dto.request.DocumentUploadDto;
import com.smartdoc.dto.response.DocumentDetailsDto;
import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.*;
import com.smartdoc.exception.*;
import com.smartdoc.repository.*;
import com.smartdoc.service.*;
import com.smartdoc.util.*;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DocumentServiceImpl implements DocumentService {

    private final DocumentRepository documentRepository;
    private final DocumentVersionRepository versionRepository;
    private final StudentRepository studentRepository;
    private final DocumentTypeRepository documentTypeRepository;
    private final UserRepository userRepository;
    private final DownloadHistoryRepository downloadHistoryRepository;
    private final StorageService storageService;
    private final CompletenessScoreService completenessScoreService;
    private final NotificationService notificationService;
    private final AuditLogService auditLogService;

    @Override
    @Transactional
    public Document uploadDocument(Long studentId, DocumentUploadDto uploadDto, Long uploaderUserId, String ipAddress) {
        if (uploadDto.getFile() == null || uploadDto.getFile().isEmpty()) {
            throw new InvalidFileTypeException("Please select a file to upload");
        }
        if (!FileUtil.isValidFileType(uploadDto.getFile())) {
            throw new InvalidFileTypeException("Invalid file format. Only PDF, JPG, and PNG documents are accepted.");
        }

        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new StudentNotFoundException("Student not found"));
        DocumentType docType = documentTypeRepository.findById(uploadDto.getDocumentTypeId())
                .orElseThrow(() -> new ResourceNotFoundException("Document type not found"));
        User uploader = userRepository.findById(uploaderUserId)
                .orElseThrow(() -> new UserNotFoundException("User not found"));

        String sha256Hash;
        try {
            sha256Hash = ChecksumUtil.calculateSHA256(uploadDto.getFile().getInputStream());
        } catch (Exception e) {
            throw new StorageException("Failed to compute document hash", e);
        }

        if (documentRepository.existsBySha256Hash(sha256Hash)) {
            throw new DuplicateDocumentException("Duplicate document detected: A file with identical SHA-256 fingerprint already exists.");
        }

        // Allow multiple distinct achievements/certificates (Category 4 or OTHER)
        boolean isMultiAllowedCategory = docType.getCategory() != null && 
                (Long.valueOf(4L).equals(docType.getCategory().getId()) || 
                 "CERTIFICATES".equalsIgnoreCase(docType.getCategory().getCategoryName()) || 
                 "OTHER".equalsIgnoreCase(docType.getCategory().getCategoryName()));

        if (!isMultiAllowedCategory) {
            Optional<Document> existingDocOpt = documentRepository.findByStudentIdAndDocumentTypeId(studentId, docType.getId());
            if (existingDocOpt.isPresent()) {
                return uploadNewVersion(existingDocOpt.get().getId(), uploadDto, uploaderUserId, ipAddress);
            }
        }

        int year = LocalDate.now().getYear();
        String subDir = year + "/" + student.getId() + "/" + docType.getId();
        String storedPath = storageService.storeFile(uploadDto.getFile(), subDir);

        String deptCode = student.getDepartment() != null ? student.getDepartment().getDeptCode() : "DOC";
        String docCode = TokenGenerator.generateDocumentCode(deptCode);
        String verificationToken = TokenGenerator.generateVerificationToken(student.getEnrollmentNo());

        Document document = Document.builder()
                .documentCode(docCode)
                .student(student)
                .documentType(docType)
                .title(uploadDto.getTitle())
                .currentVersion(1)
                .status(DocumentStatus.UNDER_REVIEW)
                .fileName(uploadDto.getFile().getOriginalFilename())
                .storedFilePath(storedPath)
                .fileSizeBytes(uploadDto.getFile().getSize())
                .mimeType(uploadDto.getFile().getContentType())
                .sha256Hash(sha256Hash)
                .verificationToken(verificationToken)
                .issueDate(uploadDto.getIssueDate())
                .expiryDate(uploadDto.getExpiryDate())
                .build();
        document = documentRepository.save(document);

        DocumentVersion version = DocumentVersion.builder()
                .document(document)
                .versionNumber(1)
                .fileName(uploadDto.getFile().getOriginalFilename())
                .storedFilePath(storedPath)
                .fileSizeBytes(uploadDto.getFile().getSize())
                .mimeType(uploadDto.getFile().getContentType())
                .sha256Hash(sha256Hash)
                .uploadedByUser(uploader)
                .changeSummary("Initial document upload")
                .build();
        versionRepository.save(version);

        completenessScoreService.calculateScore(student.getId());

        notificationService.createNotification(student.getUser(), "Document Submitted",
                "Your document '" + document.getTitle() + "' has been uploaded and queued for verification.",
                NotificationType.UPLOAD, "/student/vault");

        if (student.getAssignedFaculty() != null) {
            notificationService.createNotification(student.getAssignedFaculty().getUser(), "New Document for Review",
                    "Student " + student.getFullName() + " submitted '" + document.getTitle() + "' for verification.",
                    NotificationType.UPLOAD, "/faculty/queue");
        }

        auditLogService.logAction(uploader, AuditAction.UPLOAD_DOC, "DOCUMENT", document.getId(), ipAddress,
                "Uploaded new document: " + document.getDocumentCode() + " (" + document.getTitle() + ")");

        return document;
    }

    @Override
    @Transactional
    public Document uploadNewVersion(Long documentId, DocumentUploadDto uploadDto, Long uploaderUserId, String ipAddress) {
        Document doc = findById(documentId);
        if (!FileUtil.isValidFileType(uploadDto.getFile())) {
            throw new InvalidFileTypeException("Invalid file format. Only PDF, JPG, and PNG documents are accepted.");
        }

        User uploader = userRepository.findById(uploaderUserId)
                .orElseThrow(() -> new UserNotFoundException("User not found"));

        String sha256Hash;
        try {
            sha256Hash = ChecksumUtil.calculateSHA256(uploadDto.getFile().getInputStream());
        } catch (Exception e) {
            throw new StorageException("Failed to compute document hash", e);
        }

        if (documentRepository.existsBySha256Hash(sha256Hash)) {
            throw new DuplicateDocumentException("Duplicate document detected: Identical file already exists in vault.");
        }

        int nextVersion = doc.getCurrentVersion() + 1;
        int year = LocalDate.now().getYear();
        String subDir = year + "/" + doc.getStudent().getId() + "/" + doc.getDocumentType().getId();
        String storedPath = storageService.storeFile(uploadDto.getFile(), subDir);

        doc.setCurrentVersion(nextVersion);
        doc.setStatus(DocumentStatus.UNDER_REVIEW);
        doc.setFileName(uploadDto.getFile().getOriginalFilename());
        doc.setStoredFilePath(storedPath);
        doc.setFileSizeBytes(uploadDto.getFile().getSize());
        doc.setMimeType(uploadDto.getFile().getContentType());
        doc.setSha256Hash(sha256Hash);
        doc.setVerifiedAt(null);
        doc.setVerifiedByUser(null);
        doc.setRejectionReason(null);
        doc.setRejectionRemarks(null);
        if (uploadDto.getIssueDate() != null) doc.setIssueDate(uploadDto.getIssueDate());
        if (uploadDto.getExpiryDate() != null) doc.setExpiryDate(uploadDto.getExpiryDate());

        doc = documentRepository.save(doc);

        DocumentVersion version = DocumentVersion.builder()
                .document(doc)
                .versionNumber(nextVersion)
                .fileName(uploadDto.getFile().getOriginalFilename())
                .storedFilePath(storedPath)
                .fileSizeBytes(uploadDto.getFile().getSize())
                .mimeType(uploadDto.getFile().getContentType())
                .sha256Hash(sha256Hash)
                .uploadedByUser(uploader)
                .changeSummary(uploadDto.getChangeSummary() != null ? uploadDto.getChangeSummary() : "Uploaded version " + nextVersion)
                .build();
        versionRepository.save(version);

        completenessScoreService.calculateScore(doc.getStudent().getId());

        auditLogService.logAction(uploader, AuditAction.UPLOAD_DOC, "DOCUMENT", doc.getId(), ipAddress,
                "Uploaded version " + nextVersion + " for document: " + doc.getDocumentCode());

        return doc;
    }

    @Override
    public Document findById(Long id) {
        return documentRepository.findById(id)
                .orElseThrow(() -> new DocumentNotFoundException("Document not found with id: " + id));
    }

    @Override
    public Document findByCode(String code) {
        return documentRepository.findByDocumentCode(code)
                .orElseThrow(() -> new DocumentNotFoundException("Document not found with code: " + code));
    }

    @Override
    public Document findByVerificationToken(String token) {
        return documentRepository.findByVerificationToken(token)
                .orElseThrow(() -> new DocumentNotFoundException("Document not found with verification token: " + token));
    }

    @Override
    public List<Document> findByStudent(Long studentId) {
        return documentRepository.findByStudentId(studentId);
    }

    @Override
    public List<Document> findStudentAchievements(Long studentId) {
        // Category 4 represents CERTIFICATES & ACHIEVEMENTS
        return documentRepository.findByStudentIdAndDocumentTypeCategoryId(studentId, 4L);
    }

    @Override
    public List<Document> findByStudentAndCategory(Long studentId, Long categoryId) {
        return documentRepository.findByStudentIdAndDocumentTypeCategoryId(studentId, categoryId);
    }

    @Override
    public List<Document> findByStatus(DocumentStatus status) {
        return documentRepository.findByStatus(status);
    }

    @Override
    public List<Document> searchDocuments(String query, DocumentStatus status, Long typeId, Long deptId) {
        return documentRepository.searchDocuments(query, status, typeId, deptId);
    }

    @Override
    public DocumentDetailsDto getDocumentDetailsDto(Long documentId) {
        Document d = findById(documentId);
        return DocumentDetailsDto.builder()
                .id(d.getId())
                .documentCode(d.getDocumentCode())
                .studentId(d.getStudent().getId())
                .studentName(d.getStudent().getFullName())
                .enrollmentNo(d.getStudent().getEnrollmentNo())
                .documentTypeId(d.getDocumentType().getId())
                .documentTypeName(d.getDocumentType().getTypeName())
                .categoryName(d.getDocumentType().getCategory().getCategoryName())
                .iconClass(d.getDocumentType().getCategory().getIconClass())
                .title(d.getTitle())
                .currentVersion(d.getCurrentVersion())
                .status(d.getStatus())
                .fileName(d.getFileName())
                .fileSizeBytes(d.getFileSizeBytes())
                .formattedFileSize(FileUtil.formatFileSize(d.getFileSizeBytes()))
                .mimeType(d.getMimeType())
                .sha256Hash(d.getSha256Hash())
                .verificationToken(d.getVerificationToken())
                .qrCodePath(d.getQrCodePath())
                .issueDate(d.getIssueDate())
                .expiryDate(d.getExpiryDate())
                .verifiedAt(d.getVerifiedAt())
                .verifiedByName(d.getVerifiedByUser() != null ? d.getVerifiedByUser().getUsername() : null)
                .rejectionReason(d.getRejectionReason())
                .rejectionRemarks(d.getRejectionRemarks())
                .createdAt(d.getCreatedAt())
                .updatedAt(d.getUpdatedAt())
                .build();
    }

    @Override
    @Transactional
    public Resource getDocumentFileResource(Long documentId, Long requestingUserId, DownloadType downloadType, String ipAddress) {
        Document doc = findById(documentId);
        User requestingUser = requestingUserId != null ? userRepository.findById(requestingUserId).orElse(null) : null;

        DownloadHistory downloadHistory = DownloadHistory.builder()
                .document(doc)
                .downloadedByUser(requestingUser)
                .downloadType(downloadType)
                .ipAddress(ipAddress)
                .build();
        downloadHistoryRepository.save(downloadHistory);

        auditLogService.logAction(requestingUser, AuditAction.DOWNLOAD_DOC, "DOCUMENT", doc.getId(), ipAddress,
                "Downloaded file for document: " + doc.getDocumentCode() + " via " + downloadType);

        return storageService.loadAsResource(doc.getStoredFilePath());
    }

    @Override
    @Transactional
    public void deleteDocument(Long id, Long adminUserId, String ipAddress) {
        Document doc = findById(id);
        User admin = userRepository.findById(adminUserId).orElse(null);
        Long studentId = doc.getStudent().getId();

        doc.setIsArchived(true);
        documentRepository.save(doc);

        completenessScoreService.calculateScore(studentId);

        auditLogService.logAction(admin, AuditAction.UPDATE_USER, "DOCUMENT", doc.getId(), ipAddress,
                "Archived document: " + doc.getDocumentCode());
    }
}
