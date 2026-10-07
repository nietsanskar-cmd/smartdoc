<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Verification — NIET SDMS</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<c:url value='/static/img/niet-logo.png'/>">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<c:url value='/static/css/custom.css'/>">
</head>
<body style="background: radial-gradient(circle at 10% 20%, rgba(215, 25, 32, 0.05) 0%, #FAFAFC 45%, #F0F4F8 100%); min-height: 100vh; padding: 3rem 1rem;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-7">
                <div class="smart-card p-4 p-md-5 bg-white shadow-xl">
                    <!-- Institutional Header & Seal -->
                    <div class="text-center mb-4 border-bottom pb-4">
                        <div class="mb-3">
                            <img src="<c:url value='/static/img/niet-logo.png'/>" alt="NIET Logo" style="height: 54px; width: auto;" />
                        </div>
                        <div class="d-inline-flex p-3 rounded-circle text-success mb-2" style="background: rgba(16, 185, 129, 0.12);">
                            <i class="bi bi-patch-check-fill fs-1"></i>
                        </div>
                        <h3 class="fw-extrabold text-success mb-1">Authentic Academic Document</h3>
                        <p class="text-muted small mb-0">Cryptographically verified & recorded in the official repository of <strong><c:out value="${verif.institutionName}"/></strong></p>
                    </div>

                    <div class="alert alert-success border-0 rounded-4 p-3 mb-4 d-flex align-items-center gap-2.5" style="background: rgba(220, 252, 231, 0.95); border-left: 5px solid #10B981 !important;">
                        <i class="bi bi-shield-check fs-3 text-success"></i>
                        <div>
                            <strong class="text-success-emphasis">Official Verification Status: VERIFIED & GENUINE</strong>
                            <div class="small text-success-emphasis">This certificate has been digitally attested by NIET faculty authorities.</div>
                        </div>
                    </div>

                    <h6 class="text-uppercase fw-bold small mb-3" style="color: var(--niet-red); letter-spacing: 0.5px;">Document Authenticity Metadata</h6>
                    <div class="p-3 rounded-3 mb-4" style="background: #F8FAFC; border: 1px solid #E2E8F0;">
                        <dl class="row small mb-0 g-2">
                            <dt class="col-sm-5 text-muted">Verification Token:</dt>
                            <dd class="col-sm-7 font-monospace fw-bold text-dark"><c:out value="${verif.verificationToken}"/></dd>

                            <dt class="col-sm-5 text-muted">Document Code:</dt>
                            <dd class="col-sm-7 font-monospace fw-bold" style="color: var(--niet-red);"><c:out value="${verif.documentCode}"/></dd>

                            <dt class="col-sm-5 text-muted">Document Type:</dt>
                            <dd class="col-sm-7 fw-semibold"><c:out value="${verif.categoryName}"/> &bull; <c:out value="${verif.documentTypeName}"/></dd>

                            <dt class="col-sm-5 text-muted">Issued To (Masked):</dt>
                            <dd class="col-sm-7 fw-bold text-dark"><c:out value="${verif.studentMaskedName}"/> (<c:out value="${verif.enrollmentNoMasked}"/>)</dd>

                            <dt class="col-sm-5 text-muted">Academic Department:</dt>
                            <dd class="col-sm-7"><c:out value="${verif.departmentName}"/></dd>

                            <dt class="col-sm-5 text-muted">Verification Timestamp:</dt>
                            <dd class="col-sm-7 text-dark fw-semibold"><c:out value="${verif.verifiedAt}"/></dd>

                            <dt class="col-sm-5 text-muted">SHA-256 Digital Hash:</dt>
                            <dd class="col-sm-7 font-monospace text-break small text-muted"><c:out value="${verif.sha256Fingerprint}"/></dd>
                        </dl>
                    </div>

                    <div class="text-center pt-3 border-top text-muted small">
                        <i class="bi bi-shield-lock text-success me-1"></i> NIET SDMS Cryptographic Verification System &bull; Issued for official validation.
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
