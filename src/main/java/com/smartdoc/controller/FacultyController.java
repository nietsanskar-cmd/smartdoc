package com.smartdoc.controller;

import com.smartdoc.dto.request.DocumentVerificationDto;
import com.smartdoc.dto.response.DocumentDetailsDto;
import com.smartdoc.dto.response.VerificationQueueDto;
import com.smartdoc.entity.Document;
import com.smartdoc.entity.Faculty;
import com.smartdoc.entity.Student;
import com.smartdoc.entity.enums.VerificationAction;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/faculty")
@RequiredArgsConstructor
public class FacultyController {

    private final VerificationService verificationService;
    private final FacultyService facultyService;
    private final StudentService studentService;
    private final DocumentService documentService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Faculty faculty = facultyService.findByUserId(userSession.getUserId());

        List<VerificationQueueDto> queue = verificationService.getQueueForFaculty(faculty.getId());
        List<Student> assignedStudents = studentService.findByAssignedFaculty(faculty.getId());

        model.addAttribute("faculty", faculty);
        model.addAttribute("queue", queue);
        model.addAttribute("assignedStudents", assignedStudents);
        model.addAttribute("pendingCount", queue.size());
        model.addAttribute("studentCount", assignedStudents.size());
        return "faculty/dashboard";
    }

    @GetMapping("/queue")
    public String viewQueue(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Faculty faculty = facultyService.findByUserId(userSession.getUserId());
        List<VerificationQueueDto> queue = verificationService.getQueueForFaculty(faculty.getId());
        model.addAttribute("queue", queue);
        return "faculty/verification-queue";
    }

    @GetMapping("/review/{id}")
    public String reviewDocument(@PathVariable("id") Long id, Model model) {
        DocumentDetailsDto doc = documentService.getDocumentDetailsDto(id);
        model.addAttribute("doc", doc);
        model.addAttribute("verificationDto", new DocumentVerificationDto());
        model.addAttribute("actions", VerificationAction.values());
        return "faculty/review-document";
    }

    @PostMapping("/verify/{id}")
    public String submitVerification(@PathVariable("id") Long id,
                                     @Valid @ModelAttribute("verificationDto") DocumentVerificationDto dto,
                                     HttpSession session,
                                     HttpServletRequest request,
                                     RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        try {
            verificationService.processVerification(id, userSession.getUserId(), dto, request.getRemoteAddr());
            redirectAttributes.addFlashAttribute("successMessage", "Document verification decision submitted successfully.");
            return "redirect:/faculty/queue";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/faculty/review/" + id;
        }
    }

    @GetMapping("/students")
    public String listAssignedStudents(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Faculty faculty = facultyService.findByUserId(userSession.getUserId());
        model.addAttribute("students", studentService.findByAssignedFaculty(faculty.getId()));
        return "faculty/assigned-students";
    }

    @GetMapping("/department-stats")
    public String departmentStats(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        Faculty faculty = facultyService.findByUserId(userSession.getUserId());
        model.addAttribute("faculty", faculty);
        model.addAttribute("departmentStudents", studentService.findByDepartment(faculty.getDepartment().getId()));
        return "faculty/department-stats";
    }
}
