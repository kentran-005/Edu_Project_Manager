<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<c:url value="/assets/css/app.css" var="appCss" />
<c:set var="currentUri" value="${pageContext.request.requestURI}" />
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý đồ án</title>
<link rel="stylesheet" href="${appCss}">
</head>
<body>
	<div class="admin-shell">
		<aside class="admin-sidebar">
			<a class="admin-logo"
				href="${pageContext.request.contextPath}/dashboard"> <span
				class="admin-logo-icon">▰</span> <span>EDU PROJECT<small>MANAGER</small></span>
			</a>
			<div class="admin-profile">
				<div class="admin-avatar">
					<c:choose>
						<c:when test="${sessionScope.currentUser.role=='LECTURER'}">GV</c:when>
						<c:when test="${sessionScope.currentUser.role=='STUDENT'}">SV</c:when>
						<c:otherwise>A</c:otherwise>
					</c:choose>
				</div>
				<div>
					<strong>${sessionScope.currentUser.fullName}</strong> <span>
						<c:choose>
							<c:when test="${sessionScope.currentUser.role=='ADMIN'}">Quản trị hệ thống</c:when>
							<c:when test="${sessionScope.currentUser.role=='LECTURER'}">Giảng viên hướng dẫn</c:when>
							<c:otherwise>Sinh viên</c:otherwise>
						</c:choose>
					</span> <small><i></i> Online</small>
				</div>
			</div>
			<nav class="admin-menu">
				<a class="${fn:endsWith(currentUri,'/dashboard') ? 'active' : ''}"
					href="${pageContext.request.contextPath}/dashboard"><span>⌂</span>
					Dashboard</a>
				<c:if test="${sessionScope.currentUser.role=='ADMIN'}">
					<p>QUẢN LÝ HỆ THỐNG</p>
					<a
						class="${fn:contains(currentUri,'/admin/users') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/admin/users"><span>👥</span>
						Quản lý tài khoản</a>
					<a
						class="${fn:contains(currentUri,'/admin/classes') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/admin/classes"><span>🏫</span>
						Quản lý lớp</a>
					<a
						class="${fn:contains(currentUri,'/admin/semesters') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/admin/semesters"><span>▦</span>
						Quản lý học kỳ</a>
					<a class="${fn:contains(currentUri,'/topics') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/topics"><span>▤</span>
						Xem đề tài</a>
					<a class="${fn:contains(currentUri,'/groups') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/groups"><span>👥</span>
						Xem nhóm / tiến độ</a>
				</c:if>
				<c:if test="${sessionScope.currentUser.role=='LECTURER'}">
					<a class="${fn:contains(currentUri,'/topics') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/topics"><span>▤</span>
						Đề tài của tôi</a>
					<a
						class="${fn:contains(currentUri,'/lecturer/registrations') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/lecturer/registrations"><span>☑</span>
						Duyệt đăng ký đề tài</a>
					<a class="${fn:contains(currentUri,'/groups') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/groups"><span>👥</span>
						Chi tiết nhóm hướng dẫn</a>
					<a href="${pageContext.request.contextPath}/groups"><span>💬</span>
						Nhận xét</a>
					<a href="${pageContext.request.contextPath}/groups"><span>☆</span>
						Chấm điểm</a>
				</c:if>
				<c:if test="${sessionScope.currentUser.role=='STUDENT'}">
					<p>QUẢN LÝ ĐỒ ÁN</p>
					<a class="${fn:contains(currentUri,'/topics') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/topics"><span>▤</span>
						Đề tài của tôi</a>
					<a class="${fn:contains(currentUri,'/groups') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/groups"><span>👥</span>
						Nhóm của tôi</a>
					<a href="${pageContext.request.contextPath}/groups"><span>▦</span>
						Lịch trình</a>
					<a href="${pageContext.request.contextPath}/groups"><span>▣</span>
						Báo cáo / Bài nộp</a>
					<a class="${fn:contains(currentUri,'/grades') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/grades"><span>✿</span>
						Đánh giá</a>
					<p>TÀI LIỆU</p>
					<a href="${pageContext.request.contextPath}/topics"><span>▤</span>
						Tài liệu tham khảo</a>
					<a href="${pageContext.request.contextPath}/dashboard"><span>🔔</span>
						Thông báo</a>
					<p>HỖ TRỢ</p>
					<a href="${pageContext.request.contextPath}/dashboard"><span>?</span>
						Hướng dẫn</a>
					<a href="${pageContext.request.contextPath}/dashboard"><span>☎</span>
						Liên hệ hỗ trợ</a>
				</c:if>
			</nav>
			<a class="admin-logout"
				href="${pageContext.request.contextPath}/logout"><span>↪</span>
				Đăng xuất</a>
		</aside>
		<section class="admin-main">
			<header class="admin-topbar">
				<button type="button" class="menu-toggle">☰</button>
				<div class="admin-topbar-right">
					<div class="notification-dot" title="Thông báo">🔔</div>
					<details class="account-menu">
						<summary aria-label="Mở menu tài khoản">
							<span class="top-avatar"> <c:choose>
									<c:when test="${sessionScope.currentUser.role=='LECTURER'}">GV</c:when>
									<c:when test="${sessionScope.currentUser.role=='STUDENT'}">SV</c:when>
									<c:otherwise>A</c:otherwise>
								</c:choose>
							</span> <span class="account-name">${sessionScope.currentUser.fullName}</span>
							<span class="account-chevron">⌄</span>
						</summary>
						<div class="account-dropdown">
							<strong>${sessionScope.currentUser.fullName}</strong> <small>
								<c:choose>
									<c:when test="${sessionScope.currentUser.role=='ADMIN'}">Quản trị viên</c:when>
									<c:when test="${sessionScope.currentUser.role=='LECTURER'}">Giảng viên</c:when>
									<c:otherwise>Sinh viên</c:otherwise>
								</c:choose>
							</small> <a href="${pageContext.request.contextPath}/logout"><span>↪</span>
								Đăng xuất</a>
						</div>
					</details>
				</div>
			</header>
			<main class="admin-content">
				<c:if test="${not empty error}">
					<div class="error">${error}</div>
				</c:if>
				<c:if test="${not empty message}">
					<div class="success-message">${message}</div>
				</c:if>