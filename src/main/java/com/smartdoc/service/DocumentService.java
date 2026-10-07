package com.smartdoc.service;

import com.smartdoc.dto.request.DocumentUploadDto;
import com.smartdoc.dto.response.DocumentDetailsDto;
import com.smartdoc.entity.Document;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.entity.enums.DownloadType;
import org.springframework.core.io.Resource;

import java.util.List;

public interface DocumentService {
    Document uploadDocument(Long studentId, DocumentUploadDto uploadDto, Long uploaderUserId, String ipAddress);
    Document uploadNewVersion(Long documentId, DocumentUploadDto uploadDto, Long uploaderUserId, String ipAddress);
    Document findById(Long id);
    Document findByCode(String code);
    Document findByVerificationToken(String token);
    List<Document> findByStudent(Long studentId);
    List<Document> findStudentAchievements(Long studentId);
    List<Document> findByStudentAndCategory(Long studentId, Long categoryId);
    List<Document> findByStatus(DocumentStatus status);
    List<Document> searchDocuments(String query, DocumentStatus status, Long typeId, Long deptId);
    DocumentDetailsDto getDocumentDetailsDto(Long documentId);
    Resource getDocumentFileResource(Long documentId, Long requestingUserId, DownloadType downloadType, String ipAddress);
    void deleteDocument(Long id, Long adminUserId, String ipAddress);
}
