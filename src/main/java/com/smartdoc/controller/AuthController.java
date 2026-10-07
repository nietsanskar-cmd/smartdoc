package com.smartdoc.controller;

import com.smartdoc.dto.request.LoginRequestDto;
import com.smartdoc.dto.request.StudentRegistrationDto;
import com.smartdoc.entity.Department;
import com.smartdoc.entity.Course;
import com.smartdoc.entity.AcademicYear;
import com.smartdoc.entity.Semester;
import com.smartdoc.entity.enums.RoleType;
import com.smartdoc.repository.AcademicYearRepository;
import com.smartdoc.repository.SemesterRepository;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.CourseService;
import com.smartdoc.service.DepartmentService;
import com.smartdoc.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final DepartmentService departmentService;
    private final CourseService courseService;
    private final AcademicYearRepository academicYearRepository;
    private final SemesterRepository semesterRepository;

    @GetMapping("/")
    public String index(HttpSession session) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        if (userSession != null) {
            if (userSession.isAdmin()) return "redirect:/admin/dashboard";
            if (userSession.isFaculty()) return "redirect:/faculty/dashboard";
            if (userSession.isStudent()) return "redirect:/student/dashboard";
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginForm(@RequestParam(value = "error", required = false) String error,
                                @RequestParam(value = "sessionExpired", required = false) String sessionExpired,
                                @RequestParam(value = "registered", required = false) String registered,
                                Model model, HttpSession session) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        if (userSession != null) {
            return "redirect:/";
        }

        if (error != null) model.addAttribute("errorMessage", "Invalid college ID or password");
        if (sessionExpired != null) model.addAttribute("infoMessage", "Your session has expired. Please log in again.");
        if (registered != null) model.addAttribute("successMessage", "Registration successful! You can now log in with your NIET college ID.");

        model.addAttribute("loginRequest", new LoginRequestDto());
        return "auth/login";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm(Model model, HttpSession session) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        if (userSession != null) {
            return "redirect:/";
        }
        return "auth/forgot-password";
    }

    @PostMapping("/login")
    public String processLogin(@Valid @ModelAttribute("loginRequest") LoginRequestDto loginDto,
                               BindingResult bindingResult,
                               HttpServletRequest request,
                               HttpSession session,
                               Model model) {
        if (bindingResult.hasErrors()) {
            return "auth/login";
        }

        try {
            String ip = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");
            UserSession userSession = userService.authenticate(loginDto, ip, userAgent);
            session.setAttribute("CURRENT_USER", userSession);

            if (userSession.isAdmin()) {
                return "redirect:/admin/dashboard";
            } else if (userSession.isFaculty()) {
                return "redirect:/faculty/dashboard";
            } else {
                return "redirect:/student/dashboard";
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "auth/login";
        }
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("studentDto", new StudentRegistrationDto());
        model.addAttribute("departments", departmentService.findAllActive());
        model.addAttribute("courses", courseService.findAllActive());
        model.addAttribute("academicYears", academicYearRepository.findAll());
        model.addAttribute("semesters", semesterRepository.findAll());
        return "auth/register-student";
    }

    @PostMapping("/register")
    public String processRegistration(@Valid @ModelAttribute("studentDto") StudentRegistrationDto dto,
                                      BindingResult bindingResult,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("departments", departmentService.findAllActive());
            model.addAttribute("courses", courseService.findAllActive());
            model.addAttribute("academicYears", academicYearRepository.findAll());
            model.addAttribute("semesters", semesterRepository.findAll());
            return "auth/register-student";
        }

        try {
            userService.registerStudent(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Registration successful! Please log in with your credentials.");
            return "redirect:/login";
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("departments", departmentService.findAllActive());
            model.addAttribute("courses", courseService.findAllActive());
            model.addAttribute("academicYears", academicYearRepository.findAll());
            model.addAttribute("semesters", semesterRepository.findAll());
            return "auth/register-student";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        if (userSession != null) {
            userService.recordLogout(userSession.getUserId());
        }
        session.invalidate();
        return "redirect:/login?logout=true";
    }
}
