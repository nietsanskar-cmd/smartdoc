<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Secure Sharing - NIET SDMS" scope="request"/>
<c:set var="activePage" value="shares" scope="request"/>
<c:set var="pageHeader" value="Time-Limited Document Sharing" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="row g-4">
        <!-- Generate Share Link Form -->
        <div class="col-lg-4">
            <div class="card smart-card p-4 bg-white">
                <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-shield-lock text-primary me-2"></i>Generate Share Link</h5>
                
                <form action="<c:url value='/student/shares/create'/>" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Select Verified Document *</label>
                        <select name="documentId" class="form-select form-select-sm" required>
                            <option value="">-- Choose Verified Document --</option>
                            <c:forEach items="${verifiedDocs}" var="d">
                                <option value="${d.id}"><c:out value="${d.title}"/> (v${d.currentVersion})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Recipient Email (Optional)</label>
                        <input type="email" name="recipientEmail" class="form-control form-control-sm" placeholder="e.g. recruiter@company.com">
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Validity</label>
                            <select name="durationHours" class="form-select form-select-sm">
                                <option value="24">24 Hours</option>
                                <option value="48" selected>48 Hours</option>
                                <option value="72">3 Days</option>
                                <option value="168">7 Days</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Max Views</label>
                            <input type="number" name="maxAccessCount" class="form-control form-control-sm" value="5" min="1" max="50">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-semibold">Access Passcode (Optional)</label>
                        <input type="password" name="accessPasscode" class="form-control form-control-sm" placeholder="Leave empty for public link">
                        <div class="form-text small" style="font-size: 0.75rem;">If set, recipient must provide this passcode to open the file.</div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm w-100 py-2 fw-semibold">
                        <i class="bi bi-link-45deg me-1"></i> Create Secure Ephemeral Link
                    </button>
                </form>
            </div>
        </div>

        <!-- Active Share Links Table -->
        <div class="col-lg-8">
            <div class="card smart-card bg-white">
                <div class="card-header bg-white py-3">
                    <h6 class="fw-bold mb-0"><i class="bi bi-clock-history text-primary me-2"></i>Active & Past Shared Links</h6>
                </div>
                <div class="table-responsive">
                    <table class="table smart-table mb-0">
                        <thead>
                            <tr>
                                <th>Document</th>
                                <th>Share Link</th>
                                <th>Passcode</th>
                                <th>Access Status</th>
                                <th>Expires At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${shares}" var="s">
                                <tr>
                                    <td class="fw-semibold"><c:out value="${s.documentTitle}"/></td>
                                    <td>
                                        <div class="input-group input-group-sm" style="max-width: 220px;">
                                            <input type="text" id="shareUrl_${s.id}" class="form-control font-monospace" value="${s.shareUrl}" readonly>
                                            <button class="btn btn-outline-secondary btn-copy" data-clipboard-target="#shareUrl_${s.id}">Copy</button>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.hasPasscode}"><span class="badge bg-warning text-dark"><i class="bi bi-lock-fill"></i> Protected</span></c:when>
                                            <c:otherwise><span class="badge bg-light text-dark border">Open</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border">
                                            <c:out value="${s.currentAccessCount}"/> / <c:out value="${s.maxAccessCount}"/> views
                                        </span>
                                    </td>
                                    <td class="small">
                                        <c:choose>
                                            <c:when test="${s.expired}"><span class="text-danger fw-bold">Expired</span></c:when>
                                            <c:otherwise><c:out value="${s.expiresAt}"/></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${!s.isRevoked && !s.expired}">
                                            <form action="<c:url value='/student/shares/${s.id}/revoke'/>" method="post" style="display:inline;">
                                                <button type="submit" class="btn btn-outline-danger btn-sm" onclick="return confirm('Revoke this active link?');">Revoke</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty shares}">
                                <tr><td colspan="6" class="text-center py-4 text-muted">No shared links created yet.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

