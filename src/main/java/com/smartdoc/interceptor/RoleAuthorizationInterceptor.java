package com.smartdoc.interceptor;

import com.smartdoc.entity.enums.RoleType;
import com.smartdoc.security.UserSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class RoleAuthorizationInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();

        HttpSession session = request.getSession(false);
        if (session == null) return true;

        UserSession userSession = (UserSession) session.getAttribute("CURRENT_USER");
        if (userSession == null) return true;

        RoleType role = userSession.getRole();

        // Admin paths
        if (uri.startsWith("/admin") || uri.startsWith("/api/admin")) {
            if (!RoleType.ROLE_ADMIN.equals(role)) {
                response.sendRedirect(request.getContextPath() + "/errors/403");
                return false;
            }
        }

        // Faculty paths
        if (uri.startsWith("/faculty") || uri.startsWith("/api/faculty")) {
            if (!RoleType.ROLE_FACULTY.equals(role) && !RoleType.ROLE_ADMIN.equals(role)) {
                response.sendRedirect(request.getContextPath() + "/errors/403");
                return false;
            }
        }

        // Student paths
        if (uri.startsWith("/student") || uri.startsWith("/api/student")) {
            if (!RoleType.ROLE_STUDENT.equals(role) && !RoleType.ROLE_ADMIN.equals(role)) {
                response.sendRedirect(request.getContextPath() + "/errors/403");
                return false;
            }
        }

        return true;
    }
}
