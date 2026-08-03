<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
			<c:url value="/assets/css/app.css" var="appCss" />
			<c:set var="currentUri" value="${pageContext.request.requestURI}" />
			<!DOCTYPE html>
			<html lang="vi">

			<head>
				<meta charset="UTF-8">
				<meta name="viewport" content="width=device-width,initial-scale=1">
				<title>Quản lý đồ án</title>
				<link rel="stylesheet" href="${appCss}?v=3">
			</head>

			<body>
				<div class="admin-shell">
					<aside class="admin-sidebar">
						<a class="admin-logo" href="${pageContext.request.contextPath}/dashboard"> <span
								class="admin-logo-icon">🎓</span> <span>EDU PROJECT<small
									style="color:#93c5fd;font-weight:700">GIẢNG VIÊN</small></span>
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
										<c:when test="${sessionScope.currentUser.role=='ADMIN'}">Quản trị hệ thống
										</c:when>
										<c:when test="${sessionScope.currentUser.role=='LECTURER'}">Giảng viên CNTT
										</c:when>
										<c:otherwise>Sinh viên</c:otherwise>
									</c:choose>
								</span> <small><i></i> Online</small>
							</div>
						</div>
						<nav class="admin-menu">
							<a class="${fn:endsWith(currentUri,'/dashboard') ? 'active' : ''}"
								href="${pageContext.request.contextPath}/dashboard"><span>📊</span>
								Dashboard</a>
							<c:if test="${sessionScope.currentUser.role=='ADMIN'}">
								<p>QUẢN LÝ HỆ THỐNG</p>
								<a class="${fn:contains(currentUri,'/admin/users') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/admin/users"><span>👥</span>
									Quản lý tài khoản</a>
								<a class="${fn:contains(currentUri,'/admin/classes') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/admin/classes"><span>🏫</span>
									Quản lý lớp</a>
								<a class="${fn:contains(currentUri,'/admin/semesters') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/admin/semesters"><span>▦</span>
									Quản lý học kỳ</a>
								<a class="${fn:contains(currentUri,'/admin/topics') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/admin/topics"><span>📘</span>
									Xem đề tài</a>
								<a class="${fn:contains(currentUri,'/admin/groups') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/admin/groups"><span>👥</span>
									Xem nhóm / tiến độ</a>
							</c:if>
							<c:if test="${sessionScope.currentUser.role=='LECTURER'}">
								<a class="${fn:contains(currentUri,'/topics') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/topics"><span>📘</span>
									Đề tài của tôi</a>
								<a class="${fn:contains(currentUri,'/lecturer/registrations') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/lecturer/registrations"><span>☑</span>
									Duyệt đăng ký đề tài <c:if test="${not empty stats && stats.pending_registrations > 0}"><span class="nav-badge red">${stats.pending_registrations}</span></c:if></a>
								<a class="${fn:contains(currentUri,'/groups') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/groups"><span>👥</span>
									Chi tiết nhóm hướng dẫn</a>
								<a class="${fn:contains(currentUri,'/feedbacks') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/feedbacks"><span>💬</span>
									Nhận xét</a>
								<a class="${fn:contains(currentUri,'/grades') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/grades"><span>⭐</span>
									Điểm đồ án</a>
								<a class="${fn:contains(currentUri,'/documents') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/documents"><span>▤</span>
									Tài liệu tham khảo</a>
							</c:if>
							<c:if test="${sessionScope.currentUser.role=='STUDENT'}">
								<p>QUẢN LÝ ĐỒ ÁN</p>
								<a class="${fn:contains(currentUri,'/topics') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/topics"><span>📘</span>
									Đề tài của tôi</a>
								<a class="${fn:contains(currentUri,'/groups') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/groups"><span>👥</span>
									Nhóm của tôi</a>
								<a class="${fn:contains(currentUri,'/schedule') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/schedule"><span>▦</span>
									Lịch trình</a>
								<a class="${fn:contains(currentUri,'/reports') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/reports"><span>▣</span>
									Báo cáo / Bài nộp</a>
								<a class="${fn:contains(currentUri,'/grades') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/grades"><span>✿</span>
									Đánh giá</a>
								<p>TÀI LIỆU</p>
								<a class="${fn:contains(currentUri,'/documents') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/documents"><span>▤</span>
									Tài liệu tham khảo</a>
								<a class="${fn:contains(currentUri,'/notifications') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/notifications"><span>🔔</span>
									Thông báo</a>
								<p>HỖ TRỢ</p>
								<a class="${fn:contains(currentUri,'/support') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/support"><span>?</span>
									Hướng dẫn</a>
								<a class="${fn:contains(currentUri,'/support') ? 'active' : ''}"
									href="${pageContext.request.contextPath}/support"><span>☎</span>
									Liên hệ hỗ trợ</a>
							</c:if>
						</nav>
						<a class="admin-logout" href="${pageContext.request.contextPath}/logout"><span>🚪</span>
							Đăng xuất</a>
					</aside>
					<section class="admin-main">
						<header class="admin-topbar">
							<button type="button" class="menu-toggle">☰</button>
							<div class="admin-topbar-right">
								<div class="notification-wrap">
									<div class="notification-dot" onclick="toggleNotificationDropdown(event)" title="Thông báo hệ thống" style="cursor:pointer">
										🔔<span id="notifBadgeCount">${not empty notifications ? fn:length(notifications) : '0'}</span>
									</div>
									<div class="notification-dropdown-menu" id="notifDropdown">
										<div class="notif-header">
											<strong>Thông báo hệ thống</strong>
											<span class="notif-mark-read" onclick="markAllNotifRead()">Đánh dấu đã đọc</span>
										</div>
										<div class="notif-list">
											<c:choose>
												<c:when test="${not empty notifications}">
													<c:forEach var="n" items="${notifications}" varStatus="loop">
														<c:if test="${loop.index < 4}">
															<div class="notif-item unread" onclick="location.href='${pageContext.request.contextPath}${not empty n.n_link ? n.n_link : '/dashboard'}'">
																<span class="notif-icon ${n.n_type == 'SUCCESS' ? 'green' : (n.n_type == 'GRADE' ? 'purple' : 'blue')}">
																	${n.n_type == 'SUCCESS' ? '☑' : (n.n_type == 'GRADE' ? '🎓' : '💬')}
																</span>
																<div class="notif-body">
																	<strong>${n.n_title}</strong>
																	<p>${n.n_content}</p>
																	<small>${n.n_date}</small>
																</div>
															</div>
														</c:if>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<div class="notif-item" onclick="location.href='${pageContext.request.contextPath}/dashboard'">
														<span class="notif-icon blue">🔔</span>
														<div class="notif-body">
															<strong>Thông báo hệ thống</strong>
															<p>Không có thông báo mới nào cần xử lý</p>
															<small>Vừa xong</small>
														</div>
													</div>
												</c:otherwise>
											</c:choose>
										</div>
										<div class="notif-footer">
											<a href="${pageContext.request.contextPath}/${sessionScope.currentUser.role == 'STUDENT' ? 'notifications' : 'dashboard'}">Xem tất cả thông báo →</a>
										</div>
									</div>
								</div>
								<script>
								function toggleNotificationDropdown(e) {
									e.stopPropagation();
									var dropdown = document.getElementById('notifDropdown');
									dropdown.classList.toggle('show');
								}
								function markAllNotifRead() {
									var unreads = document.querySelectorAll('.notif-item.unread');
									unreads.forEach(function(el) { el.classList.remove('unread'); });
									var badge = document.getElementById('notifBadgeCount');
									if (badge) badge.innerText = '0';
								}
								document.addEventListener('click', function(e) {
									var dropdown = document.getElementById('notifDropdown');
									if (dropdown && dropdown.classList.contains('show') && !dropdown.contains(e.target)) {
										dropdown.classList.remove('show');
									}
								});
								</script>
								<div class="topbar-semester-picker">
									<select class="semester-picker-select">
										<option>📅 Học kỳ 2, 2023 - 2024</option>
										<option>📅 Học kỳ 1, 2023 - 2024</option>
										<option>📅 Học kỳ 3, 2022 - 2023</option>
									</select>
								</div>
								<details class="account-menu">
									<summary aria-label="Mở menu tài khoản">
										<span class="top-avatar">
											<c:choose>
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
												<c:when test="${sessionScope.currentUser.role=='ADMIN'}">Quản trị viên
												</c:when>
												<c:when test="${sessionScope.currentUser.role=='LECTURER'}">Giảng viên
												</c:when>
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