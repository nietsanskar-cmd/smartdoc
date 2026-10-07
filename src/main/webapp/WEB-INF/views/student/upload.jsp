<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Upload Document — NIET SDMS" scope="request"/>
<c:set var="activePage" value="upload" scope="request"/>
<c:set var="pageHeader" value="Upload Document" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="smart-card p-4 sm:p-5 bg-white shadow-sm">
                <div class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3 mb-4 pb-3 border-bottom">
                    <div>
                        <h4 class="fw-extrabold mb-1 text-dark d-flex align-items-center gap-2">
                            <i class="bi bi-cloud-arrow-up-fill" style="color: var(--niet-red);"></i>
                            Upload Academic Document
                        </h4>
                        <p class="text-muted small mb-0">Files are cryptographically verified, fingerprinted with SHA-256, and sent to faculty for review.</p>
                    </div>
                    <a href="<c:url value='/student/vault'/>" class="btn btn-glass-action btn-sm">
                        <i class="bi bi-arrow-left"></i> Back to Vault
                    </a>
                </div>

                <form action="<c:url value='/student/upload'/>" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">Document Title / Name *</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g. 10th Standard Passing Marksheet" required autofocus>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Document Category & Type *</label>
                        <select name="documentTypeId" class="form-select" required>
                            <option value="">-- Choose Document Type --</option>
                            <c:forEach items="${documentTypes}" var="dt">
                                <option value="${dt.id}">[<c:out value="${dt.category.categoryName}"/>] &bull; <c:out value="${dt.typeName}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Issue Date</label>
                            <input type="date" name="issueDate" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Expiry Date (Optional)</label>
                            <input type="date" name="expiryDate" class="form-control">
                        </div>
                    </div>

                    <!-- Drag & Drop Glass Upload Area -->
                    <div class="mb-4">
                        <label class="form-label">Select Document File * (PDF, JPG, PNG &lt; 15MB)</label>
                        <div class="upload-dropzone" onclick="document.getElementById('fileInput').click()">
                            <div class="upload-icon-circle">
                                <i class="bi bi-cloud-arrow-up"></i>
                            </div>
                            <h6 class="fw-bold text-dark mb-1" id="fileNameDisplay">Drag & Drop your document here or click to browse</h6>
                            <p class="text-muted small mb-0">Supported formats: PDF, JPG, JPEG, PNG (Max 15 MB)</p>
                            <input type="file" id="fileInput" name="file" class="d-none" accept=".pdf,.jpg,.jpeg,.png" required onchange="handleFileSelected(this)">
                        </div>
                        <div class="form-text small text-muted mt-2 d-flex align-items-center gap-1">
                            <i class="bi bi-shield-lock-fill text-success"></i>
                            <span>An automated SHA-256 digital fingerprint is computed immediately on upload.</span>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-niet w-100 py-3 fw-bold fs-6">
                        <i class="bi bi-cloud-check-fill me-1"></i> Upload to NIET SDMS Vault
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function handleFileSelected(input) {
    if (input.files && input.files[0]) {
        const file = input.files[0];
        document.getElementById('fileNameDisplay').innerHTML = '<span class="text-success"><i class="bi bi-check2-circle me-1"></i> Selected: ' + file.name + ' (' + (file.size / 1024 / 1024).toFixed(2) + ' MB)</span>';
    }
}
</script>

<jsp:include page="../common/footer.jsp"/>
