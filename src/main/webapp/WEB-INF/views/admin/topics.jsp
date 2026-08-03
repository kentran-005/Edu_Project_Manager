<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Xem đề tài</h1>
		<p>Danh sách các đề tài dự án trong hệ thống</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-add-primary" onclick="openAddTopicModal()">+ Thêm đề tài</button>
	</div>
</div>

<!-- 4 Stats Cards Grid -->
<c:set var="totalTopics" value="${fn:length(topics)}" />
<c:set var="approvedTopics" value="0" />
<c:set var="inProgressTopics" value="0" />
<c:set var="canceledTopics" value="0" />
<c:forEach var="t" items="${topics}">
	<c:choose>
		<c:when test="${t.status == 'APPROVED' || t.status == 'OPEN'}"><c:set var="approvedTopics" value="${approvedTopics + 1}" /></c:when>
		<c:when test="${t.status == 'ASSIGNED' || t.status == 'IN_PROGRESS'}"><c:set var="inProgressTopics" value="${inProgressTopics + 1}" /></c:when>
		<c:when test="${t.status == 'CLOSED' || t.status == 'REJECTED'}"><c:set var="canceledTopics" value="${canceledTopics + 1}" /></c:when>
		<c:otherwise><c:set var="approvedTopics" value="${approvedTopics + 1}" /></c:otherwise>
	</c:choose>
</c:forEach>

<div class="reg-stats-grid">
	<!-- Card 1: Tổng số đề tài -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">📄</div>
			<div class="stat-card-info">
				<label>Tổng số đề tài</label>
				<strong>${totalTopics}</strong>
				<span class="stat-card-sub">Tất cả đề tài</span>
			</div>
		</div>
	</div>

	<!-- Card 2: Đã phê duyệt -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">✓</div>
			<div class="stat-card-info">
				<label>Đã phê duyệt</label>
				<strong>${approvedTopics}</strong>
				<span class="stat-card-sub">${totalTopics > 0 ? String.format("%.1f", (approvedTopics * 100.0) / totalTopics) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 3: Đang thực hiện -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">⏳</div>
			<div class="stat-card-info">
				<label>Đang thực hiện</label>
				<strong>${inProgressTopics}</strong>
				<span class="stat-card-sub">${totalTopics > 0 ? String.format("%.1f", (inProgressTopics * 100.0) / totalTopics) : '0'}% tổng số</span>
			</div>
		</div>
	</div>

	<!-- Card 4: Đã hủy -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon purple">✕</div>
			<div class="stat-card-info">
				<label>Đã hủy / Đóng</label>
				<strong>${canceledTopics}</strong>
				<span class="stat-card-sub">${totalTopics > 0 ? String.format("%.1f", (canceledTopics * 100.0) / totalTopics) : '0'}% tổng số</span>
			</div>
		</div>
	</div>
</div>

<!-- Filters Bar -->
<div class="topic-table-card" style="padding:16px 20px;margin-bottom:20px;">
	<div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;">
		<div class="search-box" style="flex:1;min-width:240px;">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm đề tài, mô tả, giảng viên..." onkeyup="filterTopics()">
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Học kỳ</label>
			<select id="semesterFilter" onchange="filterTopics()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<c:forEach var="s" items="${semesters}">
					<option value="${s.name}">${s.name}</option>
				</c:forEach>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Lớp</label>
			<select id="classFilter" onchange="filterTopics()" class="semester-picker-select" style="min-width:130px;">
				<option value="ALL">Tất cả</option>
				<c:forEach var="c" items="${classes}">
					<option value="${c.code}">${c.code}</option>
				</c:forEach>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Trạng thái</label>
			<select id="statusFilter" onchange="filterTopics()" class="semester-picker-select" style="min-width:140px;">
				<option value="ALL">Tất cả</option>
				<option value="APPROVED">Đã phê duyệt</option>
				<option value="IN_PROGRESS">Đang thực hiện</option>
				<option value="PENDING">Chờ phê duyệt</option>
				<option value="CLOSED">Đã hủy</option>
			</select>
		</div>
		<div style="display:flex;align-items:center;gap:8px;">
			<label style="margin:0;font-size:13px;color:#64748b;font-weight:700;">Người hướng dẫn</label>
			<select id="lecturerFilter" onchange="filterTopics()" class="semester-picker-select" style="min-width:160px;">
				<option value="ALL">Tất cả</option>
				<c:forEach var="l" items="${lecturers}">
					<option value="${l.full_name}">${l.full_name}</option>
				</c:forEach>
			</select>
		</div>
		<button type="button" class="btn-filter" onclick="resetFilters()">🔄 Đặt lại</button>
	</div>
</div>

<!-- Table Card -->
<div class="topic-table-card">
	<div class="table-responsive">
		<table class="topic-data-table" id="topicTable">
			<thead>
				<tr>
					<th style="width:50px">STT</th>
					<th>Tên đề tài</th>
					<th style="width:110px">Lớp</th>
					<th style="width:110px">Nhóm</th>
					<th style="width:170px">Giảng viên hướng dẫn</th>
					<th style="width:120px">Học kỳ</th>
					<th style="width:130px">Trạng thái</th>
					<th style="width:120px">Ngày tạo</th>
					<th style="width:100px;text-align:center">Thao tác</th>
				</tr>
			</thead>
			<tbody id="topicTbody">
				<c:choose>
					<c:when test="${empty topics}">
						<tr>
							<td colspan="9" class="table-empty">Chưa có đề tài nào trong hệ thống</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="t" items="${topics}" varStatus="loop">
							<tr class="topic-row"
								data-semester="${not empty t.semester_name ? t.semester_name : 'HK2023-2'}"
								data-class="${not empty t.class_code ? t.class_code : 'SE2021_01'}"
								data-status="${not empty t.status ? t.status : 'APPROVED'}"
								data-lecturer="${not empty t.lecturer_name ? t.lecturer_name : 'Giảng viên'}"
								data-search="${t.title} ${t.description} ${t.lecturer_name}">
								<td>${loop.index + 1}</td>
								<td>
									<div class="topic-title-cell" style="font-weight:700;color:#1e40af;">${t.title}</div>
									<small style="color:#64748b;display:block;margin-top:2px;">${fn:substring(t.description, 0, 45)}...</small>
								</td>
								<td><span style="color:#475569;font-weight:600;">${not empty t.class_code ? t.class_code : 'SE2021_01'}</span></td>
								<td><span style="color:#475569;">${not empty t.group_name ? t.group_name : 'Nhóm 1'}</span></td>
								<td><span style="color:#0f172a;font-weight:600;">${not empty t.lecturer_name ? t.lecturer_name : 'Giảng viên'}</span></td>
								<td><span style="color:#475569;">${not empty t.semester_name ? t.semester_name : 'HK2023-2'}</span></td>
								<td>
									<c:choose>
										<c:when test="${t.status == 'ASSIGNED' || t.status == 'IN_PROGRESS'}">
											<span class="status-pill blue">Đang thực hiện</span>
										</c:when>
										<c:when test="${t.status == 'DRAFT' || t.status == 'PENDING'}">
											<span class="status-pill orange">Chờ phê duyệt</span>
										</c:when>
										<c:when test="${t.status == 'CLOSED' || t.status == 'REJECTED'}">
											<span class="status-pill purple" style="background:#ede9fe;color:#7c3aed;">Đã hủy</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill green">Đã phê duyệt</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td><small style="color:#64748b;">${not empty t.created_at ? t.created_at : '10/05/2024'}</small></td>
								<td style="text-align:center;">
									<div class="row-actions" style="justify-content:center;">
										<button type="button" class="btn-icon-act view" title="Xem" onclick="viewTopicDetail('${t.title}', '${fn:escapeXml(t.description)}', '${t.lecturer_name}', '${t.semester_name}', '${t.status}')">👁️</button>
										<button type="button" class="btn-icon-act edit" title="Sửa" onclick="openEditTopicModal('${t.id}', '${t.title}', '${fn:escapeXml(t.description)}', '${t.status}')">✏️</button>
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
			Hiển thị 1 đến ${fn:length(topics)} của ${fn:length(topics)} đề tài
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

<!-- Modal Thêm đề tài -->
<div class="custom-modal" id="addTopicModal">
	<div class="modal-container" style="max-width:600px;">
		<div class="modal-header-custom">
			<h2>Thêm đề tài mới</h2>
			<button class="modal-close-btn" onclick="closeAddTopicModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/topics">
			<div class="modal-body-custom">
				<div class="form-group">
					<label>Tên đề tài *</label>
					<input name="title" required placeholder="Ví dụ: Website bán hàng trực tuyến">
				</div>
				<div class="form-group">
					<label>Mô tả chi tiết *</label>
					<textarea name="description" required placeholder="Nêu rõ mục tiêu và tính năng chính..."></textarea>
				</div>
				<div class="row" style="grid-template-columns:1fr 1fr;gap:14px;">
					<div class="form-group">
						<label>Giảng viên hướng dẫn *</label>
						<select name="lecturerId" required>
							<c:forEach var="l" items="${lecturers}">
								<option value="${l.id}">${l.full_name}</option>
							</c:forEach>
						</select>
					</div>
					<div class="form-group">
						<label>Học kỳ *</label>
						<select name="semesterId" required>
							<c:forEach var="s" items="${semesters}">
								<option value="${s.id}">${s.name}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label>Trạng thái</label>
					<select name="status">
						<option value="APPROVED">Đã phê duyệt</option>
						<option value="OPEN">Còn nhận (OPEN)</option>
						<option value="PENDING">Chờ phê duyệt</option>
						<option value="CLOSED">Đã hủy / Đóng</option>
					</select>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeAddTopicModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Lưu đề tài</button>
			</div>
		</form>
	</div>
</div>

<!-- Modal Xem Chi Tiết Đề Tài -->
<div class="custom-modal" id="viewTopicModal">
	<div class="modal-container" style="max-width:550px;">
		<div class="modal-header-custom">
			<h2>Chi tiết đề tài</h2>
			<button class="modal-close-btn" onclick="closeViewTopicModal()">✕</button>
		</div>
		<div class="modal-body-custom">
			<h3 id="viewTopicTitle" style="color:#1e40af;margin-top:0;font-size:18px;"></h3>
			<p style="color:#64748b;font-size:13px;" id="viewTopicMeta"></p>
			<hr style="border:0;border-top:1px solid #e2e8f0;margin:14px 0;">
			<label style="font-weight:700;color:#0f172a;display:block;margin-bottom:6px;">Mô tả chi tiết:</label>
			<p id="viewTopicDesc" style="color:#334155;line-height:1.6;white-space:pre-wrap;margin:0;"></p>
		</div>
		<div class="modal-footer-custom">
			<button type="button" class="btn-secondary-custom" onclick="closeViewTopicModal()">Đóng</button>
		</div>
	</div>
</div>

<!-- Modal Sửa Đề Tài -->
<div class="custom-modal" id="editTopicModal">
	<div class="modal-container" style="max-width:600px;">
		<div class="modal-header-custom">
			<h2>Chỉnh sửa đề tài</h2>
			<button class="modal-close-btn" onclick="closeEditTopicModal()">✕</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/admin/update-topic">
			<input type="hidden" name="id" id="editTopicId">
			<div class="modal-body-custom">
				<div class="form-group">
					<label>Tên đề tài *</label>
					<input name="title" id="editTopicTitle" required>
				</div>
				<div class="form-group">
					<label>Mô tả chi tiết *</label>
					<textarea name="description" id="editTopicDesc" required></textarea>
				</div>
				<div class="form-group">
					<label>Trạng thái *</label>
					<select name="status" id="editTopicStatus">
						<option value="APPROVED">Đã phê duyệt</option>
						<option value="OPEN">Còn nhận (OPEN)</option>
						<option value="ASSIGNED">Đang thực hiện (ASSIGNED)</option>
						<option value="DRAFT">Chờ phê duyệt (DRAFT)</option>
						<option value="CLOSED">Đã hủy / Đóng (CLOSED)</option>
					</select>
				</div>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeEditTopicModal()">Hủy</button>
				<button type="submit" class="btn-add-primary">Cập nhật</button>
			</div>
		</form>
	</div>
</div>

<script>
function openAddTopicModal() {
	document.getElementById('addTopicModal').classList.add('show');
}
function closeAddTopicModal() {
	document.getElementById('addTopicModal').classList.remove('show');
}

function viewTopicDetail(title, desc, lecturer, semester, status) {
	document.getElementById('viewTopicTitle').innerText = title;
	document.getElementById('viewTopicMeta').innerText = "Giảng viên: " + lecturer + " • Học kỳ: " + semester + " • Trạng thái: " + status;
	document.getElementById('viewTopicDesc').innerText = desc;
	document.getElementById('viewTopicModal').classList.add('show');
}
function closeViewTopicModal() {
	document.getElementById('viewTopicModal').classList.remove('show');
}

function openEditTopicModal(id, title, desc, status) {
	document.getElementById('editTopicId').value = id;
	document.getElementById('editTopicTitle').value = title;
	document.getElementById('editTopicDesc').value = desc;
	document.getElementById('editTopicStatus').value = status;
	document.getElementById('editTopicModal').classList.add('show');
}
function closeEditTopicModal() {
	document.getElementById('editTopicModal').classList.remove('show');
}

function filterTopics() {
	var search = document.getElementById('searchInput').value.toLowerCase();
	var sem = document.getElementById('semesterFilter').value;
	var cls = document.getElementById('classFilter').value;
	var status = document.getElementById('statusFilter').value;
	var lec = document.getElementById('lecturerFilter').value;
	var rows = document.querySelectorAll('#topicTbody .topic-row');
	var visibleCount = 0;

	rows.forEach(function(row) {
		var rSem = row.getAttribute('data-semester');
		var rCls = row.getAttribute('data-class');
		var rStatus = row.getAttribute('data-status');
		var rLec = row.getAttribute('data-lecturer');
		var rSearch = row.getAttribute('data-search').toLowerCase();

		var matchSearch = !search || rSearch.indexOf(search) > -1;
		var matchSem = sem === 'ALL' || rSem.indexOf(sem) > -1;
		var matchCls = cls === 'ALL' || rCls.indexOf(cls) > -1;
		var matchStatus = status === 'ALL' || rStatus === status;
		var matchLec = lec === 'ALL' || rLec.indexOf(lec) > -1;

		if (matchSearch && matchSem && matchCls && matchStatus && matchLec) {
			row.style.display = '';
			visibleCount++;
		} else {
			row.style.display = 'none';
		}
	});

	document.getElementById('paginationInfo').innerText = 'Hiển thị 1 đến ' + visibleCount + ' của ' + visibleCount + ' đề tài';
}

function resetFilters() {
	document.getElementById('searchInput').value = '';
	document.getElementById('semesterFilter').value = 'ALL';
	document.getElementById('classFilter').value = 'ALL';
	document.getElementById('statusFilter').value = 'ALL';
	document.getElementById('lecturerFilter').value = 'ALL';
	filterTopics();
}
</script>

<%@ include file="../common/footer.jsp"%>
