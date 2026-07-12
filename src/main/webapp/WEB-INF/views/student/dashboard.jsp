<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<div class="role-page-title">
	<h1>Dashboard</h1>
	<p>Chào mừng bạn quay trở lại!</p>
</div>

<section class="admin-stat-row student-stats">
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/topics">
		<div class="stat-circle">📄</div>
		<div class="stat-copy">
			<span>Đề tài của tôi</span>
			<strong>
				<c:choose><c:when test="${empty groups}">0</c:when><c:otherwise>1</c:otherwise></c:choose>
			</strong>
			<small>Đang thực hiện</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle">👥</div>
		<div class="stat-copy">
			<span>Nhóm của tôi</span>
			<strong>${groups.size()}</strong>
			<small>Nhóm tham gia</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle">▦</div>
		<div class="stat-copy">
			<span>Lịch trình sắp tới</span>
			<strong>2</strong>
			<small>Công việc đến hạn</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups">
		<div class="stat-circle">⇧</div>
		<div class="stat-copy">
			<span>Báo cáo đã nộp</span>
			<strong>${groups.size()}</strong>
			<small>Báo cáo</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/grades">
		<div class="stat-circle">★</div>
		<div class="stat-copy">
			<span>Điểm hiện tại</span>
			<strong>
				<c:choose><c:when test="${empty grades}">--</c:when><c:otherwise>${grades[0].score}</c:otherwise></c:choose><small class="score-scale">/10</small>
			</strong>
			<small>Điểm trung bình</small>
			<em>Xem chi tiết →</em>
		</div>
	</a>
</section>

<section class="student-main-grid">
	<div class="admin-panel project-info-card">
		<div class="panel-heading">
			<h2>Thông tin đề tài</h2>
			<span class="progress-pill blue">Đang thực hiện</span>
		</div>
		<c:choose>
			<c:when test="${not empty groups}">
				<c:set var="myGroup" value="${groups[0]}"/>
				<h3>
					<c:choose><c:when test="${not empty myGroup.topic_title}">${myGroup.topic_title}</c:when><c:otherwise>Chưa đăng ký đề tài</c:otherwise></c:choose>
				</h3>
				<span class="major-badge">Công nghệ thông tin</span>
				<dl class="project-meta">
					<dt>Nhóm hiện tại</dt><dd>${myGroup.group_name}</dd>
					<dt>Vai trò</dt><dd>${myGroup.member_role}</dd>
					<dt>Trạng thái</dt><dd>${myGroup.status}</dd>
					<dt>Mô tả ngắn</dt><dd>Theo dõi tiến độ, báo cáo, bài nộp và điểm số của nhóm.</dd>
				</dl>
				<a class="soft-button" href="${pageContext.request.contextPath}/groups/${myGroup.id}">Xem chi tiết đề tài →</a>
			</c:when>
			<c:otherwise>
				<div class="table-empty">Bạn chưa có nhóm. Hãy tạo nhóm hoặc tham gia nhóm để bắt đầu.</div>
				<a class="soft-button" href="${pageContext.request.contextPath}/groups">Tạo / tham gia nhóm →</a>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Thông tin nhóm</h2>
			<a href="${pageContext.request.contextPath}/groups">Xem chi tiết →</a>
		</div>
		<div class="team-box">
			<div class="team-header">
				<strong><c:choose><c:when test="${not empty groups}">${groups[0].group_name}</c:when><c:otherwise>Chưa có nhóm</c:otherwise></c:choose></strong>
				<span class="progress-pill green">${groups.size()} nhóm</span>
			</div>
			<ul class="member-list">
				<li><span>NV</span><strong>${sessionScope.currentUser.fullName}</strong><em>Thành viên</em></li>
				<li><span>LT</span><strong>Lê Thị B</strong><em>Thành viên</em></li>
				<li><span>PH</span><strong>Phạm Văn C</strong><em>Thành viên</em></li>
				<li><span>NH</span><strong>Nguyễn Thị D</strong><em>Thành viên</em></li>
				<li><span>HT</span><strong>Hoàng Văn E</strong><em>Thành viên</em></li>
			</ul>
		</div>
	</div>

	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Tiến độ đồ án</h2>
		</div>
		<div class="student-progress">
			<div class="progress-ring"><span>65%<small>Đang thực hiện</small></span></div>
			<div class="progress-detail">
				<h3>Tiến độ tổng thể</h3>
				<p><i class="blue-dot"></i> Hoàn thành <strong>65% (13/20)</strong></p>
				<p><i class="yellow-dot"></i> Đang thực hiện <strong>25% (5/20)</strong></p>
				<p><i class="red-dot"></i> Chưa bắt đầu <strong>10% (2/20)</strong></p>
			</div>
		</div>
		<a class="soft-button" href="${pageContext.request.contextPath}/groups">Xem chi tiết tiến độ →</a>
	</div>
</section>

<section class="admin-dashboard-grid bottom student-bottom-grid">
	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Báo cáo / Bài nộp gần nhất</h2>
			<a href="${pageContext.request.contextPath}/groups">Xem tất cả →</a>
		</div>
		<div class="admin-table-wrap">
			<table class="admin-data-table">
				<thead><tr><th>Tên báo cáo / Bài nộp</th><th>Loại</th><th>Ngày nộp</th><th>Trạng thái</th><th>Điểm</th></tr></thead>
				<tbody>
					<tr><td>📄 Báo cáo tiến độ tuần 6</td><td>Báo cáo tiến độ</td><td>05/06/2024</td><td><span class="progress-pill green">Đã nộp</span></td><td>8.5/10</td></tr>
					<tr><td>☁ Thuyết trình giữa kỳ</td><td>Bài thuyết trình</td><td>15/06/2024</td><td><span class="progress-pill blue">Đã chấm</span></td><td>8.0/10</td></tr>
					<tr><td>📄 Báo cáo tiến độ tuần 4</td><td>Báo cáo tiến độ</td><td>20/05/2024</td><td><span class="progress-pill green">Đã nộp</span></td><td>9.0/10</td></tr>
					<tr><td>📁 Đề cương chi tiết</td><td>Tài liệu</td><td>10/04/2024</td><td><span class="progress-pill blue">Đã chấm</span></td><td>9.0/10</td></tr>
				</tbody>
			</table>
		</div>
	</div>

	<div class="admin-panel">
		<div class="panel-heading">
			<h2>Lịch trình sắp tới</h2>
			<a href="${pageContext.request.contextPath}/groups">Xem tất cả →</a>
		</div>
		<div class="schedule-list">
			<div class="schedule-item"><span>▦</span><div><strong>Nộp báo cáo tiến độ tuần 8</strong><small>Tuần 8</small></div><em class="tag red">Quá hạn<br>05/06/2024</em></div>
			<div class="schedule-item"><span>▦</span><div><strong>Hoàn thành chức năng quản lý sách</strong><small>Tuần 9</small></div><em class="tag yellow">Sắp tới<br>20/06/2024</em></div>
			<div class="schedule-item"><span>▦</span><div><strong>Nộp báo cáo cuối kỳ</strong><small>Kết thúc</small></div><em class="tag green">Còn 35 ngày<br>15/07/2024</em></div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>
