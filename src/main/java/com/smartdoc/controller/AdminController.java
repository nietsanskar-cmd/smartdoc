package com.smartdoc.controller;

import com.smartdoc.dto.request.FacultyRegistrationDto;
import com.smartdoc.dto.response.DashboardAnalyticsDto;
import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.entity.enums.RequestStatus;
import com.smartdoc.repository.*;
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
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AnalyticsService analyticsService;
    private final StudentService studentService;
    private final FacultyService facultyService;
    private final UserService userService;
    private final DepartmentService departmentService;
    private final CourseService courseService;
    private final DocumentTypeService documentTypeService;
    private final DocumentService documentService;
    private final DocumentRequestService documentRequestService;
    private final AuditLogService auditLogService;
    private final DownloadHistoryRepository downloadHistoryRepository;
    private final SystemSettingRepository systemSettingRepository;

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        DashboardAnalyticsDto analytics = analyticsService.getAdminAnalytics();
        model.addAttribute("analytics", analytics);
        model.addAttribute("recentLogs", auditLogService.getRecentAuditLogs().stream().limit(8).toList());
        model.addAttribute("pendingRequests", documentRequestService.findByStatus(RequestStatus.REQUESTED));
        return "admin/dashboard";
    }

    @GetMapping("/students")
    public String listStudents(@RequestParam(value = "query", required = false) String query,
                               @RequestParam(value = "deptId", required = false) Long deptId,
                               @RequestParam(value = "courseId", required = false) Long courseId,
                               Model model) {
        List<Student> students;
        if (query != null || deptId != null || courseId != null) {
            students = studentService.searchStudents(query, deptId, courseId);
        } else {
            students = studentService.findAllStudents();
        }
        model.addAttribute("students", students);
        model.addAttribute("departments", departmentService.findAllActive());
        model.addAttribute("courses", courseService.findAllActive());
        model.addAttribute("selectedQuery", query);
        model.addAttribute("selectedDept", deptId);
        model.addAttribute("selectedCourse", courseId);
        return "admin/students";
    }

    @GetMapping("/students/{id}")
    public String viewStudentDetails(@PathVariable("id") Long id, Model model) {
        Student student = studentService.findById(id);
        model.addAttribute("student", student);
        model.addAttribute("profile", studentService.getProfileDto(id));
        model.addAttribute("documents", documentService.findByStudent(id));
        model.addAttribute("facultyList", facultyService.findByDepartment(student.getDepartment().getId()));
        return "admin/student-detail";
    }

    @PostMapping("/students/{id}/assign-faculty")
    public String assignFaculty(@PathVariable("id") Long id,
                                @RequestParam("facultyId") Long facultyId,
                                RedirectAttributes redirectAttributes) {
        studentService.assignFacultyAdvisor(id, facultyId);
        redirectAttributes.addFlashAttribute("successMessage", "Faculty advisor assigned successfully.");
        return "redirect:/admin/students/" + id;
    }

    @GetMapping("/faculty")
    public String listFaculty(Model model) {
        model.addAttribute("facultyList", facultyService.findAll());
        model.addAttribute("departments", departmentService.findAllActive());
        model.addAttribute("newFaculty", new FacultyRegistrationDto());
        return "admin/faculty";
    }

    @PostMapping("/faculty/create")
    public String createFaculty(@Valid @ModelAttribute("newFaculty") FacultyRegistrationDto dto,
                                BindingResult result,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("facultyList", facultyService.findAll());
            model.addAttribute("departments", departmentService.findAllActive());
            return "admin/faculty";
        }
        try {
            userService.registerFaculty(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Faculty account created successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/faculty";
    }

    @PostMapping("/users/{id}/toggle-status")
    public String toggleUserStatus(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        userService.toggleUserStatus(id);
        redirectAttributes.addFlashAttribute("successMessage", "User account status updated.");
        return "redirect:/admin/students";
    }

    @GetMapping("/departments")
    public String manageDepartments(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        model.addAttribute("newDept", new Department());
        return "admin/departments";
    }

    @PostMapping("/departments/create")
    public String createDepartment(@ModelAttribute("newDept") Department department, RedirectAttributes redirectAttributes) {
        try {
            departmentService.create(department);
            redirectAttributes.addFlashAttribute("successMessage", "Department created successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/departments";
    }

    @GetMapping("/courses")
    public String manageCourses(Model model) {
        model.addAttribute("courses", courseService.findAll());
        model.addAttribute("departments", departmentService.findAllActive());
        model.addAttribute("newCourse", new Course());
        return "admin/courses";
    }

    @PostMapping("/courses/create")
    public String createCourse(@ModelAttribute("newCourse") Course course,
                               @RequestParam("departmentId") Long deptId,
                               RedirectAttributes redirectAttributes) {
        try {
            Department dept = departmentService.findById(deptId);
            course.setDepartment(dept);
            courseService.create(course);
            redirectAttributes.addFlashAttribute("successMessage", "Course created successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/courses";
    }

    @GetMapping("/document-types")
    public String manageDocumentTypes(Model model) {
        model.addAttribute("documentTypes", documentTypeService.findAllTypes());
        model.addAttribute("categories", documentTypeService.findAllCategories());
        model.addAttribute("newType", new DocumentType());
        return "admin/document-types";
    }

    @PostMapping("/document-types/create")
    public String createDocumentType(@ModelAttribute("newType") DocumentType documentType,
                                     @RequestParam("categoryId") Long categoryId,
                                     RedirectAttributes redirectAttributes) {
        try {
            DocumentCategory cat = documentTypeService.findAllCategories().stream()
                    .filter(c -> c.getId().equals(categoryId)).findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("Category not found"));
            documentType.setCategory(cat);
            documentTypeService.createType(documentType);
            redirectAttributes.addFlashAttribute("successMessage", "Document type added to institutional catalog.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/document-types";
    }

    @GetMapping("/required-documents")
    public String manageRequiredDocuments(Model model) {
        model.addAttribute("rules", documentTypeService.findAllRequiredRules());
        model.addAttribute("documentTypes", documentTypeService.findAllActiveTypes());
        model.addAttribute("courses", courseService.findAllActive());
        model.addAttribute("newRule", new RequiredDocument());
        return "admin/required-documents";
    }

    @PostMapping("/required-documents/create")
    public String createRequiredDocumentRule(@RequestParam("documentTypeId") Long typeId,
                                             @RequestParam(value = "courseId", required = false) Long courseId,
                                             @RequestParam("weightage") Integer weightage,
                                             RedirectAttributes redirectAttributes) {
        try {
            DocumentType dt = documentTypeService.findTypeById(typeId);
            Course c = courseId != null ? courseService.findById(courseId) : null;
            RequiredDocument req = RequiredDocument.builder()
                    .documentType(dt)
                    .course(c)
                    .isMandatory(true)
                    .weightage(weightage != null ? weightage : 10)
                    .build();
            documentTypeService.saveRequiredRule(req);
            redirectAttributes.addFlashAttribute("successMessage", "Mandatory document rule configured successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/required-documents";
    }

    @GetMapping("/documents")
    public String listAllDocuments(@RequestParam(value = "query", required = false) String query,
                                   @RequestParam(value = "status", required = false) DocumentStatus status,
                                   @RequestParam(value = "typeId", required = false) Long typeId,
                                   @RequestParam(value = "deptId", required = false) Long deptId,
                                   Model model) {
        model.addAttribute("documents", documentService.searchDocuments(query, status, typeId, deptId));
        model.addAttribute("documentTypes", documentTypeService.findAllActiveTypes());
        model.addAttribute("departments", departmentService.findAllActive());
        model.addAttribute("statuses", DocumentStatus.values());
        return "admin/all-documents";
    }

    @GetMapping("/requests")
    public String manageRequests(Model model) {
        model.addAttribute("requests", documentRequestService.findAllRequests());
        return "admin/document-requests";
    }

    @PostMapping("/requests/{id}/status")
    public String updateRequestStatus(@PathVariable("id") Long id,
                                      @RequestParam("status") RequestStatus status,
                                      @RequestParam(value = "adminRemarks", required = false) String remarks,
                                      HttpSession session,
                                      HttpServletRequest request,
                                      RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        documentRequestService.processRequest(id, status, remarks, userSession.getUserId(), request.getRemoteAddr());
        redirectAttributes.addFlashAttribute("successMessage", "Request status updated to " + status);
        return "redirect:/admin/requests";
    }

    @GetMapping("/audit-logs")
    public String viewAuditLogs(Model model) {
        model.addAttribute("logs", auditLogService.getRecentAuditLogs());
        return "admin/audit-logs";
    }

    @GetMapping("/download-logs")
    public String viewDownloadLogs(Model model) {
        model.addAttribute("logs", downloadHistoryRepository.findTop50ByOrderByDownloadedAtDesc());
        return "admin/download-logs";
    }

    @GetMapping("/system-settings")
    public String viewSettings(Model model) {
        model.addAttribute("settings", systemSettingRepository.findAll());
        return "admin/system-settings";
    }
}
