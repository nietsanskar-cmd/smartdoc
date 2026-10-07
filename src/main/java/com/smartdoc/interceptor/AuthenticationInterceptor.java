package com.smartdoc.interceptor;

import com.smartdoc.security.UserSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthenticationInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();

        // Public paths that bypass session checks
        if (uri.startsWith("/login") || uri.startsWith("/register") || uri.startsWith("/verify/document/") ||
            uri.startsWith("/shared/") || uri.startsWith("/static/") || uri.startsWith("/api/auth/") ||
            uri.startsWith("/api/verify/") || uri.equals("/") || uri.startsWith("/errors/")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("CURRENT_USER") == null) {
            if (uri.startsWith("/api/")) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Session expired or unauthenticated\"}");
                return false;
            }
            response.sendRedirect(request.getContextPath() + "/login?sessionExpired=true");
            return false;
        }

        return true;
    }
}
