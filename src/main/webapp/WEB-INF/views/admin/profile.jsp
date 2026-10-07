<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Profile - NIET SDMS" scope="request"/>
<c:set var="pageHeader" value="Administrator Profile & Security" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2">Administrator Account</h5>
                <dl class="row small mb-0">
                    <dt class="col-sm-4 text-muted">Username:</dt>
                    <dd class="col-sm-8 fw-semibold"><c:out value="${user.username}"/></dd>
                    <dt class="col-sm-4 text-muted">Email:</dt>
                    <dd class="col-sm-8"><c:out value="${user.email}"/></dd>
                    <dt class="col-sm-4 text-muted">Role:</dt>
                    <dd class="col-sm-8"><span class="badge bg-primary">ROLE_ADMIN</span></dd>
                </dl>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2">Update Password</h5>
                <form action="<c:url value='/profile/change-password'/>" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Current Password *</label>
                        <input type="password" name="currentPassword" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">New Password *</label>
                        <input type="password" name="newPassword" class="form-control form-control-sm" minlength="6" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-sm w-100 py-2 fw-semibold">Update Password</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

