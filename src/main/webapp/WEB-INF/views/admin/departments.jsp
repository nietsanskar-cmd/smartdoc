<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Departments - NIET SDMS" scope="request"/>
<c:set var="activePage" value="departments" scope="request"/>
<c:set var="pageHeader" value="Academic Departments" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0"><i class="bi bi-buildings text-primary me-2"></i>Departments</h4>
        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addDeptModal">
            <i class="bi bi-plus-circle me-1"></i> Add Department
        </button>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Department Name</th>
                        <th>Description</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${departments}" var="d">
                        <tr>
                            <td class="font-monospace fw-bold text-primary"><c:out value="${d.deptCode}"/></td>
                            <td class="fw-semibold"><c:out value="${d.deptName}"/></td>
                            <td class="text-muted small"><c:out value="${d.description}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${d.isActive}"><span class="badge bg-success">Active</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="addDeptModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<c:url value='/admin/departments/create'/>" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add New Department</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Department Code *</label>
                        <input type="text" name="deptCode" class="form-control form-control-sm" placeholder="e.g. CSE" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Department Name *</label>
                        <input type="text" name="deptName" class="form-control form-control-sm" placeholder="e.g. Computer Science & Engineering" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Description</label>
                        <textarea name="description" rows="3" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm">Save Department</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

