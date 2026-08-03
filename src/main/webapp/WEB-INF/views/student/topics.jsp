<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Danh sách đề tài</h1>
		<p>Khám phá và đăng ký đề tài đồ án môn học / tốt nghiệp cho học kỳ hiện tại</p>
	</div>
	<div class="page-header-actions">
		<div class="search-box">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm đề tài, giảng viên..." onkeyup="filterTopics()">
		</div>
		<button type="button" class="btn-filter" onclick="resetFilters()">🔄 Làm mới</button>
	</div>
</div>

<!-- Filter Bar -->
<div class="row" style="margin-bottom: 20px; grid-template-columns: repeat(4, 1fr); gap: 14px;">
	<div>
		<label style="font-size:12px; margin-bottom:4px; color:#64748b;">Học kỳ</label>
		<select id="semesterFilter" onchange="filterTopics()" style="margin:0;">
			<option value="ALL">Tất cả học kỳ</option>
			<c:forEach var="s" items="${semesters}">
				<option value="${s.name}">${s.name}</option>
			</c:forEach>
		</select>
	</div>
	<div>
		<label style="font-size:12px; margin-bottom:4px; color:#64748b;">Công nghệ</label>
		<select id="techFilter" onchange="filterTopics()" style="margin:0;">
			<option value="ALL">Tất cả công nghệ</option>
			<option value="Java">Java / Spring Boot</option>
			<option value="React">ReactJS / Node.js</option>
			<option value=".NET">.NET Core / C#</option>
			<option value="Python">Python / AI / Machine Learning</option>
			<option value="Mobile">Flutter / React Native</option>
		</select>
	</div>
	<div>
		<label style="font-size:12px; margin-bottom:4px; color:#64748b;">Trạng thái</label>
		<select id="statusFilter" onchange="filterTopics()" style="margin:0;">
			<option value="ALL">Tất cả trạng thái</option>
			<option value="OPEN">Còn nhận</option>
			<option value="CLOSED">Đã đủ / Đã đóng</option>
		</select>
	</div>
	<div style="display:flex; align-items:flex-end;">
		<button type="button" class="btn-filter" style="width:100%; justify-content:center;" onclick="resetFilters()">Làm mới lọc</button>
	</div>
</div>

<!-- Topic Table Card -->
<div class="topic-table-card">
	<div class="card-title-head">
		<h3>Danh sách đề tài có sẵn</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table" id="topicsTable">
			<thead>
				<tr>
					<th style="width:50px">#</th>
					<th>Tên đề tài</th>
					<th style="width:160px">Giảng viên</th>
					<th style="width:140px">Học kỳ</th>
					<th style="width:180px">Công nghệ</th>
					<th style="width:130px; text-align:center">Số TV tối đa</th>
					<th style="width:110px">Trạng thái</th>
					<th style="width:120px; text-align:center">Hành động</th>
				</tr>
			</thead>
			<tbody id="topicsTbody">
				<c:choose>
					<c:when test="${empty topics}">
						<tr>
							<td colspan="8" class="table-empty">Chưa có đề tài nào được công bố cho học kỳ này.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="t" items="${topics}" varStatus="loop">
							<tr class="topic-row" 
								data-status="${t.status}" 
								data-title="${fn:toLowerCase(t.title)}" 
								data-lecturer="${fn:toLowerCase(t.lecturer_name)}"
								data-tech="${fn:toLowerCase(t.technology)}" 
								data-semester="${t.semester_name}">
								<td>${loop.index + 1}</td>
								<td>
									<div class="topic-title-cell" title="${t.title}" style="font-weight:700; color:#0f172a;">${t.title}</div>
								</td>
								<td>
									<div style="display:flex; align-items:center; gap:8px;">
										<span style="width:26px; height:26px; border-radius:50%; background:#dbeafe; color:#1d4ed8; display:grid; place-items:center; font-size:11px; font-weight:800;">GV</span>
										<span>${not empty t.lecturer_name ? t.lecturer_name : 'Giảng viên'}</span>
									</div>
								</td>
								<td><span class="topic-code-tag">${not empty t.semester_name ? t.semester_name : 'HK2 2023 - 2024'}</span></td>
								<td><span style="font-size:13px; color:#475569;">${not empty t.technology ? t.technology : 'Chưa xác định'}</span></td>
								<td style="text-align:center; font-weight:700;">${not empty t.max_members ? t.max_members : 5}</td>
								<td>
									<c:choose>
										<c:when test="${t.status=='OPEN'}">
											<span class="status-pill green">Còn nhận</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill red">Đã đủ</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<div class="row-actions" style="justify-content:center">
										<button type="button" class="btn-icon-act view" title="Xem chi tiết" 
											onclick="openStudentViewModal('${t.id}', '${fn:escapeXml(t.title)}', '${fn:escapeXml(t.description)}', '${fn:escapeXml(t.requirements)}', '${fn:escapeXml(t.technology)}', '${t.max_members}', '${t.semester_name}', '${fn:escapeXml(t.lecturer_name)}', '${t.status}')">
											👁
										</button>
										<c:choose>
											<c:when test="${t.status=='OPEN'}">
												<a class="btn-add-primary" style="padding: 5px 12px!important; font-size: 12px!important; border-radius: 8px!important;" href="${pageContext.request.contextPath}/groups">
													✎ Đăng ký
												</a>
											</c:when>
											<c:otherwise>
												<button type="button" class="btn-secondary-custom" style="padding: 5px 10px!important; font-size: 12px!important; opacity:0.6;" disabled>
													Xem chi tiết
												</button>
											</c:otherwise>
										</c:choose>
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
		<div class="pagination-info" id="paginationInfo">
			Hiển thị <span id="showingCount">1 đến ${fn:length(topics) > 10 ? 10 : fn:length(topics)}</span> trong tổng số <strong>${fn:length(topics)}</strong> đề tài
		</div>
		<div class="pagination-controls">
			<select class="rows-per-page-select" onchange="changeRowsPerPage(this.value)">
				<option value="10" selected>10 / trang</option>
				<option value="20">20 / trang</option>
				<option value="50">50 / trang</option>
			</select>
			<div class="page-btn-group">
				<button type="button" class="page-num-btn">&lt;</button>
				<button type="button" class="page-num-btn active">1</button>
				<button type="button" class="page-num-btn">&gt;</button>
			</div>
		</div>
	</div>
</div>

<!-- Modal: View Topic Detail Modal (Student view) -->
<div class="custom-modal" id="studentViewTopicModal">
	<div class="modal-container">
		<div class="modal-header-custom">
			<h2>👁 Chi tiết đề tài đồ án</h2>
			<button type="button" class="modal-close-btn" onclick="closeModal('studentViewTopicModal')">&times;</button>
		</div>
		<div class="modal-body-custom">
			<div style="margin-bottom:16px">
				<span class="topic-code-tag" id="sViewCode">DT2024_001</span>
				<h3 id="sViewTitle" style="margin:8px 0 4px;font-size:20px;color:#0f172a">Tên đề tài</h3>
				<span id="sViewStatusBadge"></span>
			</div>
			<div class="row" style="margin-bottom:16px;background:#f8fafc;padding:16px;border-radius:12px">
				<div>
					<small style="color:#64748b;display:block">Giảng viên hướng dẫn</small>
					<strong id="sViewLecturer" style="color:#0f172a">--</strong>
				</div>
				<div>
					<small style="color:#64748b;display:block">Học kỳ</small>
					<strong id="sViewSemester" style="color:#0f172a">--</strong>
				</div>
				<div>
					<small style="color:#64748b;display:block">Công nghệ</small>
					<strong id="sViewTech" style="color:#0f172a">--</strong>
				</div>
				<div>
					<small style="color:#64748b;display:block">Số TV tối đa</small>
					<strong id="sViewMembers" style="color:#0f172a">--</strong>
				</div>
			</div>
			<div style="margin-bottom:16px">
				<label style="color:#475569">Mô tả đề tài:</label>
				<div id="sViewDesc" style="background:#f8fafc;padding:12px;border-radius:10px;font-size:14px;white-space:pre-wrap">--</div>
			</div>
			<div>
				<label style="color:#475569">Yêu cầu đồ án:</label>
				<div id="sViewReq" style="background:#f8fafc;padding:12px;border-radius:10px;font-size:14px;white-space:pre-wrap">--</div>
			</div>
		</div>
		<div class="modal-footer-custom">
			<button type="button" class="btn-secondary-custom" onclick="closeModal('studentViewTopicModal')">Đóng</button>
			<a id="sRegBtn" class="btn-add-primary" href="${pageContext.request.contextPath}/groups">Đăng ký đề tài này →</a>
		</div>
	</div>
</div>

<script>
	function openStudentViewModal(id, title, description, requirements, technology, maxMembers, semesterName, lecturerName, status) {
		document.getElementById('sViewCode').innerText = 'DT2024_00' + id;
		document.getElementById('sViewTitle').innerText = title;
		document.getElementById('sViewLecturer').innerText = lecturerName || 'Chưa phân công';
		document.getElementById('sViewDesc').innerText = description || 'Chưa có mô tả';
		document.getElementById('sViewReq').innerText = requirements || 'Chưa có yêu cầu đặc biệt';
		document.getElementById('sViewTech').innerText = technology || 'Chưa xác định';
		document.getElementById('sViewMembers').innerText = maxMembers + ' sinh viên';
		document.getElementById('sViewSemester').innerText = semesterName || 'Học kỳ hiện tại';

		var badgeHtml = '<span class="status-pill green">Còn nhận</span>';
		if (status !== 'OPEN') badgeHtml = '<span class="status-pill red">Đã đủ / Đã đóng</span>';
		document.getElementById('sViewStatusBadge').innerHTML = badgeHtml;

		var regBtn = document.getElementById('sRegBtn');
		if (status !== 'OPEN') {
			regBtn.style.display = 'none';
		} else {
			regBtn.style.display = 'inline-flex';
		}

		document.getElementById('studentViewTopicModal').classList.add('show');
	}

	function closeModal(modalId) {
		document.getElementById(modalId).classList.remove('show');
	}

	function filterTopics() {
		var query = document.getElementById('searchInput').value.toLowerCase();
		var semester = document.getElementById('semesterFilter').value;
		var tech = document.getElementById('techFilter').value.toLowerCase();
		var status = document.getElementById('statusFilter').value;

		var rows = document.querySelectorAll('.topic-row');
		var visibleCount = 0;

		rows.forEach(function (row) {
			var rTitle = row.getAttribute('data-title') || '';
			var rLecturer = row.getAttribute('data-lecturer') || '';
			var rTech = row.getAttribute('data-tech') || '';
			var rStatus = row.getAttribute('data-status') || '';
			var rSemester = row.getAttribute('data-semester') || '';

			var matchQuery = !query || rTitle.indexOf(query) !== -1 || rLecturer.indexOf(query) !== -1 || rTech.indexOf(query) !== -1;
			var matchSemester = (semester === 'ALL') || (rSemester === semester);
			var matchTech = (tech === 'ALL') || (rTech.indexOf(tech) !== -1);
			var matchStatus = (status === 'ALL') || (rStatus === status);

			if (matchQuery && matchSemester && matchTech && matchStatus) {
				row.style.display = '';
				visibleCount++;
			} else {
				row.style.display = 'none';
			}
		});

		document.getElementById('showingCount').innerText = '1 đến ' + (visibleCount > 10 ? 10 : visibleCount);
	}

	function resetFilters() {
		document.getElementById('searchInput').value = '';
		document.getElementById('semesterFilter').value = 'ALL';
		document.getElementById('techFilter').value = 'ALL';
		document.getElementById('statusFilter').value = 'ALL';
		filterTopics();
	}
</script>

<%@ include file="../common/footer.jsp" %>

