<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error - NIET SDMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">
    <div class="text-center p-5 bg-white rounded shadow-sm" style="max-width: 500px;">
        <h3 class="fw-bold text-danger mb-3"><c:out value="${errorTitle != null ? errorTitle : 'An Error Occurred'}"/></h3>
        <p class="text-muted small mb-4"><c:out value="${errorMessage != null ? errorMessage : 'Please try again or contact system administrator.'}"/></p>
        <a href="<c:url value='/'/>" class="btn btn-primary btn-sm">Return to Safe Dashboard</a>
    </div>
</body>
</html>

