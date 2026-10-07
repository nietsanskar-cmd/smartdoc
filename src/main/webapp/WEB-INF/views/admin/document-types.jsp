<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Document Catalog - NIET SDMS" scope="request"/>
<c:set var="activePage" value="documentTypes" scope="request"/>
<c:set var="pageHeader" value="Institutional Document Catalog" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-folder-check text-danger me-2"></i>Document Catalog</h4>
            <p class="text-muted small mb-0">Configure document categories, types, and validity expiration rules dynamically.</p>
        </div>
        <button class="btn btn-niet btn-sm" data-bs-toggle="modal" data-bs-target="#addDocTypeModal">
            <i class="bi bi-plus-circle me-1"></i> Add Document Type
        </button>
    </div>

    <div class="smart-card bg-white p-0">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Type Name</th>
                        <th>Category</th>
                        <th>Expiry Applicable</th>
                        <th>Default Validity</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${documentTypes}" var="dt">
                        <tr>
                            <td class="font-monospace fw-bold" style="color: var(--niet-red);"><c:out value="${dt.typeCode}"/></td>
                            <td class="fw-semibold"><c:out value="${dt.typeName}"/></td>
                            <td><span class="badge bg-light text-dark border px-2.5 py-1 rounded-pill"><c:out value="${dt.category.categoryName}"/></span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${dt.getIsExpiryApplicable() != null and dt.getIsExpiryApplicable()}">
                                        <span class="status-badge status-warning">Applicable</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-secondary">No Expiry</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${dt.defaultValidityMonths != null and dt.defaultValidityMonths > 0}">
                                        <span class="fw-semibold"><c:out value="${dt.defaultValidityMonths}"/> Months</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Permanent</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${dt.getIsActive() == null or dt.getIsActive()}">
                                        <span class="status-badge status-verified">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-rejected">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty documentTypes}">
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-folder2-open display-6 text-muted d-block mb-2"></i>
                                No document types found in the institutional catalog.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="addDocTypeModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<c:url value='/admin/document-types/create'/>" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add Document Type</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Type Code *</label>
                        <input type="text" name="typeCode" class="form-control form-control-sm" placeholder="e.g. BONAFIDE_CERT" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Type Name *</label>
                        <input type="text" name="typeName" class="form-control form-control-sm" placeholder="e.g. Bonafide Certificate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Category *</label>
                        <select name="categoryId" class="form-select form-select-sm" required>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.id}"><c:out value="${cat.categoryName}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Description</label>
                        <textarea name="description" rows="2" class="form-control form-control-sm"></textarea>
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Expiry Applicable?</label>
                            <select name="isExpiryApplicable" class="form-select form-select-sm">
                                <option value="false">No (Permanent)</option>
                                <option value="true">Yes</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Validity (Months)</label>
                            <input type="number" name="defaultValidityMonths" class="form-control form-control-sm" value="0">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-niet btn-sm"><i class="bi bi-check-lg me-1"></i> Save Document Type</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

