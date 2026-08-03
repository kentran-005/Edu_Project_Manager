<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Chi tiết nhóm hướng dẫn</h1>
		<p>Quản lý và theo dõi tiến độ các nhóm đồ án do bạn trực tiếp hướng dẫn</p>
	</div>
	<div class="page-header-actions">
		<div class="search-box">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm nhóm, đề tài..." onkeyup="filterGroups()">
		</div>
		<button type="button" class="btn-filter" onclick="resetFilters()">🌪 Bộ lọc</button>
	</div>
</div>

<!-- 4 Stats Cards Grid -->
<div class="reg-stats-grid">
	<!-- Card 1: Tổng số nhóm -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">👥</div>
			<div class="stat-card-info">
				<label>Tổng số nhóm</label>
				<strong>${not empty stats.total_groups ? stats.total_groups : fn:length(groups)}</strong>
				<span class="stat-card-sub">Nhóm phụ trách</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('ALL')">Xem chi tiết →</span>
	</div>

	<!-- Card 2: Đang thực hiện -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">🟢</div>
			<div class="stat-card-info">
				<label>Đang thực hiện</label>
				<strong>${not empty stats.in_progress_groups ? stats.in_progress_groups : 0}</strong>
				<span class="stat-card-sub">Đang làm đồ án</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('IN_PROGRESS')">Xem chi tiết →</span>
	</div>

	<!-- Card 3: Đã hoàn thành -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon purple">🟣</div>
			<div class="stat-card-info">
				<label>Đã hoàn thành</label>
				<strong>${not empty stats.completed_groups ? stats.completed_groups : 0}</strong>
				<span class="stat-card-sub">Đã bảo vệ đồ án</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('COMPLETED')">Xem chi tiết →</span>
	</div>

	<!-- Card 4: Đang tạo / Đăng ký -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">🟠</div>
			<div class="stat-card-info">
				<label>Khởi tạo / Đăng ký</label>
				<strong>${not empty stats.forming_groups ? stats.forming_groups : 0}</strong>
				<span class="stat-card-sub">Chờ phân công</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('FORMING')">Xem chi tiết →</span>
	</div>
</div>

<!-- Table "Danh sách nhóm hướng dẫn" -->
<div class="topic-table-card">
	<div class="card-title-head">
		<h3>Danh sách nhóm hướng dẫn</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table" id="groupsTable">
			<thead>
				<tr>
					<th style="width:50px">#</th>
					<th style="width:120px">Mã nhóm</th>
					<th>Tên nhóm</th>
					<th>Đề tài phụ trách</th>
					<th style="width:110px">Sinh viên</th>
					<th style="width:140px">Trạng thái</th>
					<th style="width:140px;text-align:center">Hành động</th>
				</tr>
			</thead>
			<tbody id="groupsTbody">
				<c:choose>
					<c:when test="${empty groups}">
						<tr>
							<td colspan="7" class="table-empty">Hiện tại bạn chưa được phân công phụ trách nhóm đồ án nào.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="g" items="${groups}" varStatus="loop">
							<tr class="group-row"
								data-status="${g.status}"
								data-group="${fn:toLowerCase(g.group_name)}"
								data-title="${fn:toLowerCase(g.topic_title)}">
								<td>${loop.index + 1}</td>
								<td>
									<span class="topic-code-tag">NHOM_00${g.id}</span>
								</td>
								<td>
									<strong style="color:#0f172a">${g.group_name}</strong>
								</td>
								<td>
									<div class="topic-title-cell" title="${g.topic_title}">
										${not empty g.topic_title ? g.topic_title : 'Chưa chọn đề tài'}
									</div>
								</td>
								<td>${not empty g.member_count && g.member_count > 0 ? g.member_count : 4} SV</td>
								<td>
									<c:choose>
										<c:when test="${g.status=='IN_PROGRESS'}">
											<span class="status-pill green">Đang thực hiện</span>
										</c:when>
										<c:when test="${g.status=='COMPLETED'}">
											<span class="status-pill purple">Hoàn thành</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill orange">Khởi tạo</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<div class="row-actions" style="justify-content:center">
										<a class="btn-icon-act view" title="Xem chi tiết nhóm" href="${pageContext.request.contextPath}/groups/${g.id}">
											👁
										</a>
										<a class="btn-icon-act view" title="Xuất PDF tiến độ" href="${pageContext.request.contextPath}/pdf/group?groupId=${g.id}" target="_blank">
											📄
										</a>
									</div>
								</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>

	<!-- Pagination Footer -->
	<div class="table-pagination-bar">
		<div class="pagination-info">
			Hiển thị <span id="showingCount">1 đến ${fn:length(groups) > 10 ? 10 : fn:length(groups)}</span> trong tổng số <strong>${fn:length(groups)}</strong> nhóm
		</div>
		<div class="pagination-controls">
			<select class="rows-per-page-select">
				<option value="10" selected>10 / trang</option>
				<option value="20">20 / trang</option>
			</select>
			<div class="page-btn-group">
				<button type="button" class="page-num-btn">&lt;</button>
				<button type="button" class="page-num-btn active">1</button>
				<button type="button" class="page-num-btn">&gt;</button>
			</div>
		</div>
	</div>
</div>

<script>
function filterGroups() {
	var query = document.getElementById('searchInput').value.toLowerCase();
	var rows = document.querySelectorAll('.group-row');
	var visibleCount = 0;
	
	rows.forEach(function(row) {
		var group = row.getAttribute('data-group') || '';
		var title = row.getAttribute('data-title') || '';
		if (group.indexOf(query) !== -1 || title.indexOf(query) !== -1) {
			row.style.display = '';
			visibleCount++;
		} else {
			row.style.display = 'none';
		}
	});
	
	document.getElementById('showingCount').innerText = '1 đến ' + (visibleCount > 10 ? 10 : visibleCount);
}

function filterByStatus(statusKey) {
	var rows = document.querySelectorAll('.group-row');
	rows.forEach(function(row) {
		var st = row.getAttribute('data-status');
		if (statusKey === 'ALL') {
			row.style.display = '';
		} else if (st === statusKey) {
			row.style.display = '';
		} else {
			row.style.display = 'none';
		}
	});
}

function resetFilters() {
	document.getElementById('searchInput').value = '';
	filterByStatus('ALL');
}
</script>

<%@ include file="../common/footer.jsp"%>
