<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<div class="role-page-title">
	<h1>Dashboard</h1>
	<p>Chào mừng ${sessionScope.currentUser.fullName}, chúc bạn một ngày làm việc hiệu quả!</p>
</div>

<section class="admin-stat-row lecturer-stats">
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/topics">
		<div class="stat-circle">▤</div>
		<div class="stat-copy">
			<span>Đề tài của tôi</span>
			<strong>${topics.size()}</strong>
			<small>Tổng số đề tài</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card green-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle green">👥</div>
		<div class="stat-copy">
			<span>Nhóm đang hướng dẫn</span>
			<strong>${groups.size()}</strong>
			<small>Tổng số nhóm</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card orange-card" href="${pageContext.request.contextPath}/lecturer/registrations">
		<div class="stat-circle orange">☑</div>
		<div class="stat-copy">
			<span>Đăng ký chờ duyệt</span>
			<strong>${registrations.size()}</strong>
			<small>Đăng ký</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card purple-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle purple">💬</div>
		<div class="stat-copy">
			<span>Nhận xét chưa đọc</span>
			<strong>${groups.size()}</strong>
			<small>Nhận xét mới</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card cyan-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle cyan">★</div>
		<div class="stat-copy">
			<span>Chưa chấm điểm</span>
			<strong>${groups.size()}</strong>
			<small>Sinh viên</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
</section>

<section class="admin-dashboard-grid top lecturer-dashboard-grid">
	<div class="admin-panel overview-panel">
		<div class="panel-heading">
			<h2>Thống kê tiến độ nhóm</h2>
			<select class="small-filter"><option>8 tuần gần nhất</option></select>
		</div>
		<div class="chart-legend progress-legend">
			<span><i class="green-line"></i> Đúng tiến độ</span>
			<span><i class="orange-line"></i> Chậm tiến độ</span>
			<span><i class="red-line"></i> Chưa cập nhật</span>
		</div>
		<div class="line-chart teacher-chart">
			<div class="y-axis"><span>10</span><span>8</span><span>6</span><span>4</span><span>2</span><span>0</span></div>
			<div class="chart-area">
				<div class="grid-lines"></div>
				<svg viewBox="0 0 520 190" preserveAspectRatio="none" aria-label="Biểu đồ tiến độ">
					<polyline class="teacher-green" points="0,135 74,118 148,100 222,80 296,80 370,62 444,80 520,100"></polyline>
					<polyline class="teacher-orange" points="0,150 74,150 148,130 222,130 296,150 370,150 444,132 520,132"></polyline>
					<polyline class="teacher-red" points="0,170 74,170 148,170 222,170 296,170 370,156 444,170 520,170"></polyline>
				</svg>
				<div class="x-axis"><span>Tuần 1</span><span>Tuần 2</span><span>Tuần 3</span><span>Tuần 4</span><span>Tuần 5</span><span>Tuần 6</span><span>Tuần 7</span><span>Tuần 8</span></div>
			</div>
		</div>
	</div>

	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Tỷ lệ tiến độ nhóm</h2>
		</div>
		<div class="donut-wrap lecturer-donut">
			<div class="donut-chart teacher-donut"><span>58%</span></div>
			<div class="donut-legend">
				<p><i class="green-dot"></i> Đúng tiến độ <strong>${groups.size()}</strong> nhóm</p>
				<p><i class="yellow-dot"></i> Chậm tiến độ <strong>${registrations.size()}</strong> nhóm</p>
				<p><i class="red-dot"></i> Chưa cập nhật <strong>${topics.size()}</strong> nhóm</p>
			</div>
		</div>
		<p class="donut-total">Tổng cộng: ${groups.size()} nhóm</p>
	</div>
</section>

<section class="admin-dashboard-grid bottom">
	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Đăng ký đề tài chờ duyệt</h2>
			<a href="${pageContext.request.contextPath}/lecturer/registrations">Xem tất cả →</a>
		</div>
		<div class="admin-table-wrap">
			<table class="admin-data-table">
				<thead><tr><th>Nhóm</th><th>Đề tài</th><th>Ngày đăng ký</th><th>Thao tác</th></tr></thead>
				<tbody>
				<c:forEach var="r" items="${registrations}">
					<tr>
						<td><a href="${pageContext.request.contextPath}/lecturer/registrations">${r.group_name}</a></td>
						<td>${r.topic_title}</td>
						<td>${r.created_at}</td>
						<td><span class="progress-pill green">Duyệt</span> <span class="progress-pill red">Từ chối</span></td>
					</tr>
				</c:forEach>
				<c:if test="${empty registrations}">
					<tr><td colspan="4" class="table-empty">Không có đăng ký đang chờ duyệt.</td></tr>
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
				<thead><tr><th>Nhóm</th><th>Tuần</th><th>Tiêu đề báo cáo</th><th>Trạng thái</th></tr></thead>
				<tbody>
				<c:forEach var="g" items="${groups}" varStatus="loop">
					<tr>
						<td><a href="${pageContext.request.contextPath}/groups/${g.id}">${g.group_name}</a></td>
						<td>${loop.index + 1}</td>
						<td>Báo cáo tuần ${loop.index + 1}</td>
						<td>
							<c:choose>
								<c:when test="${g.status=='IN_PROGRESS'}"><span class="progress-pill green">Đúng tiến độ</span></c:when>
								<c:when test="${g.status=='REGISTERED'}"><span class="progress-pill yellow">Chậm tiến độ</span></c:when>
								<c:otherwise><span class="progress-pill red">Chưa cập nhật</span></c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty groups}">
					<tr><td colspan="4" class="table-empty">Chưa có nhóm hướng dẫn.</td></tr>
				</c:if>
				</tbody>
			</table>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>
