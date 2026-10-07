package com.smartdoc.controller;

import com.smartdoc.dto.request.DocumentShareCreateDto;
import com.smartdoc.entity.DocumentShare;
import com.smartdoc.entity.Student;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.DocumentShareService;
import com.smartdoc.service.StudentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class DocumentShareController {

    private final DocumentShareService documentShareService;
    private final StudentService studentService;

    @PostMapping("/student/shares/create")
    public String createShare(@Valid @ModelAttribute("shareDto") DocumentShareCreateDto dto,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());
        try {
            documentShareService.createShare(student.getId(), dto);
            redirectAttributes.addFlashAttribute("successMessage", "Secure sharing link created successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/student/shares";
    }

    @PostMapping("/student/shares/{id}/revoke")
    public String revokeShare(@PathVariable("id") Long id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());
        try {
            documentShareService.revokeShare(id, student.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Sharing link revoked successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/student/shares";
    }

    @GetMapping("/shared/{token}")
    public String viewSharedLanding(@PathVariable("token") String token, Model model) {
        try {
            DocumentShare share = documentShareService.findByToken(token);
            if (share.isExpired()) {
                model.addAttribute("errorMessage", "This secure document link has expired or reached maximum access limits.");
                return "public/shared-expired";
            }
            model.addAttribute("share", share);
            model.addAttribute("requiresPasscode", share.getAccessPasscodeHash() != null && !share.getAccessPasscodeHash().isEmpty());
            return "public/shared-view";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Invalid or unrecognized share token.");
            return "public/shared-expired";
        }
    }

    @PostMapping("/shared/{token}/access")
    public ResponseEntity<Resource> accessSharedFile(@PathVariable("token") String token,
                                                     @RequestParam(value = "passcode", required = false) String passcode,
                                                     HttpServletRequest request) {
        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");
        Resource resource = documentShareService.accessSharedDocument(token, passcode, ip, userAgent);
        DocumentShare share = documentShareService.findByToken(token);

        String contentType = share.getDocument().getMimeType();
        if (contentType == null || contentType.isEmpty()) {
            contentType = "application/octet-stream";
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + share.getDocument().getFileName() + "\"")
                .body(resource);
    }
}
