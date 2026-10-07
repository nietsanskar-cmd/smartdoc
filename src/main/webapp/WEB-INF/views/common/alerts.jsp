<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success border-0 shadow-sm rounded-4 p-3 mb-4 d-flex align-items-center justify-content-between" role="alert" style="background: rgba(220, 252, 231, 0.95); backdrop-filter: blur(12px); border-left: 5px solid #10B981 !important;">
        <div class="d-flex align-items-center gap-2.5 text-success-emphasis font-semibold">
            <i class="bi bi-check-circle-fill text-success fs-5"></i>
            <div><c:out value="${successMessage}"/></div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger border-0 shadow-sm rounded-4 p-3 mb-4 d-flex align-items-center justify-content-between" role="alert" style="background: rgba(254, 226, 226, 0.95); backdrop-filter: blur(12px); border-left: 5px solid var(--niet-red) !important;">
        <div class="d-flex align-items-center gap-2.5 text-danger-emphasis font-semibold">
            <i class="bi bi-exclamation-triangle-fill fs-5" style="color: var(--niet-red);"></i>
            <div><c:out value="${errorMessage}"/></div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty infoMessage}">
    <div class="alert alert-info border-0 shadow-sm rounded-4 p-3 mb-4 d-flex align-items-center justify-content-between" role="alert" style="background: rgba(224, 242, 254, 0.95); backdrop-filter: blur(12px); border-left: 5px solid #0284C7 !important;">
        <div class="d-flex align-items-center gap-2.5 text-info-emphasis font-semibold">
            <i class="bi bi-info-circle-fill text-info fs-5"></i>
            <div><c:out value="${infoMessage}"/></div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
