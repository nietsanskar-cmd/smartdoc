<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Verification Queue - NIET SDMS" scope="request"/>
<c:set var="activePage" value="queue" scope="request"/>
<c:set var="pageHeader" value="Faculty Document Verification Worklist" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-check2-circle text-primary me-2"></i>Verification Queue</h4>
            <p class="text-muted small mb-0">Documents submitted by your assigned mentees requiring verification.</p>
        </div>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Document Code</th>
                        <th>Student</th>
                        <th>Document Type</th>
                        <th>Category</th>
                        <th>Submitted At</th>
                        <th>Version</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${queue}" var="item">
                        <tr>
                            <td class="font-monospace fw-semibold text-secondary"><c:out value="${item.documentCode}"/></td>
                            <td class="fw-semibold"><c:out value="${item.studentName}"/><div class="small text-muted"><c:out value="${item.enrollmentNo}"/></div></td>
                            <td><c:out value="${item.documentTypeName}"/></td>
                            <td><span class="badge bg-light text-dark border"><c:out value="${item.categoryName}"/></span></td>
                            <td class="small text-muted"><c:out value="${item.submittedAt}"/></td>
                            <td><span class="badge bg-light text-dark border">v<c:out value="${item.versionNumber}"/></span></td>
                            <td>
                                <a href="<c:url value='/faculty/review/${item.documentId}'/>" class="btn btn-primary btn-sm">
                                    <i class="bi bi-file-earmark-check me-1"></i> Review & Verify
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty queue}">
                        <tr><td colspan="7" class="text-center py-5 text-muted">All assigned documents have been reviewed. Verification queue is empty.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

