package com.smartdoc.service;

import com.smartdoc.entity.Document;
import com.smartdoc.entity.DocumentShare;
import com.smartdoc.entity.Student;
import com.smartdoc.entity.User;
import com.smartdoc.exception.ShareLinkExpiredException;
import com.smartdoc.repository.DocumentShareLogRepository;
import com.smartdoc.repository.DocumentShareRepository;
import com.smartdoc.security.PasswordEncoderUtil;
import com.smartdoc.service.impl.DocumentShareServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DocumentShareServiceTest {

    @Mock
    private DocumentShareRepository shareRepository;
    @Mock
    private DocumentShareLogRepository shareLogRepository;
    @Mock
    private StorageService storageService;
    @Mock
    private PasswordEncoderUtil passwordEncoder;
    @Mock
    private AuditLogService auditLogService;

    @InjectMocks
    private DocumentShareServiceImpl shareService;

    @Test
    void testAccessSharedDocument_Expired_ThrowsException() {
        Document doc = Document.builder().id(1L).storedFilePath("storage/sample.pdf").build();
        DocumentShare expiredShare = DocumentShare.builder()
                .id(1L)
                .document(doc)
                .shareToken("SH-EXPIRED-TOKEN")
                .expiresAt(LocalDateTime.now().minusHours(1))
                .isRevoked(false)
                .build();

        when(shareRepository.findByShareToken("SH-EXPIRED-TOKEN")).thenReturn(Optional.of(expiredShare));

        assertThrows(ShareLinkExpiredException.class, () ->
                shareService.accessSharedDocument("SH-EXPIRED-TOKEN", null, "127.0.0.1", "Agent")
        );
    }

    @Test
    void testAccessSharedDocument_Valid() {
        Document doc = Document.builder().id(1L).storedFilePath("storage/sample.pdf").build();
        DocumentShare validShare = DocumentShare.builder()
                .id(1L)
                .document(doc)
                .shareToken("SH-VALID-TOKEN")
                .expiresAt(LocalDateTime.now().plusHours(24))
                .maxAccessCount(10)
                .currentAccessCount(0)
                .isRevoked(false)
                .build();

        when(shareRepository.findByShareToken("SH-VALID-TOKEN")).thenReturn(Optional.of(validShare));
        when(storageService.loadAsResource("storage/sample.pdf")).thenReturn(new ByteArrayResource("test".getBytes()));

        Resource res = shareService.accessSharedDocument("SH-VALID-TOKEN", null, "127.0.0.1", "Agent");

        assertNotNull(res);
        assertEquals(1, validShare.getCurrentAccessCount());
        verify(shareRepository, times(1)).save(validShare);
    }
}
