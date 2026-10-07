<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Download Ledger - NIET SDMS" scope="request"/>
<c:set var="activePage" value="downloadLogs" scope="request"/>
<c:set var="pageHeader" value="Document Download & Access History" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-download text-primary me-2"></i>Download History Ledger</h4>
            <p class="text-muted small mb-0">Audit records of every downloaded file with IP addresses and access types.</p>
        </div>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Document Code</th>
                        <th>Title</th>
                        <th>Downloaded By</th>
                        <th>Access Type</th>
                        <th>IP Address</th>
                        <th>Downloaded At</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${logs}" var="dl">
                        <tr>
                            <td class="font-monospace fw-semibold"><c:out value="${dl.document.documentCode}"/></td>
                            <td class="fw-semibold"><c:out value="${dl.document.title}"/></td>
                            <td><c:out value="${dl.downloadedByUser != null ? dl.downloadedByUser.username : 'Anonymous / Share Link'}"/></td>
                            <td><span class="badge bg-light text-dark border"><c:out value="${dl.downloadType}"/></span></td>
                            <td class="font-monospace small"><c:out value="${dl.ipAddress}"/></td>
                            <td class="small text-muted"><c:out value="${dl.downloadedAt}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

