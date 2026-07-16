<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<div class="admin-page-title"><h1>Dashboard</h1></div>

<section class="admin-stat-row">
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/admin/users"><div class="stat-circle">👥</div><div class="stat-copy"><span>Tài khoản</span><strong>${stats.students + stats.lecturers}</strong><small>Tổng sinh viên và giảng viên</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/admin/classes"><div class="stat-circle">🎓</div><div class="stat-copy"><span>Lớp học</span><strong>${stats.classes}</strong><small>Tổng số lớp</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/admin/semesters"><div class="stat-circle">▦</div><div class="stat-copy"><span>Học kỳ</span><strong>${stats.semesters}</strong><small>Tổng số học kỳ</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/topics"><div class="stat-circle">📄</div><div class="stat-copy"><span>Đề tài</span><strong>${stats.topics}</strong><small>Tổng số đề tài</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups"><div class="stat-circle">👥</div><div class="stat-copy"><span>Nhóm dự án</span><strong>${stats.groups}</strong><small>Tổng số nhóm</small><em>Xem chi tiết →</em></div></a>
</section>

<section class="admin-dashboard-grid top">
	<div class="admin-panel">
		<div class="panel-heading"><h2>Tình trạng nhóm dự án</h2><span class="muted">Tổng: ${groupStatus.total} nhóm</span></div>
		<div class="status-summary">
			<p><span class="blue-dot"></span> Đang thực hiện <strong>${groupStatus.in_progress}</strong></p>
			<p><span class="green-dot"></span> Hoàn thành <strong>${groupStatus.completed}</strong></p>
			<p><span class="yellow-dot"></span> Đã đăng ký chờ triển khai <strong>${groupStatus.registered}</strong></p>
			<p><span class="red-dot"></span> Đang tạo nhóm <strong>${groupStatus.forming}</strong></p>
		</div>
	</div>
	<div class="admin-panel">
		<div class="panel-heading"><h2>Dữ liệu thực tế</h2></div>
		<div class="status-summary">
			<p>Báo cáo tiến độ <strong>${stats.reports}</strong></p>
			<p>Bài nộp tệp <strong>${stats.submissions}</strong></p>
			<p>Đề tài đã phân công <strong>${groupStatus.in_progress + groupStatus.completed}</strong></p>
		</div>
		<p class="muted">Các số liệu được truy vấn trực tiếp từ SQL Server khi mở trang.</p>
	</div>
</section>

<section class="admin-dashboard-grid bottom">
	<div class="admin-panel">
		<div class="panel-heading"><h2>Hoạt động gần đây</h2></div>
		<div class="activity-list">
			<c:forEach var="item" items="${activities}">
				<div class="activity-item"><span class="activity-icon blue">●</span><div><strong>${item.activity_name}</strong><small>${item.occurred_at}</small></div><em class="tag blue">${item.activity_type}</em></div>
			</c:forEach>
			<c:if test="${empty activities}"><p class="table-empty">Chưa phát sinh hoạt động.</p></c:if>
		</div>
	</div>
	<div class="admin-panel">
		<div class="panel-heading"><h2>Báo cáo tiến độ cập nhật gần đây</h2><a href="${pageContext.request.contextPath}/groups">Xem tất cả →</a></div>
		<div class="admin-table-wrap"><table class="admin-data-table"><thead><tr><th>Nhóm</th><th>Đề tài</th><th>Tuần</th><th>Trạng thái</th><th>Cập nhật</th></tr></thead><tbody>
			<c:forEach var="report" items="${recentReports}"><tr><td><a href="${pageContext.request.contextPath}/groups/${report.id}">${report.group_name}</a></td><td>${report.topic_title}</td><td>${report.week_number}</td><td><span class="progress-pill blue">${report.report_status}</span></td><td>${report.updated_at}</td></tr></c:forEach>
			<c:if test="${empty recentReports}"><tr><td colspan="5" class="table-empty">Chưa có báo cáo tiến độ.</td></tr></c:if>
		</tbody></table></div>
	</div>
</section>
<%@ include file="../common/footer.jsp"%>
