<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Document Requests - NIET SDMS" scope="request"/>
<c:set var="activePage" value="requests" scope="request"/>
<c:set var="pageHeader" value="Student Certificate Issuance Requests" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-inbox text-primary me-2"></i>Official Document Requests</h4>
            <p class="text-muted small mb-0">Approve, process, and complete student requests for official certificates.</p>
        </div>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Request No</th>
                        <th>Student</th>
                        <th>Document Requested</th>
                        <th>Purpose</th>
                        <th>Status</th>
                        <th>Requested Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requests}" var="req">
                        <tr>
                            <td class="font-monospace fw-bold text-primary"><c:out value="${req.requestNo}"/></td>
                            <td class="fw-semibold"><c:out value="${req.student.fullName}"/><div class="small text-muted"><c:out value="${req.student.enrollmentNo}"/></div></td>
                            <td><c:out value="${req.documentType.typeName}"/></td>
                            <td class="small text-muted"><c:out value="${req.purpose}"/></td>
                            <td><span class="status-badge status-${req.status}"><c:out value="${req.status}"/></span></td>
                            <td class="small text-muted"><c:out value="${req.requestedAt}"/></td>
                            <td>
                                <form action="<c:url value='/admin/requests/${req.id}/status'/>" method="post" class="d-flex gap-1 align-items-center">
                                    <select name="status" class="form-select form-select-sm" style="width: 130px;">
                                        <option value="PROCESSING" ${req.status == 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
                                        <option value="APPROVED" ${req.status == 'APPROVED' ? 'selected' : ''}>APPROVE</option>
                                        <option value="COMPLETED" ${req.status == 'COMPLETED' ? 'selected' : ''}>COMPLETE</option>
                                        <option value="REJECTED" ${req.status == 'REJECTED' ? 'selected' : ''}>REJECT</option>
                                    </select>
                                    <input type="text" name="adminRemarks" class="form-control form-control-sm" placeholder="Remarks" value="${req.adminRemarks}" style="width: 120px;">
                                    <button type="submit" class="btn btn-primary btn-sm"><i class="bi bi-check2"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requests}">
                        <tr><td colspan="7" class="text-center py-4 text-muted">No student document requests pending.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

