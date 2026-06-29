<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url value="/assets/css/app.css" var="appCss"/>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý đồ án</title>
<link rel="stylesheet" href="${appCss}"></head><body>
<nav><strong>Edu Project</strong><div>
<a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
<a href="${pageContext.request.contextPath}/topics">Đề tài</a>
<a href="${pageContext.request.contextPath}/groups">Nhóm</a>
<c:if test="${sessionScope.currentUser.role=='ADMIN'}">
<a href="${pageContext.request.contextPath}/admin/users">Tài khoản</a>
<a href="${pageContext.request.contextPath}/admin/classes">Lớp</a>
<a href="${pageContext.request.contextPath}/admin/semesters">Học kỳ</a></c:if>
<c:if test="${sessionScope.currentUser.role=='LECTURER'}">
<a href="${pageContext.request.contextPath}/lecturer/registrations">Duyệt đăng ký</a></c:if>
<c:if test="${sessionScope.currentUser.role=='STUDENT'}">
<a href="${pageContext.request.contextPath}/grades">Điểm</a></c:if>
<a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
</div></nav><main class="container">
<c:if test="${not empty error}"><div class="error">${error}</div></c:if>
