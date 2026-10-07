<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Directory - NIET SDMS" scope="request"/>
<c:set var="activePage" value="faculty" scope="request"/>
<c:set var="pageHeader" value="Faculty Members & Reviewers" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-person-badge text-primary me-2"></i>Faculty Management</h4>
            <p class="text-muted small mb-0">Manage faculty reviewers and document verification assignees.</p>
        </div>
        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addFacultyModal">
            <i class="bi bi-plus-circle me-1"></i> Add Faculty Member
        </button>
    </div>

    <!-- Faculty Roster Table -->
    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Employee Code</th>
                        <th>Name</th>
                        <th>Department</th>
                        <th>Designation</th>
                        <th>Email</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${facultyList}" var="f">
                        <tr>
                            <td class="font-monospace fw-bold text-primary"><c:out value="${f.employeeCode}"/></td>
                            <td class="fw-semibold"><c:out value="${f.fullName}"/></td>
                            <td><c:out value="${f.department.deptName}"/></td>
                            <td><c:out value="${f.designation}"/></td>
                            <td><c:out value="${f.user.email}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${f.user.isActive}"><span class="badge bg-success">Active</span></c:when>
                                    <c:otherwise><span class="badge bg-danger">Suspended</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Faculty Modal -->
<div class="modal fade" id="addFacultyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<c:url value='/admin/faculty/create'/>" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add Faculty Member</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Username *</label>
                            <input type="text" name="username" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Password *</label>
                            <input type="password" name="password" class="form-control form-control-sm" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-semibold">Email *</label>
                        <input type="email" name="email" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-semibold">Employee Code *</label>
                        <input type="text" name="employeeCode" class="form-control form-control-sm" required>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">First Name *</label>
                            <input type="text" name="firstName" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Last Name *</label>
                            <input type="text" name="lastName" class="form-control form-control-sm" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-semibold">Department *</label>
                        <select name="departmentId" class="form-select form-select-sm" required>
                            <c:forEach items="${departments}" var="d">
                                <option value="${d.id}"><c:out value="${d.deptName}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-semibold">Designation *</label>
                        <input type="text" name="designation" class="form-control form-control-sm" placeholder="e.g. Associate Professor" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-semibold">Qualification</label>
                        <input type="text" name="qualification" class="form-control form-control-sm" placeholder="e.g. Ph.D. in Computer Science">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm">Save Faculty Member</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

