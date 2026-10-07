<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="All Documents - NIET SDMS" scope="request"/>
<c:set var="activePage" value="allDocs" scope="request"/>
<c:set var="pageHeader" value="Institutional Document Repository" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-files text-primary me-2"></i>Institutional Document Master List</h4>
            <p class="text-muted small mb-0">Search and audit all student uploads across every academic department.</p>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="card smart-card p-3 bg-white mb-4">
        <form action="<c:url value='/admin/documents'/>" method="get" class="row g-2">
            <div class="col-md-4">
                <input type="text" name="query" class="form-control form-control-sm" placeholder="Search title or student...">
            </div>
            <div class="col-md-3">
                <select name="status" class="form-select form-select-sm">
                    <option value="">-- All Statuses --</option>
                    <c:forEach items="${statuses}" var="st">
                        <option value="${st}"><c:out value="${st}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <select name="deptId" class="form-select form-select-sm">
                    <option value="">-- All Departments --</option>
                    <c:forEach items="${departments}" var="d">
                        <option value="${d.id}"><c:out value="${d.deptCode}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <select name="typeId" class="form-select form-select-sm">
                    <option value="">-- All Types --</option>
                    <c:forEach items="${documentTypes}" var="t">
                        <option value="${t.id}"><c:out value="${t.typeName}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-1">
                <button type="submit" class="btn btn-primary btn-sm w-100"><i class="bi bi-filter"></i></button>
            </div>
        </form>
    </div>

    <!-- Documents Master Table -->
    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Student</th>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Version</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${documents}" var="doc">
                        <tr>
                            <td class="font-monospace fw-semibold"><c:out value="${doc.documentCode}"/></td>
                            <td class="fw-semibold"><c:out value="${doc.student.fullName}"/><div class="small text-muted"><c:out value="${doc.student.enrollmentNo}"/></div></td>
                            <td><c:out value="${doc.title}"/></td>
                            <td><c:out value="${doc.documentType.typeName}"/></td>
                            <td><span class="status-badge status-${doc.status}"><c:out value="${doc.status}"/></span></td>
                            <td><span class="badge bg-light text-dark border">v<c:out value="${doc.currentVersion}"/></span></td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="<c:url value='/documents/view/${doc.id}'/>" target="_blank" class="btn btn-outline-primary" title="View"><i class="bi bi-eye"></i></a>
                                    <a href="<c:url value='/documents/download/${doc.id}'/>" class="btn btn-outline-secondary" title="Download"><i class="bi bi-download"></i></a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty documents}">
                        <tr><td colspan="7" class="text-center py-4 text-muted">No documents found matching search criteria.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

