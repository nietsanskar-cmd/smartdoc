<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="smart-sidebar">
    <!-- NIET Official Logo Branding -->
    <a href="<c:url value='/'/>" class="sidebar-brand">
        <img src="<c:url value='/static/img/niet-logo.png'/>" alt="NIET Greater Noida Logo" />
        <div class="brand-text">
            <div class="brand-title">NIET <span>SDMS</span></div>
            <div class="brand-subtitle">Autonomous Institute</div>
        </div>
    </a>

    <!-- Role Indicator Pill -->
    <div class="role-indicator-badge">
        <c:choose>
            <c:when test="${sessionScope.CURRENT_USER.admin}">
                <span><i class="bi bi-shield-lock-fill me-1"></i> Admin Console</span>
            </c:when>
            <c:when test="${sessionScope.CURRENT_USER.faculty}">
                <span><i class="bi bi-mortarboard-fill me-1"></i> Faculty Reviewer</span>
            </c:when>
            <c:otherwise>
                <span><i class="bi bi-person-fill me-1"></i> Student Locker</span>
            </c:otherwise>
        </c:choose>
        <span class="badge bg-white text-dark border px-2 py-0.5" style="font-size: 0.65rem;">v2.0</span>
    </div>

    <!-- Navigation Links -->
    <div class="sidebar-nav">
        <nav class="nav flex-column">
            <c:choose>
                <%-- ADMIN MENU --%>
                <c:when test="${sessionScope.CURRENT_USER.admin}">
                    <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="<c:url value='/admin/dashboard'/>">
                        <i class="bi bi-grid-1x2-fill"></i> Overview Dashboard
                    </a>
                    <a class="nav-link ${activePage == 'students' ? 'active' : ''}" href="<c:url value='/admin/students'/>">
                        <i class="bi bi-people-fill"></i> Student Directory
                    </a>
                    <a class="nav-link ${activePage == 'faculty' ? 'active' : ''}" href="<c:url value='/admin/faculty'/>">
                        <i class="bi bi-person-badge-fill"></i> Faculty Members
                    </a>
                    <a class="nav-link ${activePage == 'departments' ? 'active' : ''}" href="<c:url value='/admin/departments'/>">
                        <i class="bi bi-building-fill"></i> Departments
                    </a>
                    <a class="nav-link ${activePage == 'courses' ? 'active' : ''}" href="<c:url value='/admin/courses'/>">
                        <i class="bi bi-journal-bookmark-fill"></i> Degree Courses
                    </a>
                    <a class="nav-link ${activePage == 'documentTypes' ? 'active' : ''}" href="<c:url value='/admin/document-types'/>">
                        <i class="bi bi-folder-check"></i> Document Catalog
                    </a>
                    <a class="nav-link ${activePage == 'requiredDocs' ? 'active' : ''}" href="<c:url value='/admin/required-documents'/>">
                        <i class="bi bi-card-checklist"></i> Requirement Rules
                    </a>
                    <a class="nav-link ${activePage == 'allDocs' ? 'active' : ''}" href="<c:url value='/admin/documents'/>">
                        <i class="bi bi-files"></i> Master Document Vault
                    </a>
                    <a class="nav-link ${activePage == 'requests' ? 'active' : ''}" href="<c:url value='/admin/requests'/>">
                        <i class="bi bi-inbox-fill"></i> Document Requests
                    </a>
                    <a class="nav-link ${activePage == 'auditLogs' ? 'active' : ''}" href="<c:url value='/admin/audit-logs'/>">
                        <i class="bi bi-journal-text"></i> System Audit Logs
                    </a>
                    <a class="nav-link ${activePage == 'downloadLogs' ? 'active' : ''}" href="<c:url value='/admin/download-logs'/>">
                        <i class="bi bi-download"></i> Access & Download Logs
                    </a>
                    <a class="nav-link ${activePage == 'settings' ? 'active' : ''}" href="<c:url value='/admin/system-settings'/>">
                        <i class="bi bi-gear-fill"></i> Portal Settings
                    </a>
                </c:when>

                <%-- FACULTY MENU --%>
                <c:when test="${sessionScope.CURRENT_USER.faculty}">
                    <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="<c:url value='/faculty/dashboard'/>">
                        <i class="bi bi-grid-1x2-fill"></i> Faculty Overview
                    </a>
                    <a class="nav-link ${activePage == 'queue' ? 'active' : ''}" href="<c:url value='/faculty/queue'/>">
                        <i class="bi bi-patch-check-fill"></i> Verification Queue
                    </a>
                    <a class="nav-link ${activePage == 'students' ? 'active' : ''}" href="<c:url value='/faculty/students'/>">
                        <i class="bi bi-people-fill"></i> Assigned Students
                    </a>
                    <a class="nav-link ${activePage == 'deptStats' ? 'active' : ''}" href="<c:url value='/faculty/department-stats'/>">
                        <i class="bi bi-graph-up-arrow"></i> Department Analytics
                    </a>
                    <a class="nav-link ${activePage == 'profile' ? 'active' : ''}" href="<c:url value='/profile'/>">
                        <i class="bi bi-person-fill"></i> Faculty Profile
                    </a>
                </c:when>

                <%-- STUDENT MENU --%>
                <c:otherwise>
                    <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="<c:url value='/student/dashboard'/>">
                        <i class="bi bi-grid-1x2-fill"></i> My Dashboard
                    </a>
                    <a class="nav-link ${activePage == 'vault' ? 'active' : ''}" href="<c:url value='/student/vault'/>">
                        <i class="bi bi-safe2-fill"></i> Digital Vault
                    </a>
                    <a class="nav-link ${activePage == 'achievements' ? 'active' : ''}" href="<c:url value='/student/achievements'/>">
                        <i class="bi bi-award-fill"></i> Achievements & Certs
                    </a>
                    <a class="nav-link ${activePage == 'upload' ? 'active' : ''}" href="<c:url value='/student/upload'/>">
                        <i class="bi bi-cloud-arrow-up-fill"></i> Upload Document
                    </a>
                    <a class="nav-link ${activePage == 'shares' ? 'active' : ''}" href="<c:url value='/student/shares'/>">
                        <i class="bi bi-share-fill"></i> Secure Link Sharing
                    </a>
                    <a class="nav-link ${activePage == 'requests' ? 'active' : ''}" href="<c:url value='/student/requests'/>">
                        <i class="bi bi-file-earmark-text-fill"></i> Certificate Requests
                    </a>
                    <a class="nav-link ${activePage == 'profile' ? 'active' : ''}" href="<c:url value='/student/profile'/>">
                        <i class="bi bi-person-circle"></i> Student Profile
                    </a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>

    <!-- Sidebar Bottom Action -->
    <div class="sidebar-footer">
        <a href="<c:url value='/profile'/>" class="text-decoration-none d-flex align-items-center gap-2 text-dark small fw-bold">
            <i class="bi bi-person-badge text-danger fs-5"></i>
            <span>Account</span>
        </a>
        <a href="<c:url value='/logout'/>" class="btn btn-sm btn-outline-danger border-0" title="Log Out">
            <i class="bi bi-box-arrow-right fs-6"></i>
        </a>
    </div>
</div>
