<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Document Details - NIET SDMS" scope="request"/>
<c:set var="activePage" value="vault" scope="request"/>
<c:set var="pageHeader" value="Document Details & Version History" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><c:out value="${doc.title}"/></h4>
            <p class="text-muted small mb-0">Code: <span class="font-monospace fw-bold text-dark"><c:out value="${doc.documentCode}"/></span></p>
        </div>
        <div class="d-flex gap-2">
            <a href="<c:url value='/documents/view/${doc.id}'/>" target="_blank" class="btn btn-outline-primary"><i class="bi bi-eye"></i> View Inline</a>
            <a href="<c:url value='/documents/download/${doc.id}'/>" class="btn btn-outline-secondary"><i class="bi bi-download"></i> Download</a>
            <a href="<c:url value='/student/vault'/>" class="btn btn-secondary">Back to Vault</a>
        </div>
    </div>

    <div class="row g-4">
        <!-- Metadata Overview Card -->
        <div class="col-lg-6">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2">Document Metadata</h5>
                <dl class="row mb-0 small">
                    <dt class="col-sm-4 text-muted">Category:</dt>
                    <dd class="col-sm-8 fw-semibold"><c:out value="${doc.categoryName}"/></dd>

                    <dt class="col-sm-4 text-muted">Type:</dt>
                    <dd class="col-sm-8"><c:out value="${doc.documentTypeName}"/></dd>

                    <dt class="col-sm-4 text-muted">Status:</dt>
                    <dd class="col-sm-8"><span class="status-badge status-${doc.status}"><c:out value="${doc.status}"/></span></dd>

                    <dt class="col-sm-4 text-muted">Current Version:</dt>
                    <dd class="col-sm-8"><span class="badge bg-light text-dark border">Version <c:out value="${doc.currentVersion}"/></span></dd>

                    <dt class="col-sm-4 text-muted">File Size:</dt>
                    <dd class="col-sm-8"><c:out value="${doc.formattedFileSize}"/></dd>

                    <dt class="col-sm-4 text-muted">MIME Type:</dt>
                    <dd class="col-sm-8"><c:out value="${doc.mimeType}"/></dd>

                    <dt class="col-sm-4 text-muted">SHA-256 Fingerprint:</dt>
                    <dd class="col-sm-8 font-monospace text-break"><c:out value="${doc.sha256Hash}"/></dd>

                    <dt class="col-sm-4 text-muted">Verification Token:</dt>
                    <dd class="col-sm-8 font-monospace fw-bold text-primary"><c:out value="${doc.verificationToken}"/></dd>

                    <dt class="col-sm-4 text-muted">Verified At:</dt>
                    <dd class="col-sm-8"><c:out value="${doc.verifiedAt != null ? doc.verifiedAt : 'Pending Verification'}"/></dd>

                    <c:if test="${not empty doc.rejectionRemarks}">
                        <dt class="col-sm-4 text-danger">Rejection Remarks:</dt>
                        <dd class="col-sm-8 text-danger"><c:out value="${doc.rejectionRemarks}"/></dd>
                    </c:if>
                </dl>
            </div>
        </div>

        <!-- Upload New Version Form -->
        <div class="col-lg-6">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-arrow-repeat text-primary me-1"></i> Upload Replacement / New Version</h5>
                <p class="text-muted small">Replacing a document automatically preserves previous iterations in the immutable audit history.</p>

                <form action="<c:url value='/student/document/${doc.id}/version'/>" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Change Summary / Notes</label>
                        <input type="text" name="changeSummary" class="form-control form-control-sm" placeholder="e.g. Updated with re-evaluated semester marks" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Select New File (PDF, JPG, PNG)</label>
                        <input type="file" name="file" class="form-control form-control-sm" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm w-100 py-2 fw-semibold">
                        <i class="bi bi-cloud-arrow-up me-1"></i> Upload Version ${doc.currentVersion + 1}
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

