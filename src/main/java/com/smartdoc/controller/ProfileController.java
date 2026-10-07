package com.smartdoc.controller;

import com.smartdoc.dto.request.ProfileUpdateDto;
import com.smartdoc.entity.User;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.FacultyService;
import com.smartdoc.service.StudentService;
import com.smartdoc.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final UserService userService;
    private final StudentService studentService;
    private final FacultyService facultyService;

    @GetMapping
    public String viewProfile(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        User user = userService.findById(userSession.getUserId());
        model.addAttribute("user", user);

        if (userSession.isStudent()) {
            model.addAttribute("profile", studentService.getProfileDto(userSession.getStudentId()));
            return "student/profile";
        } else if (userSession.isFaculty()) {
            model.addAttribute("faculty", facultyService.findById(userSession.getFacultyId()));
            return "faculty/profile";
        }
        return "admin/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@ModelAttribute ProfileUpdateDto dto,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        try {
            userService.updatePassword(userSession.getUserId(), dto.getCurrentPassword(), dto.getNewPassword());
            redirectAttributes.addFlashAttribute("successMessage", "Password updated successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/profile";
    }
}
