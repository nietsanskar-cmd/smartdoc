<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Notifications - NIET SDMS" scope="request"/>
<c:set var="pageHeader" value="Notification Inbox" scope="request"/>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="smart-content">
    <jsp:include page="../common/alerts.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0"><i class="bi bi-bell text-primary me-2"></i>My Notifications</h4>
        <form action="<c:url value='/notifications/read-all'/>" method="post">
            <button type="submit" class="btn btn-outline-secondary btn-sm"><i class="bi bi-check2-all"></i> Mark All as Read</button>
        </form>
    </div>

    <div class="card smart-card bg-white p-0">
        <div class="list-group list-group-flush">
            <c:forEach items="${notifications}" var="notif">
                <div class="list-group-item p-3 ${notif.isRead ? '' : 'bg-light'}">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h6 class="fw-bold mb-1 ${notif.isRead ? 'text-secondary' : 'text-primary'}">
                                <c:out value="${notif.title}"/>
                            </h6>
                            <p class="mb-1 text-dark small"><c:out value="${notif.message}"/></p>
                            <small class="text-muted"><c:out value="${notif.createdAt}"/></small>
                        </div>
                        <div>
                            <c:if test="${not empty notif.linkUrl}">
                                <a href="<c:url value='${notif.linkUrl}'/>" class="btn btn-outline-primary btn-sm me-2">View</a>
                            </c:if>
                            <c:if test="${!notif.isRead}">
                                <form action="<c:url value='/notifications/${notif.id}/read'/>" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-light btn-sm border"><i class="bi bi-check2"></i></button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty notifications}">
                <div class="p-5 text-center text-muted">
                    <i class="bi bi-bell-slash fs-2 mb-2"></i>
                    <p class="mb-0">No notifications in your inbox.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

