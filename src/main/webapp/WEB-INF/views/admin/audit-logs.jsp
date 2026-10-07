<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Audit Logs - NIET SDMS" scope="request"/>
<c:set var="activePage" value="auditLogs" scope="request"/>
<c:set var="pageHeader" value="Forensic System Audit Trail" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-journal-text text-primary me-2"></i>Institutional Audit Trail</h4>
            <p class="text-muted small mb-0">Immutable records of system actions, mutations, logins, and verifications.</p>
        </div>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Action</th>
                        <th>Target Entity</th>
                        <th>Details</th>
                        <th>IP Address</th>
                        <th>Timestamp</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${logs}" var="l">
                        <tr>
                            <td class="fw-semibold"><c:out value="${l.user != null ? l.user.username : 'SYSTEM'}"/></td>
                            <td><span class="badge bg-light text-dark border"><c:out value="${l.action}"/></span></td>
                            <td><c:out value="${l.entityType}"/> <c:if test="${l.entityId != null}">#<c:out value="${l.entityId}"/></c:if></td>
                            <td class="small text-muted"><c:out value="${l.details}"/></td>
                            <td class="font-monospace small"><c:out value="${l.ipAddress}"/></td>
                            <td class="small text-muted"><c:out value="${l.createdAt}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

