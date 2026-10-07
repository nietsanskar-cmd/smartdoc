<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>500 - Internal Server Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">
    <div class="text-center p-5 bg-white rounded shadow-sm" style="max-width: 500px;">
        <h1 class="display-1 fw-bold text-warning">500</h1>
        <h4 class="fw-bold mb-3">Server Error</h4>
        <p class="text-muted small mb-4"><c:out value="${errorMessage != null ? errorMessage : 'An unexpected internal error occurred.'}"/></p>
        <a href="<c:url value='/'/>" class="btn btn-primary btn-sm">Return to Safe Dashboard</a>
    </div>
</body>
</html>
