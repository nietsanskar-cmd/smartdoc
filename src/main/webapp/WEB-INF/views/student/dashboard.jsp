<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Dashboard — NIET SDMS" scope="request"/>
<c:set var="activePage" value="dashboard" scope="request"/>
<c:set var="pageHeader" value="Student Overview" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <!-- Welcome & Academic Identity Banner -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="smart-card p-4 h-100 bg-white">
                <div class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3 mb-4 pb-3 border-bottom">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="badge" style="background: var(--niet-red-light); color: var(--niet-red); font-size: 0.72rem; font-weight: 700;">NIET STUDENT</span>
                            <span class="text-muted small">&bull; Semester <c:out value="${student.currentSemester.semesterNumber}"/></span>
                        </div>
                        <h3 class="fw-extrabold mb-1" style="font-size: 1.6rem; color: var(--niet-black);">
                            Welcome back, <span style="color: var(--niet-red);"><c:out value="${student.firstName}"/></span> 👋
                        </h3>
                        <p class="text-muted small mb-0">
                            Enrollment: <strong class="text-dark"><c:out value="${student.enrollmentNo}"/></strong> &bull; 
                            Roll No: <strong class="text-dark"><c:out value="${student.rollNo}"/></strong> &bull; 
                            Dept: <strong class="text-dark"><c:out value="${student.department.deptName}"/></strong>
                        </p>
                    </div>
                    <div>
                        <span class="score-badge badge-tier-${scoreDto.tier}">
                            <c:out value="${scoreDto.tier}"/> TIER
                        </span>
                    </div>
                </div>

                <!-- Completeness Score Progress -->
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="fw-bold small text-secondary">Document Locker Completeness</span>
                        <span class="fw-bold fs-5" style="color: var(--niet-red);"><c:out value="${scoreDto.score}"/>%</span>
                    </div>
                    <div class="progress" style="height: 10px; border-radius: 999px; background-color: #F1F5F9;">
                        <div class="progress-bar" role="progressbar" style="width: ${scoreDto.score}%; background: linear-gradient(90deg, var(--niet-red) 0%, var(--niet-red-dark) 100%); border-radius: 999px;" aria-valuenow="${scoreDto.score}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                </div>

                <!-- Metric Summary Grid -->
                <div class="row text-center g-2 pt-2">
                    <div class="col-3">
                        <div class="p-2 rounded-3 bg-light">
                            <div class="text-muted small fw-semibold">Required</div>
                            <div class="fw-bold fs-5 text-dark"><c:out value="${scoreDto.totalRequired}"/></div>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="p-2 rounded-3" style="background: var(--status-success-bg);">
                            <div class="text-success small fw-semibold">Verified</div>
                            <div class="fw-bold fs-5 text-success"><c:out value="${scoreDto.totalVerified}"/></div>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="p-2 rounded-3" style="background: var(--status-warning-bg);">
                            <div class="text-warning small fw-semibold">In Review</div>
                            <div class="fw-bold fs-5 text-warning"><c:out value="${scoreDto.totalPending}"/></div>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="p-2 rounded-3" style="background: var(--status-danger-bg);">
                            <div class="text-danger small fw-semibold">Action Needed</div>
                            <div class="fw-bold fs-5 text-danger"><c:out value="${scoreDto.totalRejected}"/></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions Card -->
        <div class="col-lg-4">
            <div class="smart-card p-4 h-100 bg-white d-flex flex-column justify-content-between">
                <div>
                    <h6 class="fw-bold mb-3 d-flex align-items-center gap-2 text-dark">
                        <i class="bi bi-lightning-charge-fill" style="color: var(--niet-red);"></i> 
                        Quick Vault Actions
                    </h6>
                    <div class="d-grid gap-2">
                        <a href="<c:url value='/student/upload'/>" class="btn btn-niet btn-sm py-2.5">
                            <i class="bi bi-cloud-arrow-up-fill"></i> Upload Academic Document
                        </a>
                        <a href="<c:url value='/student/achievements/upload'/>" class="btn btn-glass-action btn-sm py-2">
                            <i class="bi bi-award-fill text-warning"></i> Upload Achievement / Certificate
                        </a>
                        <a href="<c:url value='/student/shares'/>" class="btn btn-glass-action btn-sm py-2">
                            <i class="bi bi-share-fill text-primary"></i> Create Secure Share Link
                        </a>
                        <a href="<c:url value='/student/requests'/>" class="btn btn-glass-action btn-sm py-2">
                            <i class="bi bi-file-earmark-plus-fill text-secondary"></i> Request Official Transcript
                        </a>
                    </div>
                </div>
                <div class="mt-3 pt-3 border-top small text-muted d-flex align-items-center gap-2">
                    <i class="bi bi-shield-check text-success fs-5"></i>
                    <span>SHA-256 cryptographically anchored institutional vault.</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Missing Document Alert Banner -->
    <c:if test="${not empty scoreDto.missingDocumentTypeNames}">
        <div class="alert alert-danger border-0 rounded-4 shadow-sm p-3 mb-4 d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3" style="background: rgba(254, 226, 226, 0.95); border-left: 5px solid var(--niet-red) !important;">
            <div class="d-flex align-items-center gap-2.5">
                <i class="bi bi-exclamation-octagon-fill fs-4" style="color: var(--niet-red);"></i>
                <div>
                    <strong class="text-danger-emphasis">Mandatory Action Required:</strong>
                    <div class="small text-danger-emphasis">Missing required documents: 
                        <strong><c:forEach items="${scoreDto.missingDocumentTypeNames}" var="name" varStatus="loop"><c:out value="${name}"/><c:if test="${!loop.last}">, </c:if></c:forEach></strong>
                    </div>
                </div>
            </div>
            <a href="<c:url value='/student/upload'/>" class="btn btn-sm btn-niet text-nowrap">Upload Mandatory Document</a>
        </div>
    </c:if>

    <!-- Recent Documents Table -->
    <div class="smart-card">
        <div class="p-3 px-4 bg-white border-bottom d-flex align-items-center justify-content-between">
            <h6 class="mb-0 fw-bold d-flex align-items-center gap-2 text-dark">
                <i class="bi bi-folder-fill" style="color: var(--niet-red);"></i>
                Recent Documents in Vault
            </h6>
            <a href="<c:url value='/student/vault'/>" class="btn btn-sm btn-niet-outline">View Complete Vault</a>
        </div>
        <div class="table-responsive">
            <table class="smart-table">
                <thead>
                    <tr>
                        <th>Document Code</th>
                        <th>Document Name</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Version</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${recentDocs}" var="doc">
                        <tr>
                            <td class="fw-bold font-monospace small" style="color: var(--niet-muted);"><c:out value="${doc.documentCode}"/></td>
                            <td>
                                <a href="<c:url value='/student/document/${doc.id}'/>" class="fw-bold text-dark text-decoration-none hover-red">
                                    <c:out value="${doc.title}"/>
                                </a>
                                <div class="text-muted small"><c:out value="${doc.fileName}"/></div>
                            </td>
                            <td>
                                <span class="badge bg-light text-secondary border px-2 py-1"><c:out value="${doc.documentType.category.categoryName}"/></span>
                            </td>
                            <td>
                                <span class="status-pill status-${doc.status}"><c:out value="${doc.status}"/></span>
                            </td>
                            <td>
                                <span class="badge bg-light text-dark border">v<c:out value="${doc.currentVersion}"/></span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="<c:url value='/documents/view/${doc.id}'/>" target="_blank" class="btn btn-glass-action" title="View Preview"><i class="bi bi-eye"></i></a>
                                    <a href="<c:url value='/documents/download/${doc.id}'/>" class="btn btn-glass-action" title="Download"><i class="bi bi-download"></i></a>
                                    <a href="<c:url value='/student/document/${doc.id}'/>" class="btn btn-glass-action" title="Details & QR"><i class="bi bi-qr-code"></i></a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentDocs}">
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-folder2-open fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                No documents in your vault yet. Upload your first academic document to begin.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
