<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Quản lý học kỳ</h1>
		<p>Quản lý các học kỳ trong hệ thống</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-add-primary" onclick="openAddSemesterModal()">+ Thêm học kỳ</button>
	</div>
</div>

<!-- 4 Stats Cards Grid -->
<c:set var="totalSemesters" value="${fn:length(semesters)}" />
<c:set var="activeSemesters" value="0" />
<c:set var="upcomingSemesters" value="0" />
<c:set var="closedSemesters" value="0" />
<c:forEach var="s" items="${semesters}">
	<c:choose>
		<c:when test="${s.status == 'ACTIVE'}"><c:set var="activeSemesters" value="${activeSemesters + 1}" /></c:when>
		<c:when test="${s.status == 'UPCOMING'}"><c:set var="upcomingSemesters" value="${upcomingSemesters + 1}" /></c:when>
		<c:otherwise><c:set var="closedSemesters" value="${closedSemesters + 1}" /></c:otherwise>
	</c:choose>
</c:forEach>

<div class="reg-stats-grid">
	<!-- Card 1: Tổng số học kỳ -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">📅</div>
			<div class="stat-card-info">
				<label>Tổng số học kỳ</label>
				<strong>${totalSemesters}</strong>
				<span class="stat-card-sub">Tất cả học kỳ</span>
			</div>
		</div>
	</div>

	<!-- Card 2: Đang diễn ra -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">📋</div>
			<div class="stat-card-info">
				<label>Đang diễn ra</label>
				<strong>${activeSemesters}</strong>
				<span class="stat-card-sub">${totalSemesters > 0 ? String.format("%.1f", (activeSemesters * 100.0) / totalSemesters) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 3: Sắp diễn ra -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">⏱</div>
			<div class="stat-card-info">
				<label>Sắp diễn ra</label>
				<strong>${upcomingSemesters}</strong>
				<span class="stat-card-sub">${totalSemesters > 0 ? String.format("%.1f", (upcomingSemesters * 100.0) / totalSemesters) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 4: Đã kết thúc -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon purple">📦</div>
			<div class="stat-card-info">
				<label>Đã kết thúc</label>
				<strong>${closedSemesters}</strong>
				<span class="stat-card-sub">${totalSemesters > 0 ? String.format("%.1f", (closedSemesters * 100.0) / totalSemesters) : '0'}% tổng số</span>
			</div>
		</div>
	</div>
</div>

<!-- Filters Bar -->
<div class="topic-table-card" style="padding:16px 20px;margin-bottom:20px;">
	<div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;">
		<div class="search-box" style="flex:1;min-width:240px;">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm học kỳ..." onkeyup="filterSemesters()">
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Năm học</label>
			<select id="yearFilter" onchange="filterSemesters()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="2024 - 2025">2024 - 2025</option>
				<option value="2023 - 2024">2023 - 2024</option>
				<option value="2022 - 2023">2022 - 2023</option>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Trạng thái</label>
			<select id="statusFilter" onchange="filterSemesters()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="ACTIVE">Đang diễn ra</option>
				<option value="UPCOMING">Sắp diễn ra</option>
				<option value="CLOSED">Đã kết thúc</option>
			</select>
		</div>
		<button type="button" class="btn-filter" onclick="resetFilters()">🔄 Đặt lại</button>
	</div>
</div>

<!-- Table Card -->
<div class="topic-table-card">
	<div class="table-responsive">
		<table class="topic-data-table" id="semesterTable">
			<thead>
				<tr>
					<th style="width:50px">STT</th>
					<th style="width:130px">Mã học kỳ</th>
					<th>Tên học kỳ</th>
					<th style="width:130px">Năm học</th>
					<th style="width:130px">Ngày bắt đầu</th>
					<th style="width:130px">Ngày kết thúc</th>
					<th style="width:130px">Trạng thái</th>
					<th style="width:90px;text-align:center">Thao tác</th>
				</tr>
			</thead>
			<tbody id="semesterTbody">
				<c:choose>
					<c:when test="${empty semesters}">
						<tr>
							<td colspan="8" class="table-empty">Chưa có học kỳ nào trong hệ thống</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="s" items="${semesters}" varStatus="loop">
							<tr class="semester-row"
								data-status="${s.status}"
								data-year="${not empty s.academic_year ? s.academic_year : '2023 - 2024'}"
								data-search="${s.code} ${s.name}">
								<td>${loop.index + 1}</td>
								<td>
									<span class="topic-code-tag">${s.code}</span>
								</td>
								<td>
									<strong style="color:#0f172a;">${s.name}</strong>
								</td>
								<td>
									<span style="color:#475569;font-weight:600;">
										<c:choose>
											<c:when test="${not empty s.academic_year}">${s.academic_year}</c:when>
											<c:otherwise>2023 - 2024</c:otherwise>
										</c:choose>
									</span>
								</td>
								<td><span style="color:#475569;">${s.start_date}</span></td>
								<td><span style="color:#475569;">${s.end_date}</span></td>
								<td>
									<c:choose>
										<c:when test="${s.status == 'ACTIVE'}">
											<span class="status-pill green">Đang diễn ra</span>
										</c:when>
										<c:when test="${s.status == 'UPCOMING'}">
											<span class="status-pill orange">Sắp diễn ra</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill gray" style="background:#f1f5f9;color:#64748b;">Đã kết thúc</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td style="text-align:center;">
									<div class="row-actions" style="justify-content:center;">
										<button type="button" class="btn-icon-act edit" title="Chỉnh sửa" onclick="openEditSemesterModal('${s.id}', '${s.code}', '${s.name}', '${s.start_date}', '${s.end_date}', '${s.registration_deadline}', '${s.status}')">✏️</button>
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
			Hiển thị 1 đến ${fn:length(semesters)} của ${fn:length(semesters)} học kỳ
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

<!-- Note Banner Box matching Mockup 2 -->
<div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:14px;padding:16px 20px;margin-top:20px;color:#1e40af;">
	<div style="display:flex;align-items:flex-start;gap:12px;">
		<span style="font-size:18px;line-height:1;">ℹ️</span>
		<div>
			<strong style="display:block;font-size:14px;margin-bottom:4px;color:#1e3a8a;">Ghi chú</strong>
			<ul style="margin:0;padding-left:18px;font-size:13px;line-height:1.6;color:#1e40af;">
				<li>Chỉ có một học kỳ có thể ở trạng thái "Đang diễn ra" tại một thời điểm.</li>
				<li>Học kỳ sau khi kết thúc sẽ không thể chỉnh sửa ngày bắt đầu và ngày kết thúc.</li>
			</ul>
		</div>
	</div>
</div>

<!-- Modal Thêm học kỳ -->
<div class="custom-modal" id="addSemesterModal">
	<div class="modal-container" style="max-width:550px;">
		<div class="modal-header-custom">
			<h2>Thêm học kỳ mới</h2>
			<button class="modal-close-btn" onclick="closeAddSemesterModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/semesters">
			<div class="modal-body-custom">
				<div class="form-group">
					<label>Mã học kỳ *</label>
					<input name="code" required placeholder="HK2024-1">
				</div>
				<div class="form-group">
					<label>Tên học kỳ *</label>
					<input name="name" required placeholder="Học kỳ 1 - Năm học 2024-2025">
				</div>
				<div class="row" style="grid-template-columns:1fr 1fr;gap:14px;">
					<div class="form-group">
						<label>Ngày bắt đầu *</label>
						<input type="date" name="startDate" required>
					</div>
					<div class="form-group">
						<label>Ngày kết thúc *</label>
						<input type="date" name="endDate" required>
					</div>
				</div>
				<div class="row" style="grid-template-columns:1fr 1fr;gap:14px;">
					<div class="form-group">
						<label>Hạn đăng ký đề tài</label>
						<input type="date" name="registrationDeadline">
					</div>
					<div class="form-group">
						<label>Trạng thái *</label>
						<select name="status">
							<option value="UPCOMING">Sắp diễn ra</option>
							<option value="ACTIVE">Đang diễn ra</option>
							<option value="CLOSED">Đã kết thúc</option>
						</select>
					</div>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeAddSemesterModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Lưu học kỳ</button>
			</div>
		</form>
	</div>
</div>

<!-- Modal Sửa học kỳ -->
<div class="custom-modal" id="editSemesterModal">
	<div class="modal-container" style="max-width:550px;">
		<div class="modal-header-custom">
			<h2>Chỉnh sửa học kỳ</h2>
			<button class="modal-close-btn" onclick="closeEditSemesterModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/update-semester">
			<input type="hidden" name="id" id="editSemesterId">
			<div class="modal-body-custom">
				<div class="form-group">
					<label>Mã học kỳ</label>
					<input id="editSemesterCode" disabled style="background:#f1f5f9;">
				</div>
				<div class="form-group">
					<label>Tên học kỳ *</label>
					<input name="name" id="editSemesterName" required>
				</div>
				<div class="row" style="grid-template-columns:1fr 1fr;gap:14px;">
					<div class="form-group">
						<label>Ngày bắt đầu *</label>
						<input type="date" name="startDate" id="editSemesterStart" required>
					</div>
					<div class="form-group">
						<label>Ngày kết thúc *</label>
						<input type="date" name="endDate" id="editSemesterEnd" required>
					</div>
				</div>
				<div class="row" style="grid-template-columns:1fr 1fr;gap:14px;">
					<div class="form-group">
						<label>Hạn đăng ký đề tài</label>
						<input type="date" name="registrationDeadline" id="editSemesterDeadline">
					</div>
					<div class="form-group">
						<label>Trạng thái *</label>
						<select name="status" id="editSemesterStatus">
							<option value="UPCOMING">Sắp diễn ra</option>
							<option value="ACTIVE">Đang diễn ra</option>
							<option value="CLOSED">Đã kết thúc</option>
						</select>
					</div>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeEditSemesterModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Cập nhật</button>
			</div>
		</form>
	</div>
</div>

<script>
function openAddSemesterModal() {
	document.getElementById('addSemesterModal').classList.add('show');
}
function closeAddSemesterModal() {
	document.getElementById('addSemesterModal').classList.remove('show');
}

function openEditSemesterModal(id, code, name, start, end, deadline, status) {
	document.getElementById('editSemesterId').value = id;
	document.getElementById('editSemesterCode').value = code;
	document.getElementById('editSemesterName').value = name;
	document.getElementById('editSemesterStart').value = start || '';
	document.getElementById('editSemesterEnd').value = end || '';
	document.getElementById('editSemesterDeadline').value = deadline || '';
	document.getElementById('editSemesterStatus').value = status;
	document.getElementById('editSemesterModal').classList.add('show');
}
function closeEditSemesterModal() {
	document.getElementById('editSemesterModal').classList.remove('show');
}

function filterSemesters() {
	var search = document.getElementById('searchInput').value.toLowerCase();
	var year = document.getElementById('yearFilter').value;
	var status = document.getElementById('statusFilter').value;
	var rows = document.querySelectorAll('#semesterTbody .semester-row');
	var visibleCount = 0;

	rows.forEach(function(row) {
		var rStatus = row.getAttribute('data-status');
		var rYear = row.getAttribute('data-year');
		var rSearch = row.getAttribute('data-search').toLowerCase();

		var matchSearch = !search || rSearch.indexOf(search) > -1;
		var matchYear = year === 'ALL' || rYear.indexOf(year) > -1;
		var matchStatus = status === 'ALL' || rStatus === status;

		if (matchSearch && matchYear && matchStatus) {
			row.style.display = '';
			visibleCount++;
		} else {
			row.style.display = 'none';
		}
	});

	document.getElementById('paginationInfo').innerText = 'Hiển thị 1 đến ' + visibleCount + ' của ' + visibleCount + ' học kỳ';
}

function resetFilters() {
	document.getElementById('searchInput').value = '';
	document.getElementById('yearFilter').value = 'ALL';
	document.getElementById('statusFilter').value = 'ALL';
	filterSemesters();
}
</script>

<%@ include file="../common/footer.jsp"%>


