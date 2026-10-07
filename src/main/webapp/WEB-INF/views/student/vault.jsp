<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Digital Vault — NIET SDMS" scope="request"/>
<c:set var="activePage" value="vault" scope="request"/>
<c:set var="pageHeader" value="Student Digital Document Vault" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h4 class="fw-extrabold mb-1 d-flex align-items-center gap-2 text-dark">
                <i class="bi bi-safe2-fill" style="color: var(--niet-red);"></i>
                My Digital Document Locker
            </h4>
            <p class="text-muted small mb-0">NIET Autonomous Institutional Repository with SHA-256 Tamper-Proof Cryptographic Verification</p>
        </div>
        <div class="d-flex gap-2">
            <a href="<c:url value='/student/achievements'/>" class="btn btn-glass-action">
                <i class="bi bi-award-fill text-warning"></i> Achievements Folder
            </a>
            <a href="<c:url value='/student/upload'/>" class="btn btn-niet">
                <i class="bi bi-cloud-arrow-up-fill"></i> Upload Document
            </a>
        </div>
    </div>

    <!-- Category Folder Filter Bar -->
    <div class="smart-card p-3 mb-4 bg-white">
        <div class="d-flex flex-wrap gap-2 align-items-center">
            <span class="small fw-bold text-muted me-2"><i class="bi bi-folder2-open me-1" style="color: var(--niet-red);"></i>Document Folders:</span>
            <button class="btn btn-sm btn-niet vault-filter-pill" onclick="filterVault('ALL', this)">
                <i class="bi bi-grid-fill me-1"></i> All Documents (<c:out value="${documents.size()}"/>)
            </button>
            <c:forEach items="${categories}" var="cat">
                <button class="btn btn-sm btn-glass-action vault-filter-pill" onclick="filterVault('${cat.id}', this)">
                    <i class="bi ${cat.iconClass} me-1"></i> <c:out value="${cat.categoryName}"/>
                </button>
            </c:forEach>
        </div>
    </div>

    <!-- Documents Grid -->
    <div class="row g-4" id="vaultGrid">
        <c:forEach items="${documents}" var="doc">
            <div class="col-md-6 col-lg-4 vault-item" data-category="${doc.documentType.category.id}">
                <div class="smart-card h-100 p-4 bg-white d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge px-2.5 py-1 fw-bold" style="background: var(--niet-red-light); color: var(--niet-red); font-size: 0.72rem;">
                                <i class="bi ${doc.documentType.category.iconClass} me-1"></i>
                                <c:out value="${doc.documentType.category.categoryName}"/>
                            </span>
                            <span class="status-pill status-${doc.status}"><c:out value="${doc.status}"/></span>
                        </div>

                        <h5 class="fw-bold mb-1 mt-2 text-truncate" title="${doc.title}">
                            <a href="<c:url value='/student/document/${doc.id}'/>" class="text-dark text-decoration-none hover-red">
                                <c:out value="${doc.title}"/>
                            </a>
                        </h5>
                        <div class="text-muted small mb-3"><c:out value="${doc.documentType.typeName}"/></div>

                        <div class="p-3 rounded-3 mb-3" style="background: #F8FAFC; border: 1px solid #E2E8F0;">
                            <div class="d-flex justify-content-between small mb-1.5">
                                <span class="text-muted">Document ID:</span>
                                <span class="font-monospace fw-bold text-dark"><c:out value="${doc.documentCode}"/></span>
                            </div>
                            <div class="d-flex justify-content-between small mb-1.5">
                                <span class="text-muted">Version:</span>
                                <span class="badge bg-white border text-dark">v<c:out value="${doc.currentVersion}"/></span>
                            </div>
                            <div class="d-flex justify-content-between small">
                                <span class="text-muted">SHA-256 Hash:</span>
                                <span class="font-monospace text-dark text-truncate" style="max-width: 120px;" title="${doc.sha256Hash}">
                                    <c:out value="${doc.sha256Hash.substring(0, 10)}..."/>
                                </span>
                            </div>
                        </div>

                        <c:if test="${not empty doc.rejectionRemarks}">
                            <div class="alert alert-danger p-2.5 rounded-3 small mb-3">
                                <strong>Faculty Feedback:</strong> <c:out value="${doc.rejectionRemarks}"/>
                            </div>
                        </c:if>
                    </div>

                    <div class="d-flex gap-2 pt-3 border-top mt-auto">
                        <a href="<c:url value='/documents/view/${doc.id}'/>" target="_blank" class="btn btn-glass-action btn-sm flex-fill justify-content-center">
                            <i class="bi bi-eye"></i> View
                        </a>
                        <a href="<c:url value='/documents/download/${doc.id}'/>" class="btn btn-glass-action btn-sm flex-fill justify-content-center">
                            <i class="bi bi-download"></i> Download
                        </a>
                        <c:if test="${doc.status == 'VERIFIED' || doc.status == 'ACTIVE'}">
                            <a href="<c:url value='/student/shares'/>" class="btn btn-sm btn-niet-outline" title="Generate Secure Verification Link">
                                <i class="bi bi-share-fill"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty documents}">
            <div class="col-12">
                <div class="smart-card p-5 text-center bg-white">
                    <i class="bi bi-folder2-open fs-1 mb-3 d-block" style="color: var(--niet-red);"></i>
                    <h5 class="fw-bold">Your NIET Document Vault is Empty</h5>
                    <p class="text-muted small mb-4">Start uploading your academic certificates, marksheets, and government IDs for institutional verification.</p>
                    <div>
                        <a href="<c:url value='/student/upload'/>" class="btn btn-niet"><i class="bi bi-cloud-arrow-up-fill me-1"></i> Upload First Document</a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
function filterVault(categoryId, btn) {
    document.querySelectorAll('.vault-filter-pill').forEach(b => {
        b.className = 'btn btn-sm btn-glass-action vault-filter-pill';
    });
    btn.className = 'btn btn-sm btn-niet vault-filter-pill';

    const items = document.querySelectorAll('.vault-item');
    items.forEach(item => {
        const itemCat = item.getAttribute('data-category');
        if (categoryId === 'ALL' || itemCat === categoryId) {
            item.style.display = '';
        } else {
            item.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp"/>
