<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Mandatory Rules - NIET SDMS" scope="request"/>
<c:set var="activePage" value="requiredDocs" scope="request"/>
<c:set var="pageHeader" value="Document Requirement Rules Engine" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="card smart-card p-4 bg-white">
                <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-plus-circle text-primary me-2"></i>Define Mandatory Rule</h5>
                <form action="<c:url value='/admin/required-documents/create'/>" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Document Type *</label>
                        <select name="documentTypeId" class="form-select form-select-sm" required>
                            <c:forEach items="${documentTypes}" var="dt">
                                <option value="${dt.id}"><c:out value="${dt.typeName}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Target Course (Optional - All if empty)</label>
                        <select name="courseId" class="form-select form-select-sm">
                            <option value="">-- Apply to ALL Courses --</option>
                            <c:forEach items="${courses}" var="crs">
                                <option value="${crs.id}"><c:out value="${crs.courseName}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-semibold">Weightage (Completeness %)</label>
                        <input type="number" name="weightage" class="form-control form-control-sm" value="20" min="1" max="100" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm w-100 py-2 fw-semibold">Save Requirement Rule</button>
                </form>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card smart-card bg-white">
                <div class="card-header bg-white py-3">
                    <h6 class="fw-bold mb-0">Active Mandatory Rules</h6>
                </div>
                <div class="table-responsive">
                    <table class="table smart-table mb-0">
                        <thead>
                            <tr>
                                <th>Document Type</th>
                                <th>Applicable Course</th>
                                <th>Weightage</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${rules}" var="r">
                                <tr>
                                    <td class="fw-semibold"><c:out value="${r.documentType.typeName}"/></td>
                                    <td><c:out value="${r.course != null ? r.course.courseName : 'All Courses (Universal)'}"/></td>
                                    <td><span class="badge bg-primary"><c:out value="${r.weightage}"/> pts</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

