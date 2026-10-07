<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Vault Details - NIET SDMS" scope="request"/>
<c:set var="activePage" value="students" scope="request"/>
<c:set var="pageHeader" value="Student Digital Profile & Vault Overview" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><c:out value="${student.fullName}"/> (<c:out value="${student.enrollmentNo}"/>)</h4>
            <p class="text-muted small mb-0"><c:out value="${student.department.deptName}"/> &bull; <c:out value="${student.course.courseName}"/></p>
        </div>
        <a href="<c:url value='/admin/students'/>" class="btn btn-outline-secondary btn-sm">Back to Student List</a>
    </div>

    <!-- Student Profile & Advisor Assignment -->
    <div class="row g-4 mb-4">
        <div class="col-lg-7">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2">Student Digital Profile</h5>
                <dl class="row small mb-0">
                    <dt class="col-4 text-muted">Email:</dt>
                    <dd class="col-8"><c:out value="${profile.email}"/></dd>
                    <dt class="col-4 text-muted">Phone:</dt>
                    <dd class="col-8"><c:out value="${profile.phone}"/></dd>
                    <dt class="col-4 text-muted">Academic Year:</dt>
                    <dd class="col-8"><c:out value="${profile.academicYear}"/></dd>
                    <dt class="col-4 text-muted">Current Semester:</dt>
                    <dd class="col-8">Semester <c:out value="${profile.semesterNumber}"/></dd>
                    <dt class="col-4 text-muted">Completeness Score:</dt>
                    <dd class="col-8 fw-bold text-primary"><c:out value="${profile.completenessScore}"/>% (<c:out value="${profile.completenessTier}"/>)</dd>
                    <dt class="col-4 text-muted">Assigned Faculty Advisor:</dt>
                    <dd class="col-8 fw-semibold text-dark"><c:out value="${profile.facultyAdvisorName}"/></dd>
                </dl>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card smart-card p-4 bg-white h-100">
                <h5 class="fw-bold mb-3 border-bottom pb-2">Assign Faculty Advisor</h5>
                <form action="<c:url value='/admin/students/${student.id}/assign-faculty'/>" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Select Faculty Member</label>
                        <select name="facultyId" class="form-select form-select-sm" required>
                            <c:forEach items="${facultyList}" var="f">
                                <option value="${f.id}" ${student.assignedFaculty != null && student.assignedFaculty.id == f.id ? 'selected' : ''}>
                                    <c:out value="${f.fullName}"/> (<c:out value="${f.designation}"/>)
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary btn-sm w-100 py-2 fw-semibold">Assign Advisor</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Student Vault Documents Table -->
    <div class="card smart-card bg-white">
        <div class="card-header bg-white py-3">
            <h6 class="fw-bold mb-0">Documents in Student Vault</h6>
        </div>
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Document Title</th>
                        <th>Type</th>
                        <th>Version</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${documents}" var="d">
                        <tr>
                            <td class="font-monospace fw-semibold"><c:out value="${d.documentCode}"/></td>
                            <td class="fw-semibold"><c:out value="${d.title}"/></td>
                            <td><c:out value="${d.documentType.typeName}"/></td>
                            <td><span class="badge bg-light text-dark border">v<c:out value="${d.currentVersion}"/></span></td>
                            <td><span class="status-badge status-${d.status}"><c:out value="${d.status}"/></span></td>
                            <td>
                                <a href="<c:url value='/documents/view/${d.id}'/>" target="_blank" class="btn btn-outline-primary btn-sm"><i class="bi bi-eye"></i> View</a>
                                <a href="<c:url value='/documents/download/${d.id}'/>" class="btn btn-outline-secondary btn-sm"><i class="bi bi-download"></i> Download</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty documents}">
                        <tr><td colspan="6" class="text-center py-4 text-muted">No documents uploaded by this student.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

