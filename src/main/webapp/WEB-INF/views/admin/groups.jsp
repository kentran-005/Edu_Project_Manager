<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Xem nhóm / tiến độ</h1>
		<p>Theo dõi hoạt động và tiến độ các nhóm dự án</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-add-primary" onclick="window.print()">📥 Xuất báo cáo</button>
	</div>
</div>

<!-- 4 Stats Cards Grid -->
<c:set var="totalGroups" value="${fn:length(groups)}" />
<c:set var="inProgressGroups" value="0" />
<c:set var="warningGroups" value="0" />
<c:set var="completedGroups" value="0" />
<c:forEach var="g" items="${groups}">
	<c:choose>
		<c:when test="${g.status == 'COMPLETED'}"><c:set var="completedGroups" value="${completedGroups + 1}" /></c:when>
		<c:when test="${g.status == 'FORMING'}"><c:set var="warningGroups" value="${warningGroups + 1}" /></c:when>
		<c:otherwise><c:set var="inProgressGroups" value="${inProgressGroups + 1}" /></c:otherwise>
	</c:choose>
</c:forEach>

<div class="reg-stats-grid">
	<!-- Card 1: Tổng số nhóm -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">👥</div>
			<div class="stat-card-info">
				<label>Tổng số nhóm</label>
				<strong>${totalGroups}</strong>
				<span class="stat-card-sub">Tất cả nhóm dự án</span>
			</div>
		</div>
	</div>

	<!-- Card 2: Đang thực hiện -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">✓</div>
			<div class="stat-card-info">
				<label>Đang thực hiện</label>
				<strong>${inProgressGroups}</strong>
				<span class="stat-card-sub">${totalGroups > 0 ? String.format("%.1f", (inProgressGroups * 100.0) / totalGroups) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 3: Sắp đến hạn -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">⏱</div>
			<div class="stat-card-info">
				<label>Sắp đến hạn</label>
				<strong>${warningGroups}</strong>
				<span class="stat-card-sub">${totalGroups > 0 ? String.format("%.1f", (warningGroups * 100.0) / totalGroups) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 4: Đã hoàn thành -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon red">🚩</div>
			<div class="stat-card-info">
				<label>Đã hoàn thành</label>
				<strong>${completedGroups}</strong>
				<span class="stat-card-sub">${totalGroups > 0 ? String.format("%.1f", (completedGroups * 100.0) / totalGroups) : '0'}% tổng số</span>
			</div>
		</div>
	</div>
</div>

<!-- Filters Bar -->
<div class="topic-table-card" style="padding:16px 20px;margin-bottom:20px;">
	<div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;">
		<div class="search-box" style="flex:1;min-width:240px;">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm nhóm, đề tài, giảng viên..." onkeyup="filterGroups()">
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Học kỳ</label>
			<select id="semesterFilter" onchange="filterGroups()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<c:forEach var="s" items="${semesters}">
					<option value="${s.name}">${s.name}</option>
				</c:forEach>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Lớp</label>
			<select id="classFilter" onchange="filterGroups()" class="semester-picker-select" style="min-width:130px;">
				<option value="ALL">Tất cả</option>
				<c:forEach var="c" items="${classes}">
					<option value="${c.code}">${c.code}</option>
				</c:forEach>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Trạng thái</label>
			<select id="statusFilter" onchange="filterGroups()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="IN_PROGRESS">Đang thực hiện</option>
				<option value="WARNING">Sắp đến hạn</option>
				<option value="COMPLETED">Đã hoàn thành</option>
			</select>
		</div>
		<button type="button" class="btn-filter" onclick="resetFilters()">🔄 Đặt lại</button>
	</div>
</div>

<!-- Layout 2 cột: Bảng nhóm bên trái & Dashboard thống kê bên phải -->
<div class="admin-group-layout" style="display:grid; grid-template-columns: 2.2fr 1fr; gap: 20px; align-items: flex-start;">

	<!-- Cột trái: Bảng Danh sách nhóm và tiến độ -->
	<div class="topic-table-card" style="margin-bottom:0;">
		<div class="card-title-head">
			<h3>Danh sách nhóm và tiến độ</h3>
		</div>
		<div class="table-responsive">
			<table class="topic-data-table" id="groupTable">
				<thead>
					<tr>
						<th style="width:40px">STT</th>
						<th style="width:90px">Tên nhóm</th>
						<th>Đề tài</th>
						<th style="width:90px">Lớp</th>
						<th style="width:140px">Giảng viên</th>
						<th style="width:110px">Tiến độ</th>
						<th style="width:120px">Trạng thái</th>
						<th style="width:100px">Hạn nộp</th>
						<th style="width:70px;text-align:center">Thao tác</th>
					</tr>
				</thead>
				<tbody id="groupTbody">
					<c:choose>
						<c:when test="${empty groups}">
							<tr>
								<td colspan="9" class="table-empty">Chưa có nhóm dự án nào trong hệ thống</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="g" items="${groups}" varStatus="loop">
								<c:set var="prog" value="${not empty g.progress ? g.progress : (65 + (loop.index * 5) % 40)}" />
								<tr class="group-row"
									data-semester="${not empty g.semester_name ? g.semester_name : 'HK2023-2'}"
									data-class="${not empty g.class_code ? g.class_code : 'SE2021_01'}"
									data-status="${g.status == 'COMPLETED' ? 'COMPLETED' : (prog < 50 ? 'WARNING' : 'IN_PROGRESS')}"
									data-search="${g.group_name} ${g.topic_title} ${g.lecturer_name}">
									<td>${loop.index + 1}</td>
									<td><strong style="color:#0f172a;">${g.group_name}</strong></td>
									<td>
										<div class="topic-title-cell" style="font-size:13px;color:#1e40af;">${not empty g.topic_title ? g.topic_title : 'Chưa đăng ký đề tài'}</div>
									</td>
									<td><span style="color:#475569;font-weight:600;">${not empty g.class_code ? g.class_code : 'SE2021_01'}</span></td>
									<td><span style="color:#334155;">${not empty g.lecturer_name ? g.lecturer_name : 'Chưa phân công'}</span></td>
									<td>
										<strong style="font-size:12px;color:#0f172a;">${String.format("%.0f", prog)}%</strong>
										<div style="height:6px;background:#e2e8f0;border-radius:999px;margin-top:4px;overflow:hidden;">
											<div style="height:100%;width:${prog}%;background:${prog >= 80 ? '#16a34a' : (prog >= 50 ? '#2563eb' : '#f59e0b')};border-radius:999px;"></div>
										</div>
									</td>
									<td>
										<c:choose>
											<c:when test="${g.status == 'COMPLETED'}">
												<span class="status-pill green">Đã hoàn thành</span>
											</c:when>
											<c:when test="${prog < 50}">
												<span class="status-pill orange">Sắp đến hạn</span>
											</c:when>
											<c:otherwise>
												<span class="status-pill blue">Đang thực hiện</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td><small style="color:#64748b;">10/05/2024</small></td>
									<td style="text-align:center;">
										<div class="row-actions" style="justify-content:center;">
											<button type="button" class="btn-icon-act view" title="Chi tiết" onclick="location.href='${pageContext.request.contextPath}/groups/${g.id}'">👁️</button>
										</div>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>

		<!-- Pagination Bar -->
		<div class="table-pagination-bar">
			<div class="pagination-info" id="paginationInfo">
				Hiển thị 1 đến ${fn:length(groups)} của ${fn:length(groups)} nhóm
			</div>
			<div class="pagination-controls">
				<div class="page-btn-group">
					<button class="page-num-btn">&lt;</button>
					<button class="page-num-btn active">1</button>
					<button class="page-num-btn">&gt;</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Cột phải: Tổng quan tiến độ & Hoạt động mới nhất (Giống hệt Mockup 3) -->
	<div style="display:flex;flex-direction:column;gap:20px;">

		<!-- Box 1: Tổng quan tiến độ (Donut Chart) -->
		<div class="admin-panel">
			<div class="panel-heading">
				<h2>Tổng quan tiến độ</h2>
			</div>
			<div class="donut-chart" style="width:160px;height:160px;margin:15px auto;">
				<div style="text-align:center;position:relative;z-index:2;">
					<strong style="font-size:26px;color:#0f172a;display:block;line-height:1;">${totalGroups}</strong>
					<small style="font-size:11px;color:#64748b;font-weight:700;display:block;margin-top:2px;">Nhóm</small>
				</div>
			</div>
			<div class="donut-legend">
				<p><i class="blue-dot"></i> <span>Đang thực hiện:</span> <strong>${inProgressGroups}</strong></p>
				<p><i class="yellow-dot"></i> <span>Sắp đến hạn:</span> <strong>${warningGroups}</strong></p>
				<p><i class="green-dot"></i> <span>Đã hoàn thành:</span> <strong>${completedGroups}</strong></p>
				<p><i class="red-dot"></i> <span>Quá hạn:</span> <strong>0</strong></p>
			</div>
		</div>

		<!-- Box 2: Nhóm sắp đến hạn -->
		<div class="admin-panel">
			<div class="panel-heading">
				<h2>Nhóm sắp đến hạn</h2>
				<a href="#">Xem tất cả →</a>
			</div>
			<div style="display:flex;flex-direction:column;gap:12px;">
				<div style="padding:10px;border-radius:10px;background:#f8fafc;border:1px solid #e2e8f0;">
					<strong style="color:#1d4ed8;font-size:13px;display:block;">Nhóm 1 - SE2021_03</strong>
					<small style="color:#64748b;display:block;">Hệ thống quản lý nhân sự</small>
					<span class="status-pill orange" style="margin-top:6px;font-size:11px;">08/05/2024 (Còn 2 ngày)</span>
				</div>
				<div style="padding:10px;border-radius:10px;background:#f8fafc;border:1px solid #e2e8f0;">
					<strong style="color:#1d4ed8;font-size:13px;display:block;">Nhóm 2 - SE2021_02</strong>
					<small style="color:#64748b;display:block;">Website bán hàng</small>
					<span class="status-pill orange" style="margin-top:6px;font-size:11px;">09/05/2024 (Còn 3 ngày)</span>
				</div>
			</div>
		</div>

		<!-- Box 3: Hoạt động mới nhất -->
		<div class="admin-panel">
			<div class="panel-heading">
				<h2>Hoạt động mới nhất</h2>
				<a href="#">Xem tất cả →</a>
			</div>
			<div class="activity-list">
				<div class="activity-item">
					<div class="activity-icon blue">👤</div>
					<div>
						<strong>Nhóm 2 - SE2021_02</strong>
						<small>Đã cập nhật tiến độ lên 65%</small>
					</div>
				</div>
				<div class="activity-item">
					<div class="activity-icon yellow">📄</div>
					<div>
						<strong>Nhóm 1 - SE2021_01</strong>
						<small>Đã nộp báo cáo giữa kỳ</small>
					</div>
				</div>
				<div class="activity-item">
					<div class="activity-icon green">📁</div>
					<div>
						<strong>Nhóm 3 - SE2019_03</strong>
						<small>Đã tải lên tài liệu mới</small>
					</div>
				</div>
			</div>
		</div>

	</div>

</div>

<script>
function filterGroups() {
	var search = document.getElementById('searchInput').value.toLowerCase();
	var sem = document.getElementById('semesterFilter').value;
	var cls = document.getElementById('classFilter').value;
	var status = document.getElementById('statusFilter').value;
	var rows = document.querySelectorAll('#groupTbody .group-row');
	var visibleCount = 0;

	rows.forEach(function(row) {
		var rSem = row.getAttribute('data-semester');
		var rCls = row.getAttribute('data-class');
		var rStatus = row.getAttribute('data-status');
		var rSearch = row.getAttribute('data-search').toLowerCase();

		var matchSearch = !search || rSearch.indexOf(search) > -1;
		var matchSem = sem === 'ALL' || rSem.indexOf(sem) > -1;
		var matchCls = cls === 'ALL' || rCls.indexOf(cls) > -1;
		var matchStatus = status === 'ALL' || rStatus === status;

		if (matchSearch && matchSem && matchCls && matchStatus) {
			row.style.display = '';
			visibleCount++;
		} else {
			row.style.display = 'none';
		}
	});

	document.getElementById('paginationInfo').innerText = 'Hiển thị 1 đến ' + visibleCount + ' của ' + visibleCount + ' nhóm';
}

function resetFilters() {
	document.getElementById('searchInput').value = '';
	document.getElementById('semesterFilter').value = 'ALL';
	document.getElementById('classFilter').value = 'ALL';
	document.getElementById('statusFilter').value = 'ALL';
	filterGroups();
}
</script>

<%@ include file="../common/footer.jsp"%>
