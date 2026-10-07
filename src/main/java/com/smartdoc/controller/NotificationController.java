package com.smartdoc.controller;

import com.smartdoc.security.UserSession;
import com.smartdoc.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping
    public String listNotifications(HttpSession session, Model model) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        model.addAttribute("notifications", notificationService.getUserNotifications(userSession.getUserId()));
        return "student/notifications";
    }

    @PostMapping("/{id}/read")
    public String markRead(@PathVariable("id") Long id, @RequestParam(value = "redirect", required = false) String redirect) {
        notificationService.markAsRead(id);
        if (redirect != null && !redirect.isEmpty()) {
            return "redirect:" + redirect;
        }
        return "redirect:/notifications";
    }

    @PostMapping("/read-all")
    public String markAllRead(HttpSession session, RedirectAttributes redirectAttributes) {
        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        notificationService.markAllAsRead(userSession.getUserId());
        redirectAttributes.addFlashAttribute("successMessage", "All notifications marked as read.");
        return "redirect:/notifications";
    }
}
