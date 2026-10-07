<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Review Document - NIET SDMS" scope="request"/>
<c:set var="activePage" value="queue" scope="request"/>
<c:set var="pageHeader" value="Review & Verify Document" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h4 class="fw-bold mb-1">Reviewing: <c:out value="${doc.title}"/></h4>
            <p class="text-muted small mb-0">Student: <strong><c:out value="${doc.studentName}"/></strong> (<c:out value="${doc.enrollmentNo}"/>)</p>
        </div>
        <a href="<c:url value='/faculty/queue'/>" class="btn btn-outline-secondary btn-sm">Back to Queue</a>
    </div>

    <div class="row g-4">
        <!-- Live Document Preview Frame -->
        <div class="col-lg-7">
            <div class="card smart-card p-3 bg-white">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="fw-bold small text-muted">Document Preview</span>
                    <a href="<c:url value='/documents/download/${doc.id}'/>" class="btn btn-outline-secondary btn-sm"><i class="bi bi-download"></i> Download Original</a>
                </div>
                <div class="doc-preview-container">
                    <iframe src="<c:url value='/documents/view/${doc.id}'/>" class="doc-preview-frame"></iframe>
                </div>
            </div>
        </div>

        <!-- Verification Action Decision Card -->
        <div class="col-lg-5">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2">Verification Decision</h5>

                <dl class="row small mb-3">
                    <dt class="col-4 text-muted">Category:</dt>
                    <dd class="col-8 fw-semibold"><c:out value="${doc.categoryName}"/></dd>

                    <dt class="col-4 text-muted">Type:</dt>
                    <dd class="col-8"><c:out value="${doc.documentTypeName}"/></dd>

                    <dt class="col-4 text-muted">Version:</dt>
                    <dd class="col-8">v<c:out value="${doc.currentVersion}"/></dd>

                    <dt class="col-4 text-muted">SHA-256:</dt>
                    <dd class="col-8 font-monospace text-truncate" title="${doc.sha256Hash}"><c:out value="${doc.sha256Hash.substring(0, 16)}..."/></dd>
                </dl>

                <form action="<c:url value='/faculty/verify/${doc.id}'/>" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Action *</label>
                        <select name="action" class="form-select" id="actionSelect" required>
                            <option value="APPROVED">APPROVE (Issue QR Verification Token)</option>
                            <option value="REJECTED">REJECT (Mandatory Remarks Required)</option>
                            <option value="REUPLOAD_REQUESTED">REQUEST RE-UPLOAD</option>
                        </select>
                    </div>

                    <div class="mb-3" id="reasonGroup">
                        <label class="form-label small fw-semibold">Reason Code (If Rejecting)</label>
                        <select name="reasonCode" class="form-select form-select-sm">
                            <option value="BLURRY_UNREADABLE">Blurry or Unreadable Scan</option>
                            <option value="NAME_MISMATCH">Student Name / DOB Mismatch</option>
                            <option value="INCORRECT_DOCUMENT">Wrong Document Type Uploaded</option>
                            <option value="MISSING_PAGES">Missing Pages / Incomplete Document</option>
                            <option value="EXPIRED_DOCUMENT">Document Expired</option>
                            <option value="OTHER">Other Discrepancy</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-semibold">Reviewer Remarks *</label>
                        <textarea name="remarks" rows="4" class="form-control form-control-sm" placeholder="Provide verification or rejection notes visible to the student." required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                        <i class="bi bi-check2-circle me-1"></i> Submit Verification Decision
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

