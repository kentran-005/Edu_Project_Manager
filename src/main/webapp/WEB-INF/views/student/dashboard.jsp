<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Role Page Title -->
<div class="role-page-title">
	<h1>Dashboard Sinh viên</h1>
	<p>Chào mừng <strong>${sessionScope.currentUser.fullName}</strong> quay trở lại hệ thống quản lý đồ án!</p>
</div>

<!-- 5 Stat Cards Row -->
<section class="admin-stat-row student-stats">
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/topics">
		<div class="stat-circle">📄</div>
		<div class="stat-copy">
			<span>Đề tài của tôi</span>
			<strong>${empty groups ? '0' : '1'}</strong>
			<small>Đề tài đã gắn với nhóm</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle green">👥</div>
		<div class="stat-copy">
			<span>Nhóm của tôi</span>
			<strong>${not empty studentStats.group_count ? studentStats.group_count : 0}</strong>
			<small>Nhóm tham gia</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle orange">▦</div>
		<div class="stat-copy">
			<span>Báo cáo tiến độ</span>
			<strong>${not empty studentStats.report_count ? studentStats.report_count : 0}</strong>
			<small>Báo cáo đã tạo</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle purple">⇧</div>
		<div class="stat-copy">
			<span>Bài nộp</span>
			<strong>${not empty studentStats.submission_count ? studentStats.submission_count : 0}</strong>
			<small>Tệp đã nộp Cloudinary</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/grades">
		<div class="stat-circle cyan">★</div>
		<div class="stat-copy">
			<span>Điểm hiện tại</span>
			<strong>
				${empty studentStats.average_score ? '--' : studentStats.average_score}
				<small class="score-scale">/10</small>
			</strong>
			<small>Trung bình điểm công bố</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
</section>

<!-- Student Main 3-Column Grid -->
<section class="student-main-grid">
	<!-- Project Info Card -->
	<div class="admin-panel project-info-card" style="border-radius:16px;">
		<div class="panel-heading">
			<h2>Thông tin đề tài</h2>
		</div>
		<c:choose>
			<c:when test="${not empty groups}">
				<c:set var="myGroup" value="${groups[0]}"/>
				<h3 style="color:#1d4ed8; font-size:18px; margin:0 0 12px;">
					${not empty myGroup.topic_title ? myGroup.topic_title : 'Chưa được duyệt đề tài'}
				</h3>
				<dl class="project-meta">
					<dt>Nhóm hiện tại</dt>
					<dd><strong style="color:#0f172a;">${myGroup.group_name}</strong></dd>
					<dt>Vai trò</dt>
					<dd><span class="tag blue">${myGroup.member_role}</span></dd>
					<dt>Trạng thái</dt>
					<dd><span class="status-pill green">${myGroup.status}</span></dd>
				</dl>
				<a class="btn-add-primary" style="font-size:13px; text-decoration:none;" href="${pageContext.request.contextPath}/groups/${myGroup.id}">
					Xem chi tiết nhóm →
				</a>
			</c:when>
			<c:otherwise>
				<p class="table-empty">Bạn chưa thuộc nhóm nào trong học kỳ này.</p>
				<a class="btn-add-primary" style="font-size:13px; text-decoration:none;" href="${pageContext.request.contextPath}/groups">
					Tạo / tham gia nhóm →
				</a>
			</c:otherwise>
		</c:choose>
	</div>

	<!-- Team Members Card -->
	<div class="admin-panel" style="border-radius:16px;">
		<div class="panel-heading">
			<h2>Thành viên nhóm</h2>
			<a href="${pageContext.request.contextPath}/groups">Xem chi tiết →</a>
		</div>
		<c:choose>
			<c:when test="${not empty members}">
				<ul class="member-list">
					<c:forEach var="member" items="${members}">
						<li>
							<span>SV</span>
							<strong>${member.full_name}</strong>
							<em>${member.role}</em>
						</li>
					</c:forEach>
				</ul>
			</c:when>
			<c:otherwise>
				<p class="table-empty">Chưa có thành viên nhóm.</p>
			</c:otherwise>
		</c:choose>
	</div>

	<!-- Progress Summary Card -->
	<div class="admin-panel" style="border-radius:16px;">
		<div class="panel-heading">
			<h2>Tiến độ báo cáo</h2>
		</div>
		<div class="status-summary">
			<p><span class="green-dot"></span> Đã nhận xét <strong>${not empty reportStatus.reviewed ? reportStatus.reviewed : 0}</strong></p>
			<p><span class="yellow-dot"></span> Đã nộp chờ nhận xét <strong>${not empty reportStatus.submitted ? reportStatus.submitted : 0}</strong></p>
			<p>Tổng báo cáo của nhóm <strong>${not empty reportStatus.total ? reportStatus.total : 0}</strong></p>
		</div>
		<div style="margin-top:16px;">
			<a class="btn-filter" style="width:100%; justify-content:center; text-decoration:none;" href="${pageContext.request.contextPath}/groups">
				Xem báo cáo tiến độ →
			</a>
		</div>
	</div>
</section>

<!-- Bottom Grid: Recent Items & Milestones -->
<section class="admin-dashboard-grid bottom student-bottom-grid">
	<div class="admin-panel" style="border-radius:16px;">
		<div class="panel-heading">
			<h2>Báo cáo / Bài nộp gần nhất</h2>
			<a href="${pageContext.request.contextPath}/groups">Xem tất cả →</a>
		</div>
		<div class="admin-table-wrap">
			<table class="admin-data-table">
				<thead>
					<tr>
						<th>Tên</th>
						<th>Loại</th>
						<th>Ngày tạo/nộp</th>
						<th>Trạng thái</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="item" items="${recentItems}">
						<tr>
							<td><strong>${item.item_name}</strong></td>
							<td><span class="tag blue">${item.item_type}</span></td>
							<td><span style="font-size:12px; color:#64748b;">${item.item_date}</span></td>
							<td><span class="status-pill green">${item.item_status}</span></td>
						</tr>
					</c:forEach>
					<c:if test="${empty recentItems}">
						<tr>
							<td colspan="4" class="table-empty">Chưa có báo cáo hoặc bài nộp nào.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>

	<div class="admin-panel" style="border-radius:16px;">
		<div class="panel-heading">
			<h2>Mốc thời gian học kỳ</h2>
		</div>
		<div class="schedule-list">
			<c:forEach var="milestone" items="${milestones}">
				<div class="schedule-item">
					<span>▦</span>
					<div>
						<strong>${milestone.milestone_name}</strong>
						<small>Dữ liệu từ học kỳ của nhóm</small>
					</div>
					<em class="tag blue">${milestone.milestone_date}</em>
				</div>
			</c:forEach>
			<c:if test="${empty milestones}">
				<p class="table-empty">Chưa có mốc thời gian học kỳ cho nhóm.</p>
			</c:if>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp" %>

