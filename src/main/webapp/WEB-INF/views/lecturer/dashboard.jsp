<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>
<div class="role-page-title">
	<h1>Dashboard</h1>
	<p>Chào mừng ${sessionScope.currentUser.fullName}, chúc bạn một
		ngày làm việc hiệu quả!</p>
</div>

<section class="admin-stat-row lecturer-stats">
	<a class="admin-stat-card"
		href="${pageContext.request.contextPath}/topics"><div
			class="stat-circle">▤</div>
		<div class="stat-copy">
			<span>Đề tài của tôi</span><strong>${lecturerStats.topics}</strong><small>Tổng
				số đề tài</small><em>Xem chi tiết →</em>
		</div></a> <a class="admin-stat-card"
		href="${pageContext.request.contextPath}/groups"><div
			class="stat-circle green">👥</div>
		<div class="stat-copy">
			<span>Nhóm hướng dẫn</span><strong>${lecturerStats.groups}</strong><small>Tổng
				số nhóm</small><em>Xem chi tiết →</em>
		</div></a> <a class="admin-stat-card"
		href="${pageContext.request.contextPath}/lecturer/registrations"><div
			class="stat-circle orange">☑</div>
		<div class="stat-copy">
			<span>Đăng ký chờ duyệt</span><strong>${lecturerStats.pending_registrations}</strong><small>Đăng
				ký đang chờ</small><em>Xem chi tiết →</em>
		</div></a> <a class="admin-stat-card"
		href="${pageContext.request.contextPath}/groups"><div
			class="stat-circle purple">💬</div>
		<div class="stat-copy">
			<span>Nhận xét đã gửi</span><strong>${lecturerStats.feedbacks}</strong><small>Tổng
				nhận xét</small><em>Xem chi tiết →</em>
		</div></a> <a class="admin-stat-card"
		href="${pageContext.request.contextPath}/groups"><div
			class="stat-circle cyan">★</div>
		<div class="stat-copy">
			<span>Chưa chấm điểm</span><strong>${lecturerStats.ungraded_students}</strong><small>Sinh
				viên</small><em>Xem chi tiết →</em>
		</div></a>
</section>

<section class="admin-dashboard-grid top lecturer-dashboard-grid">
	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Tình trạng báo cáo của các nhóm hướng dẫn</h2>
		</div>
		<div class="status-summary">
			<p>
				<span class="green-dot"></span> Đã nhận xét <strong>${reportStatus.reviewed}</strong>
			</p>
			<p>
				<span class="yellow-dot"></span> Đã nộp, chờ nhận xét <strong>${reportStatus.submitted}</strong>
			</p>
			<p>
				<span class="red-dot"></span> Chưa có báo cáo <strong>${reportStatus.no_report}</strong>
			</p>
		</div>
	</div>
	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Tổng quan hướng dẫn</h2>
		</div>
		<div class="status-summary">
			<p>
				Nhóm được phân công <strong>${lecturerStats.groups}</strong>
			</p>
			<p>
				Đề tài đang quản lý <strong>${lecturerStats.topics}</strong>
			</p>
			<p>
				Sinh viên chưa chấm <strong>${lecturerStats.ungraded_students}</strong>
			</p>
		</div>
	</div>
</section>

<section class="admin-dashboard-grid bottom">
	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Đăng ký đề tài chờ duyệt</h2>
			<a href="${pageContext.request.contextPath}/lecturer/registrations">Xem
				tất cả →</a>
		</div>
		<div class="admin-table-wrap">
			<table class="admin-data-table">
				<thead>
					<tr>
						<th>Nhóm</th>
						<th>Đề tài</th>
						<th>Ngày đăng ký</th>
						<th>Trạng thái</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="r" items="${registrations}">
						<c:if test="${r.status=='PENDING'}">
							<tr>
								<td>${r.group_name}</td>
								<td>${r.topic_title}</td>
								<td>${r.created_at}</td>
								<td><span class="progress-pill yellow">Chờ duyệt</span></td>
							</tr>
						</c:if>
					</c:forEach>
					<c:if test="${lecturerStats.pending_registrations==0}">
						<tr>
							<td colspan="4" class="table-empty">Không có đăng ký chờ
								duyệt.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Báo cáo tiến độ mới nhất</h2>
			<a href="${pageContext.request.contextPath}/groups">Xem tất cả →</a>
		</div>
		<div class="admin-table-wrap">
			<table class="admin-data-table">
				<thead>
					<tr>
						<th>Nhóm</th>
						<th>Tuần</th>
						<th>Tiêu đề</th>
						<th>Ngày nộp</th>
						<th>Trạng thái</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="report" items="${recentReports}">
						<tr>
							<td><a
								href="${pageContext.request.contextPath}/groups/${report.id}">${report.group_name}</a></td>
							<td>${report.week_number}</td>
							<td>${report.title}</td>
							<td>${report.report_date}</td>
							<td><span class="progress-pill blue">${report.status}</span></td>
						</tr>
					</c:forEach>
					<c:if test="${empty recentReports}">
						<tr>
							<td colspan="5" class="table-empty">Chưa có báo cáo tiến độ.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
</section>
<%@ include file="../common/footer.jsp"%>
