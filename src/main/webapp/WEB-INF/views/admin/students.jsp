<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Management - NIET SDMS" scope="request"/>
<c:set var="activePage" value="students" scope="request"/>
<c:set var="pageHeader" value="Student Information & Vault Directory" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-people text-primary me-2"></i>Student Management</h4>
            <p class="text-muted small mb-0">Browse student profiles, inspect completeness scores, and manage enrollment status.</p>
        </div>
        <a href="<c:url value='/register'/>" class="btn btn-primary btn-sm"><i class="bi bi-person-plus me-1"></i> Register Student</a>
    </div>

    <!-- Search & Filter Bar -->
    <div class="card smart-card p-3 bg-white mb-4">
        <form action="<c:url value='/admin/students'/>" method="get" class="row g-2">
            <div class="col-md-5">
                <input type="text" name="query" class="form-control form-control-sm" placeholder="Search by Name, Roll No or Enrollment No..." value="${selectedQuery}">
            </div>
            <div class="col-md-3">
                <select name="deptId" class="form-select form-select-sm">
                    <option value="">-- All Departments --</option>
                    <c:forEach items="${departments}" var="d">
                        <option value="${d.id}" ${selectedDept == d.id ? 'selected' : ''}><c:out value="${d.deptName}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <select name="courseId" class="form-select form-select-sm">
                    <option value="">-- All Courses --</option>
                    <c:forEach items="${courses}" var="c">
                        <option value="${c.id}" ${selectedCourse == c.id ? 'selected' : ''}><c:out value="${c.courseName}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-1">
                <button type="submit" class="btn btn-primary btn-sm w-100"><i class="bi bi-search"></i></button>
            </div>
        </form>
    </div>

    <!-- Students Table -->
    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Enrollment No</th>
                        <th>Student Name</th>
                        <th>Department</th>
                        <th>Course</th>
                        <th>Completeness</th>
                        <th>Tier</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${students}" var="s">
                        <tr>
                            <td class="font-monospace fw-bold text-primary"><c:out value="${s.enrollmentNo}"/></td>
                            <td class="fw-semibold"><c:out value="${s.fullName}"/></td>
                            <td><c:out value="${s.department.deptCode}"/></td>
                            <td><c:out value="${s.course.courseCode}"/></td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="progress flex-grow-1" style="height: 6px; width: 60px;">
                                        <div class="progress-bar bg-primary" style="width: ${s.completenessScore}%;"></div>
                                    </div>
                                    <span class="small fw-semibold"><c:out value="${s.completenessScore}"/>%</span>
                                </div>
                            </td>
                            <td><span class="completeness-badge badge-tier-${s.completenessTier}"><c:out value="${s.completenessTier}"/></span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${s.user.isActive}"><span class="badge bg-success">Active</span></c:when>
                                    <c:otherwise><span class="badge bg-danger">Suspended</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="<c:url value='/admin/students/${s.id}'/>" class="btn btn-outline-primary" title="View Digital Vault"><i class="bi bi-eye"></i></a>
                                    <form action="<c:url value='/admin/users/${s.user.id}/toggle-status'/>" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-outline-secondary" title="Toggle Status" onclick="return confirm('Toggle active/suspended status?');">
                                            <i class="bi bi-power"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty students}">
                        <tr><td colspan="8" class="text-center py-4 text-muted">No students matching the criteria.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

