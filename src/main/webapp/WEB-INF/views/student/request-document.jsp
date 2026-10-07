<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Certificate Requests - NIET SDMS" scope="request"/>
<c:set var="activePage" value="requests" scope="request"/>
<c:set var="pageHeader" value="Official Document & Certificate Requests" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="row g-4">
        <!-- New Request Form -->
        <div class="col-lg-4">
            <div class="card smart-card p-4 bg-white">
                <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-file-earmark-plus text-primary me-2"></i>New Certificate Request</h5>
                
                <form action="<c:url value='/student/requests/new'/>" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Certificate / Document Type *</label>
                        <select name="documentTypeId" class="form-select form-select-sm" required>
                            <option value="">-- Choose Certificate Type --</option>
                            <c:forEach items="${documentTypes}" var="dt">
                                <option value="${dt.id}"><c:out value="${dt.typeName}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-semibold">Purpose / Reason *</label>
                        <textarea name="purpose" rows="3" class="form-control form-control-sm" placeholder="e.g. Required for Higher Studies / Visa / Education Loan" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm w-100 py-2 fw-semibold">
                        <i class="bi bi-send me-1"></i> Submit Request to Admin Office
                    </button>
                </form>
            </div>
        </div>

        <!-- Requests History Table -->
        <div class="col-lg-8">
            <div class="card smart-card bg-white">
                <div class="card-header bg-white py-3">
                    <h6 class="fw-bold mb-0"><i class="bi bi-clock-history text-primary me-2"></i>My Submitted Requests</h6>
                </div>
                <div class="table-responsive">
                    <table class="table smart-table mb-0">
                        <thead>
                            <tr>
                                <th>Request No</th>
                                <th>Document Type</th>
                                <th>Purpose</th>
                                <th>Status</th>
                                <th>Remarks</th>
                                <th>Submitted At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${requests}" var="req">
                                <tr>
                                    <td class="font-monospace fw-bold text-primary"><c:out value="${req.requestNo}"/></td>
                                    <td class="fw-semibold"><c:out value="${req.documentType.typeName}"/></td>
                                    <td><c:out value="${req.purpose}"/></td>
                                    <td><span class="status-badge status-${req.status}"><c:out value="${req.status}"/></span></td>
                                    <td class="small text-muted"><c:out value="${req.adminRemarks != null ? req.adminRemarks : 'None'}"/></td>
                                    <td class="small text-muted"><c:out value="${req.requestedAt}"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty requests}">
                                <tr><td colspan="6" class="text-center py-4 text-muted">No certificate requests submitted yet.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

