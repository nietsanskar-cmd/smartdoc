package com.smartdoc.service;

import com.smartdoc.dto.request.DocumentShareCreateDto;
import com.smartdoc.dto.response.ShareDetailsDto;
import com.smartdoc.entity.DocumentShare;
import org.springframework.core.io.Resource;
import java.util.List;

public interface DocumentShareService {
    DocumentShare createShare(Long studentId, DocumentShareCreateDto dto);
    DocumentShare findByToken(String shareToken);
    boolean validatePasscode(DocumentShare share, String rawPasscode);
    Resource accessSharedDocument(String shareToken, String passcode, String ipAddress, String userAgent);
    void revokeShare(Long shareId, Long studentId);
    List<ShareDetailsDto> getStudentShares(Long studentId);
}
