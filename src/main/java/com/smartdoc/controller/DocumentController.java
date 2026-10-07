package com.smartdoc.controller;

import com.smartdoc.entity.Document;
import com.smartdoc.entity.enums.DownloadType;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.DocumentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/documents")
@RequiredArgsConstructor
public class DocumentController {

    private final DocumentService documentService;

    @GetMapping("/view/{id}")
    public ResponseEntity<Resource> viewDocumentInline(@PathVariable("id") Long id,
                                                       HttpSession session,
                                                       HttpServletRequest request) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Long userId = userSession != null ? userSession.getUserId() : null;
        Document doc = documentService.findById(id);

        DownloadType type = DownloadType.DIRECT_USER;
        if (userSession != null) {
            if (userSession.isAdmin()) type = DownloadType.ADMIN_AUDIT;
            else if (userSession.isFaculty()) type = DownloadType.FACULTY_REVIEW;
        }

        Resource resource = documentService.getDocumentFileResource(id, userId, type, request.getRemoteAddr());

        String contentType = doc.getMimeType();
        if (contentType == null || contentType.isEmpty()) {
            contentType = "application/octet-stream";
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + doc.getFileName() + "\"")
                .body(resource);
    }

    @GetMapping("/download/{id}")
    public ResponseEntity<Resource> downloadDocumentAttachment(@PathVariable("id") Long id,
                                                              HttpSession session,
                                                              HttpServletRequest request) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Long userId = userSession != null ? userSession.getUserId() : null;
        Document doc = documentService.findById(id);

        DownloadType type = DownloadType.DIRECT_USER;
        if (userSession != null) {
            if (userSession.isAdmin()) type = DownloadType.ADMIN_AUDIT;
            else if (userSession.isFaculty()) type = DownloadType.FACULTY_REVIEW;
        }

        Resource resource = documentService.getDocumentFileResource(id, userId, type, request.getRemoteAddr());

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + doc.getFileName() + "\"")
                .body(resource);
    }
}
