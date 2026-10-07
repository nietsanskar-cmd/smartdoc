<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Department Stats - NIET SDMS" scope="request"/>
<c:set var="activePage" value="deptStats" scope="request"/>
<c:set var="pageHeader" value="Department Statistics & Overview" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Department: <c:out value="${faculty.department.deptName}"/></h4>
            <p class="text-muted small mb-0">Total Enrolled Students: <c:out value="${departmentStudents.size()}"/></p>
        </div>
    </div>

    <div class="card smart-card bg-white">
        <div class="card-header bg-white py-3">
            <h6 class="fw-bold mb-0">Department Student Completeness Roster</h6>
        </div>
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Enrollment No</th>
                        <th>Student Name</th>
                        <th>Course</th>
                        <th>Completeness Score</th>
                        <th>Tier</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${departmentStudents}" var="s">
                        <tr>
                            <td class="font-monospace fw-semibold"><c:out value="${s.enrollmentNo}"/></td>
                            <td class="fw-semibold"><c:out value="${s.fullName}"/></td>
                            <td><c:out value="${s.course.courseCode}"/></td>
                            <td><strong><c:out value="${s.completenessScore}"/>%</strong></td>
                            <td><span class="completeness-badge badge-tier-${s.completenessTier}"><c:out value="${s.completenessTier}"/></span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

