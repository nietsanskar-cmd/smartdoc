package com.smartdoc.controller;

import com.smartdoc.dto.request.DocumentRequestCreateDto;
import com.smartdoc.dto.request.DocumentUploadDto;
import com.smartdoc.dto.response.CompletenessScoreDto;
import com.smartdoc.dto.response.DocumentDetailsDto;
import com.smartdoc.entity.Document;
import com.smartdoc.entity.Student;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/student")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;
    private final DocumentService documentService;
    private final DocumentTypeService documentTypeService;
    private final CompletenessScoreService completenessScoreService;
    private final DocumentRequestService documentRequestService;
    private final DocumentShareService documentShareService;
    private final NotificationService notificationService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        CompletenessScoreDto scoreDto = completenessScoreService.calculateScore(student.getId());
        List<Document> documents = documentService.findByStudent(student.getId());

        model.addAttribute("student", student);
        model.addAttribute("profile", studentService.getProfileDto(student.getId()));
        model.addAttribute("scoreDto", scoreDto);
        model.addAttribute("documents", documents);
        model.addAttribute("recentDocs", documents.stream().limit(5).toList());
        model.addAttribute("recentNotifications", notificationService.getUserNotifications(userSession.getUserId()).stream().limit(5).toList());
        model.addAttribute("unreadCount", notificationService.getUnreadCount(userSession.getUserId()));
        return "student/dashboard";
    }

    @GetMapping("/vault")
    public String viewVault(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        model.addAttribute("student", student);
        model.addAttribute("documents", documentService.findByStudent(student.getId()));
        model.addAttribute("categories", documentTypeService.findAllCategories());
        model.addAttribute("scoreDto", completenessScoreService.calculateScore(student.getId()));
        return "student/vault";
    }

    @GetMapping("/achievements")
    public String viewAchievements(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        List<Document> achievements = documentService.findStudentAchievements(student.getId());

        long internshipCount = achievements.stream()
                .filter(d -> "INTERNSHIP_CERT".equalsIgnoreCase(d.getDocumentType().getTypeCode()))
                .count();
        long researchPaperCount = achievements.stream()
                .filter(d -> "RESEARCH_PAPER".equalsIgnoreCase(d.getDocumentType().getTypeCode()) || "PATENT_PUBLICATION".equalsIgnoreCase(d.getDocumentType().getTypeCode()))
                .count();
        long certCount = achievements.stream()
                .filter(d -> "COURSE_CERT".equalsIgnoreCase(d.getDocumentType().getTypeCode()) || "WORKSHOP_CERT".equalsIgnoreCase(d.getDocumentType().getTypeCode()))
                .count();
        long awardCount = achievements.stream()
                .filter(d -> "HACKATHON_AWARD".equalsIgnoreCase(d.getDocumentType().getTypeCode()) || "EXTRACURRICULAR_CERT".equalsIgnoreCase(d.getDocumentType().getTypeCode()))
                .count();

        model.addAttribute("student", student);
        model.addAttribute("achievements", achievements);
        model.addAttribute("totalCount", achievements.size());
        model.addAttribute("internshipCount", internshipCount);
        model.addAttribute("researchPaperCount", researchPaperCount);
        model.addAttribute("certCount", certCount);
        model.addAttribute("awardCount", awardCount);
        model.addAttribute("achievementTypes", documentTypeService.findTypesByCategory(4L));
        return "student/achievements";
    }

    @GetMapping("/achievements/upload")
    public String showAchievementUploadForm(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        model.addAttribute("student", student);
        model.addAttribute("achievementTypes", documentTypeService.findTypesByCategory(4L));
        model.addAttribute("uploadDto", new DocumentUploadDto());
        return "student/upload-achievement";
    }

    @PostMapping("/achievements/upload")
    public String processAchievementUpload(@Valid @ModelAttribute("uploadDto") DocumentUploadDto uploadDto,
                                           BindingResult result,
                                           HttpSession session,
                                           HttpServletRequest request,
                                           Model model,
                                           RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        if (result.hasErrors() || uploadDto.getFile() == null || uploadDto.getFile().isEmpty()) {
            if (uploadDto.getFile() == null || uploadDto.getFile().isEmpty()) {
                model.addAttribute("errorMessage", "Please select an achievement file to upload.");
            }
            model.addAttribute("student", student);
            model.addAttribute("achievementTypes", documentTypeService.findTypesByCategory(4L));
            return "student/upload-achievement";
        }

        try {
            documentService.uploadDocument(student.getId(), uploadDto, userSession.getUserId(), request.getRemoteAddr());
            redirectAttributes.addFlashAttribute("successMessage", "Achievement uploaded successfully and added to your portfolio!");
            return "redirect:/student/achievements";
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("student", student);
            model.addAttribute("achievementTypes", documentTypeService.findTypesByCategory(4L));
            return "student/upload-achievement";
        }
    }

    @GetMapping("/upload")
    public String showUploadForm(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        model.addAttribute("student", student);
        model.addAttribute("documentTypes", documentTypeService.findAllActiveTypes());
        model.addAttribute("uploadDto", new DocumentUploadDto());
        return "student/upload";
    }

    @PostMapping("/upload")
    public String processUpload(@Valid @ModelAttribute("uploadDto") DocumentUploadDto uploadDto,
                                BindingResult result,
                                HttpSession session,
                                HttpServletRequest request,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        if (result.hasErrors() || uploadDto.getFile() == null || uploadDto.getFile().isEmpty()) {
            if (uploadDto.getFile() == null || uploadDto.getFile().isEmpty()) {
                model.addAttribute("errorMessage", "Please select a file to upload.");
            }
            model.addAttribute("student", student);
            model.addAttribute("documentTypes", documentTypeService.findAllActiveTypes());
            return "student/upload";
        }

        try {
            documentService.uploadDocument(student.getId(), uploadDto, userSession.getUserId(), request.getRemoteAddr());
            redirectAttributes.addFlashAttribute("successMessage", "Document uploaded successfully and queued for review.");
            return "redirect:/student/vault";
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("student", student);
            model.addAttribute("documentTypes", documentTypeService.findAllActiveTypes());
            return "student/upload";
        }
    }

    @GetMapping("/document/{id}")
    public String documentDetails(@PathVariable("id") Long id, HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        DocumentDetailsDto doc = documentService.getDocumentDetailsDto(id);

        model.addAttribute("doc", doc);
        model.addAttribute("versionDto", new DocumentUploadDto());
        return "student/document-details";
    }

    @PostMapping("/document/{id}/version")
    public String uploadNewVersion(@PathVariable("id") Long id,
                                   @ModelAttribute("versionDto") DocumentUploadDto uploadDto,
                                   HttpSession session,
                                   HttpServletRequest request,
                                   RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        try {
            documentService.uploadNewVersion(id, uploadDto, userSession.getUserId(), request.getRemoteAddr());
            redirectAttributes.addFlashAttribute("successMessage", "New version uploaded successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/student/document/" + id;
    }

    @GetMapping("/requests")
    public String viewRequests(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        model.addAttribute("requests", documentRequestService.findByStudent(student.getId()));
        model.addAttribute("documentTypes", documentTypeService.findAllActiveTypes());
        model.addAttribute("requestDto", new DocumentRequestCreateDto());
        return "student/request-document";
    }

    @PostMapping("/requests/new")
    public String submitRequest(@Valid @ModelAttribute("requestDto") DocumentRequestCreateDto dto,
                                BindingResult result,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please provide a valid document type and purpose.");
            return "redirect:/student/requests";
        }

        try {
            documentRequestService.submitRequest(student.getId(), dto);
            redirectAttributes.addFlashAttribute("successMessage", "Official document request submitted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/student/requests";
    }

    @GetMapping("/shares")
    public String manageShares(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());

        model.addAttribute("shares", documentShareService.getStudentShares(student.getId()));
        model.addAttribute("verifiedDocs", documentService.findByStudent(student.getId()).stream()
                .filter(d -> "VERIFIED".equals(d.getStatus().name()) || "ACTIVE".equals(d.getStatus().name())).toList());
        return "student/share-manager";
    }

    @GetMapping("/profile")
    public String viewProfile(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Student student = studentService.findByUserId(userSession.getUserId());
        model.addAttribute("profile", studentService.getProfileDto(student.getId()));
        return "student/profile";
    }
}
