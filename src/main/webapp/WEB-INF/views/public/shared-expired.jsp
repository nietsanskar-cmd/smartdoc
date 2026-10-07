<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Link Expired - NIET SDMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<c:url value='/static/css/custom.css'/>">
</head>
<body class="bg-light py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card smart-card border-0 p-5 text-center bg-white shadow-sm">
                    <div class="d-inline-flex p-3 rounded-circle bg-warning bg-opacity-10 text-warning mb-3 mx-auto">
                        <i class="bi bi-hourglass-bottom fs-1"></i>
                    </div>
                    <h3 class="fw-bold mb-2">Secure Link Expired or Inactive</h3>
                    <p class="text-muted small mb-4"><c:out value="${errorMessage != null ? errorMessage : 'This secure link has expired, exceeded maximum access count, or has been revoked by the student.'}"/></p>
                    <a href="<c:url value='/login'/>" class="btn btn-outline-secondary btn-sm">Go to Homepage</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

