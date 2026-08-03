<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Quản lý tài khoản</h1>
		<p>Quản lý và phân quyền các tài khoản trong hệ thống</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-add-primary" onclick="openAddModal()">+ Thêm tài khoản</button>
	</div>
</div>

<!-- 4 Stats Cards Grid -->
<c:set var="totalUsers" value="${fn:length(users)}" />
<c:set var="activeUsers" value="0" />
<c:set var="lockedUsers" value="0" />
<c:set var="inactiveUsers" value="0" />
<c:forEach var="u" items="${users}">
	<c:choose>
		<c:when test="${u.status == 'ACTIVE'}"><c:set var="activeUsers" value="${activeUsers + 1}" /></c:when>
		<c:when test="${u.status == 'LOCKED'}"><c:set var="lockedUsers" value="${lockedUsers + 1}" /></c:when>
		<c:otherwise><c:set var="inactiveUsers" value="${inactiveUsers + 1}" /></c:otherwise>
	</c:choose>
</c:forEach>

<div class="reg-stats-grid">
	<!-- Card 1: Tổng tài khoản -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">👥</div>
			<div class="stat-card-info">
				<label>Tổng tài khoản</label>
				<strong>${totalUsers}</strong>
				<span class="stat-card-sub">Tất cả tài khoản</span>
			</div>
		</div>
	</div>

	<!-- Card 2: Tài khoản hoạt động -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">✓</div>
			<div class="stat-card-info">
				<label>Tài khoản hoạt động</label>
				<strong>${activeUsers}</strong>
				<span class="stat-card-sub">${totalUsers > 0 ? String.format("%.1f", (activeUsers * 100.0) / totalUsers) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 3: Tài khoản bị khóa -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">🔒</div>
			<div class="stat-card-info">
				<label>Tài khoản bị khóa</label>
				<strong>${lockedUsers}</strong>
				<span class="stat-card-sub">${totalUsers > 0 ? String.format("%.1f", (lockedUsers * 100.0) / totalUsers) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 4: Tài khoản chờ duyệt / Tạm ngưng -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon purple">⏱</div>
			<div class="stat-card-info">
				<label>Tài khoản tạm ngưng</label>
				<strong>${inactiveUsers}</strong>
				<span class="stat-card-sub">${totalUsers > 0 ? String.format("%.1f", (inactiveUsers * 100.0) / totalUsers) : '0'}% tổng số</span>
			</div>
		</div>
	</div>
</div>

<!-- Filters Bar -->
<div class="topic-table-card" style="padding:16px 20px;margin-bottom:20px;">
	<div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;">
		<div class="search-box" style="flex:1;min-width:240px;">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm tài khoản..." onkeyup="filterUsers()">
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Vai trò</label>
			<select id="roleFilter" onchange="filterUsers()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="STUDENT">Sinh viên</option>
				<option value="LECTURER">Giảng viên</option>
				<option value="ADMIN">Quản trị viên</option>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Trạng thái</label>
			<select id="statusFilter" onchange="filterUsers()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="ACTIVE">Hoạt động</option>
				<option value="LOCKED">Bị khóa</option>
				<option value="INACTIVE">Tạm ngưng</option>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Khoa / Bộ môn</label>
			<select id="deptFilter" onchange="filterUsers()" class="semester-picker-select" style="min-width:160px;">
				<option value="ALL">Tất cả</option>
				<option value="Công nghệ thông tin">Công nghệ thông tin</option>
				<option value="Kỹ thuật phần mềm">Kỹ thuật phần mềm</option>
				<option value="Hệ thống thông tin">Hệ thống thông tin</option>
				<option value="Khoa học máy tính">Khoa học máy tính</option>
			</select>
		</div>
		<button type="button" class="btn-filter" onclick="resetFilters()">🔄 Đặt lại</button>
	</div>
</div>

<!-- Table Card -->
<div class="topic-table-card">
	<div class="table-responsive">
		<table class="topic-data-table" id="userTable">
			<thead>
				<tr>
					<th style="width:50px">STT</th>
					<th>Họ và tên</th>
					<th>Email</th>
					<th style="width:120px">Vai trò</th>
					<th style="width:180px">Khoa / Bộ môn</th>
					<th style="width:120px">Trạng thái</th>
					<th style="width:140px">Ngày tạo</th>
					<th style="width:110px;text-align:center">Thao tác</th>
				</tr>
			</thead>
			<tbody id="userTbody">
				<c:choose>
					<c:when test="${empty users}">
						<tr>
							<td colspan="8" class="table-empty">Chưa có tài khoản nào trong hệ thống</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="u" items="${users}" varStatus="loop">
							<tr class="user-row" 
								data-role="${u.role}" 
								data-status="${u.status}" 
								data-dept="${not empty u.department ? u.department : (not empty u.class_code ? u.class_code : 'Khác')}"
								data-search="${u.full_name} ${u.username} ${u.email}">
								<td>${loop.index + 1}</td>
								<td>
									<div style="display:flex;align-items:center;gap:10px;">
										<div class="admin-avatar" style="width:34px;height:34px;font-size:13px;flex-shrink:0;background:${u.role=='ADMIN'?'#7c3aed':(u.role=='LECTURER'?'#2563eb':'#10b981')};color:white">
											<c:choose>
												<c:when test="${not empty u.full_name}">
													${fn:substring(u.full_name, 0, 1)}
												</c:when>
												<c:otherwise>U</c:otherwise>
											</c:choose>
										</div>
										<div>
											<strong style="color:#0f172a;display:block;">${u.full_name}</strong>
											<small style="color:#64748b;font-size:11px;">@${u.username}</small>
										</div>
									</div>
								</td>
								<td><span style="color:#334155;">${u.email}</span></td>
								<td>
									<c:choose>
										<c:when test="${u.role == 'ADMIN'}">
											<span class="status-pill purple">Quản trị</span>
										</c:when>
										<c:when test="${u.role == 'LECTURER'}">
											<span class="status-pill blue">Giảng viên</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill green">Sinh viên</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${u.role == 'STUDENT'}">
											<span style="color:#475569;font-weight:600;">${not empty u.class_code ? u.class_code : 'Chưa phân lớp'}</span>
										</c:when>
										<c:when test="${u.role == 'LECTURER'}">
											<span style="color:#475569;font-weight:600;">${not empty u.department ? u.department : 'CNTT'}</span>
										</c:when>
										<c:otherwise>
											<span style="color:#94a3b8;">Hệ thống</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${u.status == 'ACTIVE'}">
											<span class="status-pill green">✓ Hoạt động</span>
										</c:when>
										<c:when test="${u.status == 'LOCKED'}">
											<span class="status-pill red">🔒 Bị khóa</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill orange">⏱ Tạm ngưng</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<small style="color:#64748b;">
										<c:choose>
											<c:when test="${not empty u.created_at}">${u.created_at}</c:when>
											<c:otherwise>18/06/2024</c:otherwise>
										</c:choose>
									</small>
								</td>
								<td style="text-align:center;">
									<div class="row-actions" style="justify-content:center;">
										<button type="button" class="btn-icon-act edit" title="Đổi trạng thái" onclick="openStatusModal('${u.id}', '${u.full_name}', '${u.status}')">✏️</button>
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
			Hiển thị 1 đến ${fn:length(users)} của ${fn:length(users)} tài khoản
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

<!-- Modal Thêm tài khoản -->
<div class="custom-modal" id="addUserModal">
	<div class="modal-container" style="max-width:650px;">
		<div class="modal-header-custom">
			<h2>Thêm tài khoản mới</h2>
			<button class="modal-close-btn" onclick="closeAddModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/users">
			<div class="modal-body-custom">
				<div class="row" style="grid-template-columns:1fr 1fr;gap:16px;">
					<div>
						<div class="form-group">
							<label>Tên tài khoản (Username) *</label>
							<input name="username" required placeholder="nhap_username">
						</div>
						<div class="form-group">
							<label>Email *</label>
							<input type="email" name="email" required placeholder="user@university.edu.vn">
						</div>
						<div class="form-group">
							<label>Mật khẩu *</label>
							<input type="password" name="password" required placeholder="••••••••">
						</div>
						<div class="form-group">
							<label>Họ và tên *</label>
							<input name="fullName" required placeholder="Nguyễn Văn A">
						</div>
					</div>
					<div>
						<div class="form-group">
							<label>Số điện thoại</label>
							<input name="phone" placeholder="0901234567">
						</div>
						<div class="form-group">
							<label>Vai trò *</label>
							<select name="role" id="roleSelect" onchange="toggleRoleFields()">
								<option value="STUDENT">Sinh viên</option>
								<option value="LECTURER">Giảng viên</option>
								<option value="ADMIN">Quản trị viên</option>
							</select>
						</div>
						<div class="form-group">
							<label>Mã SV / GV</label>
							<input name="code" placeholder="SV12345 / GV123">
						</div>
						<div class="form-group" id="classGroup">
							<label>Lớp học (Dành cho Sinh viên)</label>
							<select name="classId">
								<option value="">-- Chọn lớp --</option>
								<c:forEach var="c" items="${classes}">
									<option value="${c.id}">${c.code} - ${c.name}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group" id="deptGroup" style="display:none;">
							<label>Khoa / Bộ môn (Dành cho Giảng viên)</label>
							<input name="department" placeholder="Công nghệ thông tin">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeAddModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Lưu tài khoản</button>
			</div>
		</form>
	</div>
</div>

<!-- Modal Cập nhật Trạng thái -->
<div class="custom-modal" id="statusUserModal">
	<div class="modal-container" style="max-width:440px;">
		<div class="modal-header-custom">
			<h2>Cập nhật trạng thái</h2>
			<button class="modal-close-btn" onclick="closeStatusModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/user-status">
			<input type="hidden" name="id" id="statusUserId">
			<div class="modal-body-custom">
				<p id="statusUserName" style="font-weight:700;color:#0f172a;margin-bottom:14px;"></p>
				<div class="form-group">
					<label>Trạng thái tài khoản</label>
					<select name="status" id="statusSelect">
						<option value="ACTIVE">✓ ACTIVE (Hoạt động)</option>
						<option value="LOCKED">🔒 LOCKED (Khóa)</option>
						<option value="INACTIVE">⏱ INACTIVE (Tạm ngưng)</option>
					</select>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeStatusModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Cập nhật</button>
			</div>
		</form>
	</div>
</div>

<script>
function openAddModal() {
	document.getElementById('addUserModal').classList.add('show');
	toggleRoleFields();
}
function closeAddModal() {
	document.getElementById('addUserModal').classList.remove('show');
}
function openStatusModal(id, name, status) {
	document.getElementById('statusUserId').value = id;
	document.getElementById('statusUserName').innerText = "Tài khoản: " + name;
	document.getElementById('statusSelect').value = status;
	document.getElementById('statusUserModal').classList.add('show');
}
function closeStatusModal() {
	document.getElementById('statusUserModal').classList.remove('show');
}
function toggleRoleFields() {
	var role = document.getElementById('roleSelect').value;
	var classGrp = document.getElementById('classGroup');
	var deptGrp = document.getElementById('deptGroup');
	if (role === 'STUDENT') {
		classGrp.style.display = 'block';
		deptGrp.style.display = 'none';
	} else if (role === 'LECTURER') {
		classGrp.style.display = 'none';
		deptGrp.style.display = 'block';
	} else {
		classGrp.style.display = 'none';
		deptGrp.style.display = 'none';
	}
}

function filterUsers() {
	var search = document.getElementById('searchInput').value.toLowerCase();
	var role = document.getElementById('roleFilter').value;
	var status = document.getElementById('statusFilter').value;
	var dept = document.getElementById('deptFilter').value;
	var rows = document.querySelectorAll('#userTbody .user-row');
	var visibleCount = 0;

	rows.forEach(function(row) {
		var rRole = row.getAttribute('data-role');
		var rStatus = row.getAttribute('data-status');
		var rDept = row.getAttribute('data-dept');
		var rSearch = row.getAttribute('data-search').toLowerCase();

		var matchSearch = !search || rSearch.indexOf(search) > -1;
		var matchRole = role === 'ALL' || rRole === role;
		var matchStatus = status === 'ALL' || rStatus === status;
		var matchDept = dept === 'ALL' || rDept.indexOf(dept) > -1;

		if (matchSearch && matchRole && matchStatus && matchDept) {
			row.style.display = '';
			visibleCount++;
		} else {
			row.style.display = 'none';
		}
	});

	document.getElementById('paginationInfo').innerText = 'Hiển thị 1 đến ' + visibleCount + ' của ' + visibleCount + ' tài khoản';
}

function resetFilters() {
	document.getElementById('searchInput').value = '';
	document.getElementById('roleFilter').value = 'ALL';
	document.getElementById('statusFilter').value = 'ALL';
	document.getElementById('deptFilter').value = 'ALL';
	filterUsers();
}
</script>

<%@ include file="../common/footer.jsp"%>

