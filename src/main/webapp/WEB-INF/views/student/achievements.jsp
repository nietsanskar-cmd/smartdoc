<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Achievements & Certifications — NIET SDMS" scope="request"/>
<c:set var="activePage" value="achievements" scope="request"/>
<c:set var="pageHeader" value="Student Achievements & Digital Portfolio" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h4 class="fw-extrabold mb-1 d-flex align-items-center gap-2 text-dark">
                <i class="bi bi-award-fill" style="color: var(--niet-red);"></i>
                Achievements & Skill Certifications
            </h4>
            <p class="text-muted small mb-0">Showcase verified industry internships, research papers, patents, and hackathon certificates.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="<c:url value='/student/vault'/>" class="btn btn-glass-action">
                <i class="bi bi-safe2 me-1"></i> Full Vault
            </a>
            <a href="<c:url value='/student/achievements/upload'/>" class="btn btn-niet">
                <i class="bi bi-plus-circle me-1"></i> Upload Achievement
            </a>
        </div>
    </div>

    <!-- Stat Metric Cards -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-red">
                    <i class="bi bi-award"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Total Portfolio</div>
                    <h3 class="fw-extrabold mb-0" style="color: var(--niet-red);"><c:out value="${totalCount}"/></h3>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-emerald">
                    <i class="bi bi-briefcase"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Internships</div>
                    <h3 class="fw-extrabold mb-0 text-success"><c:out value="${internshipCount}"/></h3>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-blue">
                    <i class="bi bi-journal-text"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Research Papers</div>
                    <h3 class="fw-extrabold mb-0" style="color: #0284C7;"><c:out value="${researchPaperCount}"/></h3>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-amber">
                    <i class="bi bi-trophy"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Certs & Awards</div>
                    <h3 class="fw-extrabold mb-0 text-warning"><c:out value="${certCount + awardCount}"/></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Pills -->
    <div class="smart-card p-3 mb-4 bg-white">
        <div class="d-flex flex-wrap gap-2 align-items-center">
            <span class="small fw-bold text-muted me-2"><i class="bi bi-funnel me-1" style="color: var(--niet-red);"></i>Filter By:</span>
            <button class="btn btn-sm btn-niet filter-pill" onclick="filterAchievements('ALL', this)">All (${totalCount})</button>
            <button class="btn btn-sm btn-glass-action filter-pill" onclick="filterAchievements('INTERNSHIP_CERT', this)">Internships (${internshipCount})</button>
            <button class="btn btn-sm btn-glass-action filter-pill" onclick="filterAchievements('RESEARCH_PAPER', this)">Research Papers (${researchPaperCount})</button>
            <button class="btn btn-sm btn-glass-action filter-pill" onclick="filterAchievements('COURSE_CERT', this)">Certifications (${certCount})</button>
            <button class="btn btn-sm btn-glass-action filter-pill" onclick="filterAchievements('HACKATHON_AWARD', this)">Awards & Hackathons (${awardCount})</button>
        </div>
    </div>

    <!-- Achievements Grid -->
    <div class="row g-4" id="achievementGrid">
        <c:forEach items="${achievements}" var="doc">
            <div class="col-md-6 col-lg-4 achievement-item" data-type="${doc.documentType.typeCode}">
                <div class="smart-card h-100 p-4 bg-white d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge px-2.5 py-1 fw-bold" style="background: var(--niet-red-light); color: var(--niet-red); font-size: 0.72rem;">
                                <i class="bi ${doc.documentType.category.iconClass} me-1"></i>
                                <c:out value="${doc.documentType.typeName}"/>
                            </span>
                            <span class="status-pill status-${doc.status}"><c:out value="${doc.status}"/></span>
                        </div>

                        <h5 class="fw-bold mb-1 mt-2 text-truncate" title="${doc.title}">
                            <a href="<c:url value='/student/document/${doc.id}'/>" class="text-dark text-decoration-none hover-red">
                                <c:out value="${doc.title}"/>
                            </a>
                        </h5>
                        <div class="text-muted small mb-3 font-monospace"><c:out value="${doc.documentCode}"/></div>

                        <div class="p-3 rounded-3 mb-3" style="background: #F8FAFC; border: 1px solid #E2E8F0;">
                            <c:if test="${not empty doc.issueDate}">
                                <div class="d-flex justify-content-between small mb-1.5">
                                    <span class="text-muted">Issue Date:</span>
                                    <span class="text-dark fw-bold"><c:out value="${doc.issueDate}"/></span>
                                </div>
                            </c:if>
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
                            <a href="<c:url value='/student/shares'/>" class="btn btn-sm btn-niet-outline" title="Share with Recruiters">
                                <i class="bi bi-share-fill"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty achievements}">
            <div class="col-12" id="emptyState">
                <div class="smart-card p-5 text-center bg-white">
                    <i class="bi bi-award fs-1 mb-3 d-block" style="color: var(--niet-red);"></i>
                    <h5 class="fw-bold">No Achievements in Your Portfolio Yet</h5>
                    <p class="text-muted small mb-4">Upload your internship completion letters, IEEE research publications, hackathon awards, and certifications to build your verified academic portfolio.</p>
                    <div>
                        <a href="<c:url value='/student/achievements/upload'/>" class="btn btn-niet">
                            <i class="bi bi-plus-circle me-1"></i> Upload First Achievement
                        </a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
function filterAchievements(typeCode, btn) {
    document.querySelectorAll('.filter-pill').forEach(b => {
        b.className = 'btn btn-sm btn-glass-action filter-pill';
    });
    btn.className = 'btn btn-sm btn-niet filter-pill';

    const items = document.querySelectorAll('.achievement-item');
    items.forEach(item => {
        const itemType = item.getAttribute('data-type');
        if (typeCode === 'ALL' || itemType === typeCode || 
           (typeCode === 'RESEARCH_PAPER' && itemType === 'PATENT_PUBLICATION') ||
           (typeCode === 'COURSE_CERT' && itemType === 'WORKSHOP_CERT') ||
           (typeCode === 'HACKATHON_AWARD' && itemType === 'EXTRACURRICULAR_CERT')) {
            item.style.display = '';
        } else {
            item.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp"/>
