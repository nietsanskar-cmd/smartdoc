package com.smartdoc.service;

import com.smartdoc.dto.request.DocumentVerificationDto;
import com.smartdoc.dto.response.VerificationQueueDto;
import com.smartdoc.entity.Document;
import java.util.List;

public interface VerificationService {
    Document processVerification(Long documentId, Long facultyUserId, DocumentVerificationDto dto, String ipAddress);
    List<VerificationQueueDto> getQueueForFaculty(Long facultyId);
    List<VerificationQueueDto> getAllPendingQueue();
}
