<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>
<div class="role-page-title"><h1>Dashboard</h1><p>Chào mừng ${sessionScope.currentUser.fullName} quay trở lại!</p></div>

<section class="admin-stat-row student-stats">
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/topics"><div class="stat-circle">📄</div><div class="stat-copy"><span>Đề tài của tôi</span><strong><c:choose><c:when test="${empty groups}">0</c:when><c:otherwise>1</c:otherwise></c:choose></strong><small>Đề tài đã gắn với nhóm</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups"><div class="stat-circle">👥</div><div class="stat-copy"><span>Nhóm của tôi</span><strong>${studentStats.group_count}</strong><small>Nhóm tham gia</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups"><div class="stat-circle">▦</div><div class="stat-copy"><span>Báo cáo tiến độ</span><strong>${studentStats.report_count}</strong><small>Báo cáo đã tạo</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/groups"><div class="stat-circle">⇧</div><div class="stat-copy"><span>Bài nộp</span><strong>${studentStats.submission_count}</strong><small>Tệp đã nộp</small><em>Xem chi tiết →</em></div></a>
	<a class="admin-stat-card" href="${pageContext.request.contextPath}/grades"><div class="stat-circle">★</div><div class="stat-copy"><span>Điểm hiện tại</span><strong><c:choose><c:when test="${empty studentStats.average_score}">--</c:when><c:otherwise>${studentStats.average_score}</c:otherwise></c:choose><small class="score-scale">/10</small></strong><small>Trung bình điểm công bố</small><em>Xem chi tiết →</em></div></a>
</section>

<section class="student-main-grid">
	<div class="admin-panel project-info-card"><div class="panel-heading"><h2>Thông tin đề tài</h2></div><c:choose><c:when test="${not empty groups}"><c:set var="myGroup" value="${groups[0]}"/><h3><c:choose><c:when test="${not empty myGroup.topic_title}">${myGroup.topic_title}</c:when><c:otherwise>Chưa được duyệt đề tài</c:otherwise></c:choose></h3><dl class="project-meta"><dt>Nhóm hiện tại</dt><dd>${myGroup.group_name}</dd><dt>Vai trò</dt><dd>${myGroup.member_role}</dd><dt>Trạng thái</dt><dd>${myGroup.status}</dd></dl><a class="soft-button" href="${pageContext.request.contextPath}/groups/${myGroup.id}">Xem chi tiết nhóm →</a></c:when><c:otherwise><p class="table-empty">Bạn chưa thuộc nhóm nào.</p><a class="soft-button" href="${pageContext.request.contextPath}/groups">Tạo / tham gia nhóm →</a></c:otherwise></c:choose></div>
	<div class="admin-panel"><div class="panel-heading"><h2>Thành viên nhóm</h2><a href="${pageContext.request.contextPath}/groups">Xem chi tiết →</a></div><c:choose><c:when test="${not empty members}"><ul class="member-list"><c:forEach var="member" items="${members}"><li><span>SV</span><strong>${member.full_name}</strong><em>${member.role}</em></li></c:forEach></ul></c:when><c:otherwise><p class="table-empty">Chưa có thành viên nhóm.</p></c:otherwise></c:choose></div>
	<div class="admin-panel"><div class="panel-heading"><h2>Tiến độ báo cáo</h2></div><div class="status-summary"><p><span class="green-dot"></span> Đã nhận xét <strong>${reportStatus.reviewed}</strong></p><p><span class="yellow-dot"></span> Đã nộp chờ nhận xét <strong>${reportStatus.submitted}</strong></p><p>Tổng báo cáo của nhóm <strong>${reportStatus.total}</strong></p></div><a class="soft-button" href="${pageContext.request.contextPath}/groups">Xem báo cáo tiến độ →</a></div>
</section>

<section class="admin-dashboard-grid bottom student-bottom-grid">
	<div class="admin-panel"><div class="panel-heading"><h2>Báo cáo / Bài nộp gần nhất</h2><a href="${pageContext.request.contextPath}/groups">Xem tất cả →</a></div><div class="admin-table-wrap"><table class="admin-data-table"><thead><tr><th>Tên</th><th>Loại</th><th>Ngày tạo/nộp</th><th>Trạng thái</th></tr></thead><tbody>
		<c:forEach var="item" items="${recentItems}"><tr><td>${item.item_name}</td><td>${item.item_type}</td><td>${item.item_date}</td><td><span class="progress-pill blue">${item.item_status}</span></td></tr></c:forEach>
		<c:if test="${empty recentItems}"><tr><td colspan="4" class="table-empty">Chưa có báo cáo hoặc bài nộp.</td></tr></c:if>
	</tbody></table></div></div>
	<div class="admin-panel"><div class="panel-heading"><h2>Mốc thời gian học kỳ</h2></div><div class="schedule-list"><c:forEach var="milestone" items="${milestones}"><div class="schedule-item"><span>▦</span><div><strong>${milestone.milestone_name}</strong><small>Dữ liệu từ học kỳ của nhóm</small></div><em class="tag blue">${milestone.milestone_date}</em></div></c:forEach><c:if test="${empty milestones}"><p class="table-empty">Chưa có mốc thời gian học kỳ cho nhóm.</p></c:if></div></div>
</section>
<%@ include file="../common/footer.jsp"%>
