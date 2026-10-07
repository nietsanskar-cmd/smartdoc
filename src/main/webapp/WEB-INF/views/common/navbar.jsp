<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="smart-navbar">
    <div class="d-flex align-items-center gap-3">
        <!-- Mobile Sidebar Toggle -->
        <button class="btn btn-sm btn-light border d-lg-none" type="button" onclick="document.querySelector('.smart-sidebar').classList.toggle('show')">
            <i class="bi bi-list fs-5"></i>
        </button>
        
        <div>
            <div class="portal-title">
                <c:out value="${pageHeader != null ? pageHeader : 'Document Management Portal'}"/>
                <span class="institute-badge">NIET Autonomous</span>
            </div>
            <div class="text-muted d-none d-sm-block" style="font-size: 0.75rem;">
                Noida Institute of Engineering & Technology &bull; Greater Noida
            </div>
        </div>
    </div>

    <div class="d-flex align-items-center gap-3">
        <!-- Notification Button -->
        <a href="<c:url value='/notifications'/>" class="btn btn-light position-relative rounded-circle p-2 border" title="Notifications" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
            <i class="bi bi-bell text-secondary"></i>
            <c:if test="${unreadCount != null && unreadCount > 0}">
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill" style="background-color: var(--niet-red); font-size: 0.65rem;">
                    <c:out value="${unreadCount}"/>
                </span>
            </c:if>
        </a>

        <!-- User Profile Dropdown -->
        <div class="dropdown">
            <div class="user-profile-pill" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="user-avatar">
                    <c:out value="${sessionScope.CURRENT_USER.fullName != null ? sessionScope.CURRENT_USER.fullName.substring(0, 1).toUpperCase() : 'U'}"/>
                </div>
                <div class="text-start d-none d-md-block pe-1">
                    <div class="fw-bold text-dark small" style="line-height: 1.2;"><c:out value="${sessionScope.CURRENT_USER.fullName}"/></div>
                    <div class="text-muted text-uppercase fw-semibold" style="font-size: 0.68rem; letter-spacing: 0.5px;"><c:out value="${sessionScope.CURRENT_USER.role}"/></div>
                </div>
                <i class="bi bi-chevron-down text-muted small ms-1"></i>
            </div>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-4 p-2 mt-2" style="min-width: 220px; background: rgba(255,255,255,0.95); backdrop-filter: blur(16px);">
                <li class="px-3 py-2 border-bottom mb-1">
                    <div class="fw-bold small text-dark"><c:out value="${sessionScope.CURRENT_USER.fullName}"/></div>
                    <div class="text-muted" style="font-size: 0.75rem;"><c:out value="${sessionScope.CURRENT_USER.username}"/></div>
                </li>
                <li><a class="dropdown-item rounded-3 py-2 small fw-semibold" href="<c:url value='/profile'/>"><i class="bi bi-person me-2 text-secondary"></i> My Profile & Security</a></li>
                <c:if test="${sessionScope.CURRENT_USER.student}">
                    <li><a class="dropdown-item rounded-3 py-2 small fw-semibold" href="<c:url value='/student/vault'/>"><i class="bi bi-safe2 me-2 text-secondary"></i> My Digital Vault</a></li>
                </c:if>
                <li><hr class="dropdown-divider my-1"></li>
                <li><a class="dropdown-item rounded-3 py-2 small fw-bold text-danger" href="<c:url value='/logout'/>"><i class="bi bi-box-arrow-right me-2"></i> Log Out</a></li>
            </ul>
        </div>
    </div>
</nav>
