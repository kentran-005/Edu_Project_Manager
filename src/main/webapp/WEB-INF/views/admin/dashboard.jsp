<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<div class="admin-page-title">
	<h1>Dashboard</h1>
</div>

<section class="admin-stat-row">
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/admin/users">
		<div class="stat-circle">👥</div>
		<div class="stat-copy">
			<span>Tài khoản</span>
			<strong>${stats.students + stats.lecturers}</strong>
			<small>Tổng số tài khoản</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/admin/classes">
		<div class="stat-circle">🎓</div>
		<div class="stat-copy">
			<span>Lớp học</span>
			<strong>${stats.classes}</strong>
			<small>Tổng số lớp</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/admin/semesters">
		<div class="stat-circle">▦</div>
		<div class="stat-copy">
			<span>Học kỳ</span>
			<strong>${stats.semesters}</strong>
			<small>Tổng số học kỳ</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/topics">
		<div class="stat-circle">📄</div>
		<div class="stat-copy">
			<span>Đề tài</span>
			<strong>${stats.topics}</strong>
			<small>Tổng số đề tài</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle">👥</div>
		<div class="stat-copy">
			<span>Nhóm dự án</span>
			<strong>${stats.groups}</strong>
			<small>Tổng số nhóm</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
</section>

<section class="admin-dashboard-grid top">
	<div class="admin-panel overview-panel">
		<div class="panel-heading">
			<h2>Thống kê tổng quan</h2>
			<div class="chart-legend">
				<span><i class="solid"></i> Nhóm dự án</span>
				<span><i class="dash"></i> Đề tài</span>
			</div>
		</div>
		<div class="line-chart">
			<div class="y-axis"><span>50</span><span>40</span><span>30</span><span>20</span><span>10</span><span>0</span></div>
			<div class="chart-area">
				<div class="grid-lines"></div>
				<svg viewBox="0 0 520 190" preserveAspectRatio="none" aria-label="Biểu đồ thống kê">
					<polyline class="line-fill" points="0,158 47,140 94,118 141,118 188,92 235,75 282,66 329,34 376,74 423,88 470,122 520,145"></polyline>
					<polyline class="line-main" points="0,158 47,140 94,118 141,118 188,92 235,75 282,66 329,34 376,74 423,88 470,122 520,145"></polyline>
					<polyline class="line-secondary" points="0,180 47,165 94,150 141,143 188,122 235,115 282,96 329,100 376,124 423,130 470,150 520,170"></polyline>
					<g class="points">
						<circle cx="0" cy="158"/><circle cx="47" cy="140"/><circle cx="94" cy="118"/><circle cx="141" cy="118"/>
						<circle cx="188" cy="92"/><circle cx="235" cy="75"/><circle cx="282" cy="66"/><circle cx="329" cy="34"/>
						<circle cx="376" cy="74"/><circle cx="423" cy="88"/><circle cx="470" cy="122"/><circle cx="520" cy="145"/>
					</g>
				</svg>
				<div class="x-axis"><span>T1</span><span>T2</span><span>T3</span><span>T4</span><span>T5</span><span>T6</span><span>T7</span><span>T8</span><span>T9</span><span>T10</span><span>T11</span><span>T12</span></div>
			</div>
		</div>
	</div>

	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Tình trạng nhóm dự án</h2>
		</div>
		<div class="donut-wrap">
			<div class="donut-chart">
				<span>42%</span>
			</div>
			<div class="donut-legend">
				<p><i class="blue-dot"></i> Đang thực hiện <strong>${stats.groups}</strong> nhóm</p>
				<p><i class="green-dot"></i> Đúng tiến độ <strong>${stats.reports}</strong> báo cáo</p>
				<p><i class="yellow-dot"></i> Chậm tiến độ <strong>${stats.submissions}</strong> bài nộp</p>
				<p><i class="red-dot"></i> Chưa bắt đầu <strong>${stats.semesters}</strong> học kỳ</p>
			</div>
		</div>
	</div>
</section>

<section class="admin-dashboard-grid bottom">
	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Hoạt động gần đây</h2>
		</div>
		<div class="activity-list">
			<div class="activity-item">
				<span class="activity-icon blue">👤</span>
				<div><strong>Quản trị viên đã cập nhật tài khoản</strong><small>2 phút trước</small></div>
				<em class="tag blue">Tài khoản</em>
			</div>
			<div class="activity-item">
				<span class="activity-icon green">🏫</span>
				<div><strong>Dữ liệu lớp học đã được đồng bộ</strong><small>15 phút trước</small></div>
				<em class="tag green">Lớp học</em>
			</div>
			<div class="activity-item">
				<span class="activity-icon yellow">📄</span>
				<div><strong>Có đề tài mới được thêm vào hệ thống</strong><small>1 giờ trước</small></div>
				<em class="tag yellow">Đề tài</em>
			</div>
			<div class="activity-item">
				<span class="activity-icon purple">👥</span>
				<div><strong>Nhóm sinh viên đã nộp báo cáo tiến độ</strong><small>2 giờ trước</small></div>
				<em class="tag purple">Tiến độ</em>
			</div>
		</div>
		<a class="see-more" href="${pageContext.request.contextPath}/groups">Xem tất cả hoạt động →</a>
	</div>

	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Nhóm dự án mới cập nhật tiến độ</h2>
			<a href="${pageContext.request.contextPath}/groups">Xem tất cả →</a>
		</div>
		<div class="admin-table-wrap">
			<table class="admin-data-table">
				<thead>
				<tr>
					<th>Tên nhóm</th>
					<th>Đề tài</th>
					<th>Tuần</th>
					<th>Tiến độ</th>
					<th>Cập nhật lúc</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="g" items="${groups}" varStatus="loop">
					<tr>
						<td><a href="${pageContext.request.contextPath}/groups/${g.id}">${g.group_name}</a></td>
						<td>
							<c:choose>
								<c:when test="${not empty g.topic_title}">${g.topic_title}</c:when>
								<c:otherwise>Chưa có đề tài</c:otherwise>
							</c:choose>
						</td>
						<td>${loop.index + 1}</td>
						<td>
							<c:choose>
								<c:when test="${g.status=='IN_PROGRESS'}"><span class="progress-pill blue">Đang thực hiện</span></c:when>
								<c:when test="${g.status=='COMPLETED'}"><span class="progress-pill green">Đúng tiến độ</span></c:when>
								<c:when test="${g.status=='REGISTERED'}"><span class="progress-pill yellow">Chậm tiến độ</span></c:when>
								<c:otherwise><span class="progress-pill red">Chưa bắt đầu</span></c:otherwise>
							</c:choose>
						</td>
						<td>${g.created_at}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty groups}">
					<tr><td colspan="5" class="table-empty">Chưa có nhóm dự án nào.</td></tr>
				</c:if>
				</tbody>
			</table>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>
