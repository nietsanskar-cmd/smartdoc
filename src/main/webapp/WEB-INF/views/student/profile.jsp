<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile - NIET SDMS" scope="request"/>
<c:set var="activePage" value="profile" scope="request"/>
<c:set var="pageHeader" value="Student Profile & Security Settings" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="row g-4">
        <!-- Profile Card -->
        <div class="col-lg-6">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-person-badge text-primary me-2"></i>Academic Profile</h5>
                <dl class="row mb-0 small">
                    <dt class="col-sm-4 text-muted">Full Name:</dt>
                    <dd class="col-sm-8 fw-semibold"><c:out value="${profile.fullName}"/></dd>

                    <dt class="col-sm-4 text-muted">Enrollment No:</dt>
                    <dd class="col-sm-8 font-monospace text-dark fw-bold"><c:out value="${profile.enrollmentNo}"/></dd>

                    <dt class="col-sm-4 text-muted">Roll No:</dt>
                    <dd class="col-sm-8"><c:out value="${profile.rollNo}"/></dd>

                    <dt class="col-sm-4 text-muted">Email:</dt>
                    <dd class="col-sm-8"><c:out value="${profile.email}"/></dd>

                    <dt class="col-sm-4 text-muted">Department:</dt>
                    <dd class="col-sm-8"><c:out value="${profile.departmentName}"/></dd>

                    <dt class="col-sm-4 text-muted">Course:</dt>
                    <dd class="col-sm-8"><c:out value="${profile.courseName}"/></dd>

                    <dt class="col-sm-4 text-muted">Current Semester:</dt>
                    <dd class="col-sm-8">Semester <c:out value="${profile.semesterNumber}"/></dd>

                    <dt class="col-sm-4 text-muted">Academic Year:</dt>
                    <dd class="col-sm-8"><c:out value="${profile.academicYear}"/></dd>

                    <dt class="col-sm-4 text-muted">Faculty Advisor:</dt>
                    <dd class="col-sm-8 text-primary fw-semibold"><c:out value="${profile.facultyAdvisorName}"/></dd>
                </dl>
            </div>
        </div>

        <!-- Change Password Card -->
        <div class="col-lg-6">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-key text-primary me-2"></i>Change Account Password</h5>
                
                <form action="<c:url value='/profile/change-password'/>" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Current Password *</label>
                        <input type="password" name="currentPassword" class="form-control form-control-sm" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">New Password *</label>
                        <input type="password" name="newPassword" class="form-control form-control-sm" minlength="6" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm w-100 py-2 fw-semibold">
                        <i class="bi bi-lock-fill me-1"></i> Update Password
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

