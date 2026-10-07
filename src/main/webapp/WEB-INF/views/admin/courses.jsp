<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Courses - NIET SDMS" scope="request"/>
<c:set var="activePage" value="courses" scope="request"/>
<c:set var="pageHeader" value="Academic Degrees & Courses" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0"><i class="bi bi-journal-bookmark text-primary me-2"></i>Courses & Programs</h4>
        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addCourseModal">
            <i class="bi bi-plus-circle me-1"></i> Add Course
        </button>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Department</th>
                        <th>Semesters</th>
                        <th>Degree Level</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${courses}" var="c">
                        <tr>
                            <td class="font-monospace fw-bold text-primary"><c:out value="${c.courseCode}"/></td>
                            <td class="fw-semibold"><c:out value="${c.courseName}"/></td>
                            <td><c:out value="${c.department.deptName}"/></td>
                            <td><c:out value="${c.totalSemesters}"/> Semesters</td>
                            <td><c:out value="${c.degreeLevel}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.isActive}"><span class="badge bg-success">Active</span></c:when>
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

<div class="modal fade" id="addCourseModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<c:url value='/admin/courses/create'/>" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add New Course</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Course Code *</label>
                        <input type="text" name="courseCode" class="form-control form-control-sm" placeholder="e.g. BTECH_CSE" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Course Name *</label>
                        <input type="text" name="courseName" class="form-control form-control-sm" placeholder="e.g. B.Tech in Computer Science" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Department *</label>
                        <select name="departmentId" class="form-select form-select-sm" required>
                            <c:forEach items="${departments}" var="d">
                                <option value="${d.id}"><c:out value="${d.deptName}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Total Semesters</label>
                            <input type="number" name="totalSemesters" class="form-control form-control-sm" value="8" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Degree Level</label>
                            <select name="degreeLevel" class="form-select form-select-sm">
                                <option value="Undergraduate">Undergraduate</option>
                                <option value="Postgraduate">Postgraduate</option>
                                <option value="Diploma">Diploma</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm">Save Course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

