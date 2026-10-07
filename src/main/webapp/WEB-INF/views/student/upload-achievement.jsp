<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Upload Achievement — NIET SDMS" scope="request"/>
<c:set var="activePage" value="achievements" scope="request"/>
<c:set var="pageHeader" value="Upload Achievement & Certification" scope="request"/>
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
                            <i class="bi bi-award-fill" style="color: var(--niet-red);"></i>
                            Upload Student Achievement
                        </h4>
                        <p class="text-muted small mb-0">Submit verified industry internship completion letters, published papers, hackathon prizes, and certifications.</p>
                    </div>
                    <a href="<c:url value='/student/achievements'/>" class="btn btn-glass-action btn-sm">
                        <i class="bi bi-arrow-left"></i> Back to Portfolio
                    </a>
                </div>

                <form action="<c:url value='/student/achievements/upload'/>" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">Achievement Title *</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g. Summer Internship Completion Certificate — Amazon AWS / IEEE Conference Paper" required autofocus>
                        <div class="form-text small text-muted">Include the company name, issuing authority, or publication title.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Achievement Category & Type *</label>
                        <select name="documentTypeId" class="form-select" required>
                            <option value="">-- Select Achievement Classification --</option>
                            <c:forEach items="${achievementTypes}" var="at">
                                <option value="${at.id}"><c:out value="${at.typeName}"/> &bull; (<c:out value="${at.description}"/>)</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Date of Issue / Award Date *</label>
                            <input type="date" name="issueDate" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Expiry Date (Optional)</label>
                            <input type="date" name="expiryDate" class="form-control">
                        </div>
                    </div>

                    <!-- Upload Area -->
                    <div class="mb-4">
                        <label class="form-label">Upload Proof / Certificate File * (PDF, JPG, PNG &lt; 15MB)</label>
                        <div class="upload-dropzone" onclick="document.getElementById('achieveFileInput').click()">
                            <div class="upload-icon-circle">
                                <i class="bi bi-award"></i>
                            </div>
                            <h6 class="fw-bold text-dark mb-1" id="achieveFileNameDisplay">Drag & Drop certificate here or click to browse</h6>
                            <p class="text-muted small mb-0">Supported formats: PDF, JPG, JPEG, PNG (Max 15 MB)</p>
                            <input type="file" id="achieveFileInput" name="file" class="d-none" accept=".pdf,.jpg,.jpeg,.png" required onchange="handleAchieveFile(this)">
                        </div>
                        <div class="form-text small text-muted mt-2 d-flex align-items-center gap-1">
                            <i class="bi bi-shield-check text-success"></i>
                            <span>All achievements are permanently anchored with a verifiable QR code for employer verification.</span>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="<c:url value='/student/achievements'/>" class="btn btn-glass-action flex-fill py-2.5 justify-content-center">Cancel</a>
                        <button type="submit" class="btn btn-niet flex-fill py-2.5 fw-bold justify-content-center">
                            <i class="bi bi-cloud-arrow-up-fill me-1"></i> Submit Achievement to Portfolio
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function handleAchieveFile(input) {
    if (input.files && input.files[0]) {
        const file = input.files[0];
        document.getElementById('achieveFileNameDisplay').innerHTML = '<span class="text-success"><i class="bi bi-check2-circle me-1"></i> Selected: ' + file.name + ' (' + (file.size / 1024 / 1024).toFixed(2) + ' MB)</span>';
    }
}
</script>

<jsp:include page="../common/footer.jsp"/>
