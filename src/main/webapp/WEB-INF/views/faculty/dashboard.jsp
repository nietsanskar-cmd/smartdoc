<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Review Console — NIET SDMS" scope="request"/>
<c:set var="activePage" value="dashboard" scope="request"/>
<c:set var="pageHeader" value="Faculty Verification Console" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <span class="badge" style="background: var(--niet-red-light); color: var(--niet-red); font-size: 0.72rem; font-weight: 700;">NIET FACULTY REVIEWER</span>
            </div>
            <h3 class="fw-extrabold mb-1 text-dark">
                Welcome, <c:out value="${faculty.fullName}"/>
            </h3>
            <p class="text-muted small mb-0"><c:out value="${faculty.designation}"/> &bull; Department of <strong class="text-dark"><c:out value="${faculty.department.deptName}"/></strong></p>
        </div>
        <a href="<c:url value='/faculty/queue'/>" class="btn btn-niet">
            <i class="bi bi-patch-check-fill me-1"></i> Open Verification Queue (<c:out value="${pendingCount}"/>)
        </a>
    </div>

    <!-- Stat Metric Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-6 col-lg-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-amber">
                    <i class="bi bi-clock-history"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Pending Reviews</div>
                    <h3 class="fw-extrabold mb-0 text-warning"><c:out value="${pendingCount}"/></h3>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card-premium">
                <div class="stat-icon-wrapper stat-icon-red">
                    <i class="bi bi-people"></i>
                </div>
                <div>
                    <div class="text-muted small text-uppercase fw-bold">Assigned Students</div>
                    <h3 class="fw-extrabold mb-0" style="color: var(--niet-red);"><c:out value="${studentCount}"/></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Verification Queue Section -->
    <div class="smart-card">
        <div class="p-3 px-4 bg-white border-bottom d-flex align-items-center justify-content-between">
            <h6 class="mb-0 fw-bold d-flex align-items-center gap-2 text-dark">
                <i class="bi bi-card-checklist" style="color: var(--niet-red);"></i>
                Documents Awaiting Verification
            </h6>
            <a href="<c:url value='/faculty/queue'/>" class="btn btn-sm btn-niet-outline">Open Full Queue</a>
        </div>
        <div class="table-responsive">
            <table class="smart-table">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Student Name & Enrollment</th>
                        <th>Document Type</th>
                        <th>Submitted At</th>
                        <th>Version</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${queue}" var="item">
                        <tr>
                            <td class="font-monospace fw-bold small text-muted"><c:out value="${item.documentCode}"/></td>
                            <td>
                                <div class="fw-bold text-dark"><c:out value="${item.studentName}"/></div>
                                <div class="text-muted small font-monospace"><c:out value="${item.enrollmentNo}"/></div>
                            </td>
                            <td><span class="badge bg-light text-secondary border"><c:out value="${item.documentTypeName}"/></span></td>
                            <td class="small text-muted"><c:out value="${item.submittedAt}"/></td>
                            <td><span class="badge bg-light text-dark border">v<c:out value="${item.versionNumber}"/></span></td>
                            <td>
                                <a href="<c:url value='/faculty/review/${item.documentId}'/>" class="btn btn-niet btn-sm py-1.5 px-3">
                                    <i class="bi bi-search me-1"></i> Review & Certify
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty queue}">
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-check2-all fs-1 d-block mb-2 text-success opacity-75"></i>
                                All pending documents have been reviewed! Your verification queue is clear.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
