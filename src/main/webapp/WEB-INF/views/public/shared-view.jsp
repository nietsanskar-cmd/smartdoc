<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Shared Document - NIET SDMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<c:url value='/static/css/custom.css'/>">
</head>
<body class="bg-light py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card smart-card border-0 p-4 p-md-5 bg-white shadow-sm text-center">
                    <div class="d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary mb-3 mx-auto">
                        <i class="bi bi-file-earmark-lock-fill fs-1"></i>
                    </div>
                    <h4 class="fw-bold mb-1"><c:out value="${share.document.title}"/></h4>
                    <p class="text-muted small mb-3">Secure ephemeral access granted by student</p>

                    <div class="bg-light p-3 rounded text-start small mb-4">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted">Document Code:</span>
                            <span class="font-monospace fw-semibold"><c:out value="${share.document.documentCode}"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted">Expires At:</span>
                            <span class="fw-semibold text-danger"><c:out value="${share.expiresAt}"/></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted">Views Remaining:</span>
                            <span class="fw-semibold"><c:out value="${share.maxAccessCount - share.currentAccessCount}"/> views</span>
                        </div>
                    </div>

                    <form action="<c:url value='/shared/${share.shareToken}/access'/>" method="post" target="_blank">
                        <c:if test="${requiresPasscode}">
                            <div class="mb-3 text-start">
                                <label class="form-label small fw-semibold">Enter Document Passcode *</label>
                                <input type="password" name="passcode" class="form-control" placeholder="Provided by the student" required>
                            </div>
                        </c:if>
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-box-arrow-up-right me-1"></i> Open Document Stream
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

