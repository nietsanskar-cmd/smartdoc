<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Assigned Students - NIET SDMS" scope="request"/>
<c:set var="activePage" value="students" scope="request"/>
<c:set var="pageHeader" value="Assigned Mentee Directory" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0"><i class="bi bi-people text-primary me-2"></i>My Assigned Mentees</h4>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Enrollment No</th>
                        <th>Student Name</th>
                        <th>Course / Semester</th>
                        <th>Completeness Score</th>
                        <th>Tier</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${students}" var="s">
                        <tr>
                            <td class="font-monospace fw-bold text-primary"><c:out value="${s.enrollmentNo}"/></td>
                            <td class="fw-semibold"><c:out value="${s.fullName}"/></td>
                            <td><c:out value="${s.course.courseCode}"/> - Sem <c:out value="${s.currentSemester.semesterNumber}"/></td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="progress flex-grow-1" style="height: 8px;">
                                        <div class="progress-bar bg-primary" style="width: ${s.completenessScore}%;"></div>
                                    </div>
                                    <span class="small fw-bold"><c:out value="${s.completenessScore}"/>%</span>
                                </div>
                            </td>
                            <td><span class="completeness-badge badge-tier-${s.completenessTier}"><c:out value="${s.completenessTier}"/></span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty students}">
                        <tr><td colspan="5" class="text-center py-4 text-muted">No students assigned to your mentorship yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

