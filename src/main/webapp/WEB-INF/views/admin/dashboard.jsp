<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Administration Console — NIET SDMS" scope="request"/>
<c:set var="activePage" value="dashboard" scope="request"/>
<c:set var="pageHeader" value="Institutional Document Analytics & Governance" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <span class="badge" style="background: var(--niet-red-light); color: var(--niet-red); font-size: 0.72rem; font-weight: 700;">NIET INSTITUTIONAL ADMIN</span>
            </div>
            <h3 class="fw-extrabold mb-1 text-dark">
                Governance & Document Analytics
            </h3>
            <p class="text-muted small mb-0">Cross-departmental records, tamper verification monitoring, and storage audit.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="<c:url value='/admin/documents'/>" class="btn btn-niet">
                <i class="bi bi-files me-1"></i> Master Vault
            </a>
            <a href="<c:url value='/admin/students'/>" class="btn btn-glass-action">
                <i class="bi bi-people-fill me-1"></i> Student Directory
            </a>
        </div>
    </div>

    <!-- Stat Metric Cards -->
    <div class="row g-4 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-red">
                    <i class="bi bi-mortarboard"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Total Students</div>
                    <h3 class="fw-extrabold mb-0" style="color: var(--niet-red);"><c:out value="${analytics.totalStudents}"/></h3>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-emerald">
                    <i class="bi bi-patch-check"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Verified Documents</div>
                    <h3 class="fw-extrabold mb-0 text-success"><c:out value="${analytics.verifiedDocuments}"/></h3>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-amber">
                    <i class="bi bi-hourglass-split"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Pending Review</div>
                    <h3 class="fw-extrabold mb-0 text-warning"><c:out value="${analytics.pendingVerifications}"/></h3>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-blue">
                    <i class="bi bi-hdd-network"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Storage Consumed</div>
                    <h3 class="fw-extrabold mb-0" style="color: #0284C7;"><c:out value="${analytics.formattedStorage}"/></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Analytics Charts Row -->
    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <div class="smart-card p-4 bg-white h-100">
                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2 text-dark">
                    <i class="bi bi-pie-chart-fill" style="color: var(--niet-red);"></i>
                    Document Lifecycle Breakdown
                </h6>
                <div style="position: relative; height: 260px; width: 100%;">
                    <canvas id="docStatusChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="smart-card p-4 bg-white h-100">
                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2 text-dark">
                    <i class="bi bi-bar-chart-fill" style="color: var(--niet-red);"></i>
                    Department Completeness Averages (%)
                </h6>
                <div style="position: relative; height: 260px; width: 100%;">
                    <canvas id="deptCompletenessChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Audit Activity -->
    <div class="smart-card">
        <div class="p-3 px-4 bg-white border-bottom d-flex align-items-center justify-content-between">
            <h6 class="mb-0 fw-bold d-flex align-items-center gap-2 text-dark">
                <i class="bi bi-journal-text" style="color: var(--niet-red);"></i>
                Recent Institutional Activity Ledger
            </h6>
            <a href="<c:url value='/admin/audit-logs'/>" class="btn btn-sm btn-niet-outline">View Full Audit Trail</a>
        </div>
        <div class="table-responsive">
            <table class="smart-table">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Action</th>
                        <th>Entity</th>
                        <th>Details</th>
                        <th>IP Address</th>
                        <th>Timestamp</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${recentLogs}" var="log">
                        <tr>
                            <td class="fw-bold text-dark"><c:out value="${log.user != null ? log.user.username : 'SYSTEM'}"/></td>
                            <td><span class="badge bg-light text-secondary border font-monospace"><c:out value="${log.action}"/></span></td>
                            <td><c:out value="${log.entityType}"/> #<c:out value="${log.entityId}"/></td>
                            <td class="small text-muted"><c:out value="${log.details}"/></td>
                            <td class="font-monospace small text-muted"><c:out value="${log.ipAddress}"/></td>
                            <td class="small text-muted"><c:out value="${log.createdAt}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const existingStatus = Chart.getChart('docStatusChart');
    if (existingStatus) existingStatus.destroy();

    const existingDept = Chart.getChart('deptCompletenessChart');
    if (existingDept) existingDept.destroy();

    // 1. Status Breakdown Chart with NIET Palette
    const ctxStatus = document.getElementById('docStatusChart').getContext('2d');
    new Chart(ctxStatus, {
        type: 'doughnut',
        data: {
            labels: ['Verified', 'Under Review', 'Action Required', 'Expired'],
            datasets: [{
                data: [${analytics.verifiedDocuments}, ${analytics.pendingVerifications}, ${analytics.rejectedDocuments}, ${analytics.expiredDocuments}],
                backgroundColor: ['#10B981', '#F59E0B', '#D71920', '#94A3B8'],
                borderWidth: 2,
                borderColor: '#FFFFFF'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            resizeDelay: 200,
            animation: false,
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });

    // 2. Department Completeness Chart with NIET Red
    const ctxDept = document.getElementById('deptCompletenessChart').getContext('2d');
    new Chart(ctxDept, {
        type: 'bar',
        data: {
            labels: [<c:forEach items="${analytics.departmentCompletenessAverages}" var="entry" varStatus="loop">'${entry.key}'<c:if test="${!loop.last}">,</c:if></c:forEach>],
            datasets: [{
                label: 'Avg Completeness %',
                data: [<c:forEach items="${analytics.departmentCompletenessAverages}" var="entry" varStatus="loop">${entry.value}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                backgroundColor: '#D71920',
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            resizeDelay: 200,
            animation: false,
            scales: { y: { beginAtZero: true, max: 100 } }
        }
    });
});
</script>

<jsp:include page="../common/footer.jsp"/>
