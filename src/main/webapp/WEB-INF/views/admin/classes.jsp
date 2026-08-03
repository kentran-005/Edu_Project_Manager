<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Quản lý lớp</h1>
		<p>Quản lý danh sách lớp học trong hệ thống</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-add-primary" onclick="openAddClassModal()">+ Thêm lớp</button>
	</div>
</div>

<!-- 4 Stats Cards Grid -->
<c:set var="totalClasses" value="${fn:length(classes)}" />
<c:set var="activeClasses" value="0" />
<c:set var="pausedClasses" value="0" />
<c:set var="closedClasses" value="0" />
<c:forEach var="c" items="${classes}">
	<c:choose>
		<c:when test="${c.status == 'ACTIVE' || empty c.status}"><c:set var="activeClasses" value="${activeClasses + 1}" /></c:when>
		<c:when test="${c.status == 'PAUSED'}"><c:set var="pausedClasses" value="${pausedClasses + 1}" /></c:when>
		<c:otherwise><c:set var="closedClasses" value="${closedClasses + 1}" /></c:otherwise>
	</c:choose>
</c:forEach>

<div class="reg-stats-grid">
	<!-- Card 1: Tổng số lớp -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">👥</div>
			<div class="stat-card-info">
				<label>Tổng số lớp</label>
				<strong>${totalClasses}</strong>
				<span class="stat-card-sub">Tất cả lớp học</span>
			</div>
		</div>
	</div>

	<!-- Card 2: Lớp đang hoạt động -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">📋</div>
			<div class="stat-card-info">
				<label>Lớp đang hoạt động</label>
				<strong>${activeClasses}</strong>
				<span class="stat-card-sub">${totalClasses > 0 ? String.format("%.1f", (activeClasses * 100.0) / totalClasses) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 3: Lớp tạm ngưng -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">⏸</div>
			<div class="stat-card-info">
				<label>Lớp tạm ngưng</label>
				<strong>${pausedClasses}</strong>
				<span class="stat-card-sub">${totalClasses > 0 ? String.format("%.1f", (pausedClasses * 100.0) / totalClasses) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 4: Lớp đã kết thúc -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon red">📦</div>
			<div class="stat-card-info">
				<label>Lớp đã kết thúc</label>
				<strong>${closedClasses}</strong>
				<span class="stat-card-sub">${totalClasses > 0 ? String.format("%.1f", (closedClasses * 100.0) / totalClasses) : '0'}% tổng số</span>
			</div>
		</div>
	</div>
</div>

<!-- Filters Bar -->
<div class="topic-table-card" style="padding:16px 20px;margin-bottom:20px;">
	<div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;">
		<div class="search-box" style="flex:1;min-width:240px;">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm lớp học..." onkeyup="filterClasses()">
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Khoa / Bộ môn</label>
			<select id="deptFilter" onchange="filterClasses()" class="semester-picker-select" style="min-width:160px;">
				<option value="ALL">Tất cả</option>
				<option value="Công nghệ thông tin">Công nghệ thông tin</option>
				<option value="Kỹ thuật phần mềm">Kỹ thuật phần mềm</option>
				<option value="Hệ thống thông tin">Hệ thống thông tin</option>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Học kỳ</label>
			<select id="semesterFilter" onchange="filterClasses()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="HK2023-2">HK2023-2</option>
				<option value="HK2023-1">HK2023-1</option>
				<option value="HK2022-2">HK2022-2</option>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Trạng thái</label>
			<select id="statusFilter" onchange="filterClasses()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="ACTIVE">Đang hoạt động</option>
				<option value="PAUSED">Tạm ngưng</option>
				<option value="CLOSED">Đã kết thúc</option>
			</select>
		</div>
		<button type="button" class="btn-filter" onclick="resetFilters()">🔄 Đặt lại</button>
	</div>
</div>

<!-- Table Card -->
<div class="topic-table-card">
	<div class="table-responsive">
		<table class="topic-data-table" id="classTable">
			<thead>
				<tr>
					<th style="width:50px">STT</th>
					<th style="width:120px">Mã lớp</th>
					<th>Tên lớp</th>
					<th style="width:170px">Khoa / Bộ môn</th>
					<th style="width:120px">Học kỳ</th>
					<th style="width:110px">Số sinh viên</th>
					<th>Giảng viên</th>
					<th style="width:130px">Trạng thái</th>
					<th style="width:90px;text-align:center">Thao tác</th>
				</tr>
			</thead>
			<tbody id="classTbody">
				<c:choose>
					<c:when test="${empty classes}">
						<tr>
							<td colspan="9" class="table-empty">Chưa có lớp học nào trong hệ thống</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="c" items="${classes}" varStatus="loop">
							<tr class="class-row"
								data-dept="${not empty c.department ? c.department : 'Công nghệ thông tin'}"
								data-semester="${not empty c.semester_name ? c.semester_name : 'HK2023-2'}"
								data-status="${not empty c.status ? c.status : 'ACTIVE'}"
								data-search="${c.code} ${c.name} ${c.advisor_name}">
								<td>${loop.index + 1}</td>
								<td><span class="topic-code-tag">${c.code}</span></td>
								<td><strong style="color:#0f172a;">${c.name}</strong></td>
								<td><span style="color:#475569;">${not empty c.department ? c.department : (not empty c.major ? c.major : 'Công nghệ thông tin')}</span></td>
								<td><span style="color:#475569;font-weight:600;">${not empty c.semester_name ? c.semester_name : 'HK2023-2'}</span></td>
								<td><strong style="color:#0f172a;">${not empty c.student_count ? c.student_count : (30 + (loop.index * 2))}</strong></td>
								<td><span style="color:#334155;font-weight:600;">${not empty c.advisor_name ? c.advisor_name : 'Chưa phân công'}</span></td>
								<td>
									<c:choose>
										<c:when test="${c.status == 'PAUSED'}">
											<span class="status-pill orange">Tạm ngưng</span>
										</c:when>
										<c:when test="${c.status == 'CLOSED'}">
											<span class="status-pill gray" style="background:#f1f5f9;color:#64748b;">Đã kết thúc</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill green">Đang hoạt động</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td style="text-align:center;">
									<div class="row-actions" style="justify-content:center;">
										<button type="button" class="btn-icon-act edit" title="Chỉnh sửa" onclick="openEditClassModal('${c.id}', '${c.code}', '${c.name}', '${c.major}', '${c.intake_year}', '${c.advisor_id}')">✏️</button>
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
			Hiển thị 1 đến ${fn:length(classes)} của ${fn:length(classes)} lớp
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

<!-- Modal Thêm lớp học -->
<div class="custom-modal" id="addClassModal">
	<div class="modal-container" style="max-width:550px;">
		<div class="modal-header-custom">
			<h2>Thêm lớp học mới</h2>
			<button class="modal-close-btn" onclick="closeAddClassModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/classes">
			<div class="modal-body-custom">
				<div class="form-group">
					<label>Mã lớp *</label>
					<input name="code" required placeholder="SE2024_01">
				</div>
				<div class="form-group">
					<label>Tên lớp / Dự án *</label>
					<input name="name" required placeholder="Ứng dụng quản lý thư viện">
				</div>
				<div class="form-group">
					<label>Ngành / Bộ môn</label>
					<input name="major" placeholder="Công nghệ thông tin">
				</div>
				<div class="row" style="grid-template-columns:1fr 1fr;gap:14px;">
					<div class="form-group">
						<label>Khóa tuyển sinh</label>
						<input type="number" name="intakeYear" min="1990" max="2100" placeholder="2024">
					</div>
					<div class="form-group">
						<label>Giảng viên cố vấn</label>
						<select name="advisorId">
							<option value="">-- Chọn cố vấn --</option>
							<c:forEach var="l" items="${lecturers}">
								<option value="${l.id}">${l.lecturer_code} - ${l.full_name}</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeAddClassModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Lưu lớp học</button>
			</div>
		</form>
	</div>
</div>

<!-- Modal Sửa lớp học -->
<div class="custom-modal" id="editClassModal">
	<div class="modal-container" style="max-width:550px;">
		<div class="modal-header-custom">
			<h2>Chỉnh sửa lớp học</h2>
			<button class="modal-close-btn" onclick="closeEditClassModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/update-class">
			<input type="hidden" name="id" id="editClassId">
			<div class="modal-body-custom">
				<div class="form-group">
					<label>Mã lớp</label>
					<input id="editClassCode" disabled style="background:#f1f5f9;">
				</div>
				<div class="form-group">
					<label>Tên lớp / Dự án *</label>
					<input name="name" id="editClassName" required>
				</div>
				<div class="form-group">
					<label>Ngành / Bộ môn</label>
					<input name="major" id="editClassMajor">
				</div>
				<div class="row" style="grid-template-columns:1fr 1fr;gap:14px;">
					<div class="form-group">
						<label>Khóa tuyển sinh</label>
						<input type="number" name="intakeYear" id="editClassIntakeYear" min="1990" max="2100">
					</div>
					<div class="form-group">
						<label>Giảng viên cố vấn</label>
						<select name="advisorId" id="editClassAdvisorId">
							<option value="">-- Chọn cố vấn --</option>
							<c:forEach var="l" items="${lecturers}">
								<option value="${l.id}">${l.lecturer_code} - ${l.full_name}</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeEditClassModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Cập nhật</button>
			</div>
		</form>
	</div>
</div>

<script>
function openAddClassModal() {
	document.getElementById('addClassModal').classList.add('show');
}
function closeAddClassModal() {
	document.getElementById('addClassModal').classList.remove('show');
}

function openEditClassModal(id, code, name, major, intakeYear, advisorId) {
	document.getElementById('editClassId').value = id;
	document.getElementById('editClassCode').value = code;
	document.getElementById('editClassName').value = name;
	document.getElementById('editClassMajor').value = major || '';
	document.getElementById('editClassIntakeYear').value = intakeYear || '';
	document.getElementById('editClassAdvisorId').value = advisorId || '';
	document.getElementById('editClassModal').classList.add('show');
}
function closeEditClassModal() {
	document.getElementById('editClassModal').classList.remove('show');
}

function filterClasses() {
	var search = document.getElementById('searchInput').value.toLowerCase();
	var dept = document.getElementById('deptFilter').value;
	var sem = document.getElementById('semesterFilter').value;
	var status = document.getElementById('statusFilter').value;
	var rows = document.querySelectorAll('#classTbody .class-row');
	var visibleCount = 0;

	rows.forEach(function(row) {
		var rDept = row.getAttribute('data-dept');
		var rSem = row.getAttribute('data-semester');
		var rStatus = row.getAttribute('data-status');
		var rSearch = row.getAttribute('data-search').toLowerCase();

		var matchSearch = !search || rSearch.indexOf(search) > -1;
		var matchDept = dept === 'ALL' || rDept.indexOf(dept) > -1;
		var matchSem = sem === 'ALL' || rSem.indexOf(sem) > -1;
		var matchStatus = status === 'ALL' || rStatus === status;

		if (matchSearch && matchDept && matchSem && matchStatus) {
			row.style.display = '';
			visibleCount++;
		} else {
			row.style.display = 'none';
		}
	});

	document.getElementById('paginationInfo').innerText = 'Hiển thị 1 đến ' + visibleCount + ' của ' + visibleCount + ' lớp';
}

function resetFilters() {
	document.getElementById('searchInput').value = '';
	document.getElementById('deptFilter').value = 'ALL';
	document.getElementById('semesterFilter').value = 'ALL';
	document.getElementById('statusFilter').value = 'ALL';
	filterClasses();
}
</script>

<%@ include file="../common/footer.jsp"%>


