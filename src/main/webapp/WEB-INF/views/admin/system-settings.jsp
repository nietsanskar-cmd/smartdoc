<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="System Settings - NIET SDMS" scope="request"/>
<c:set var="activePage" value="settings" scope="request"/>
<c:set var="pageHeader" value="Institutional System Settings" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0"><i class="bi bi-gear text-primary me-2"></i>Global System Configuration</h4>
    </div>

    <div class="card smart-card bg-white">
        <div class="table-responsive">
            <table class="table smart-table mb-0">
                <thead>
                    <tr>
                        <th>Setting Key</th>
                        <th>Current Value</th>
                        <th>Description</th>
                        <th>Last Updated</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${settings}" var="s">
                        <tr>
                            <td class="font-monospace fw-bold text-primary"><c:out value="${s.settingKey}"/></td>
                            <td class="fw-semibold"><c:out value="${s.settingValue}"/></td>
                            <td class="text-muted small"><c:out value="${s.description}"/></td>
                            <td class="small text-muted"><c:out value="${s.updatedAt}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

