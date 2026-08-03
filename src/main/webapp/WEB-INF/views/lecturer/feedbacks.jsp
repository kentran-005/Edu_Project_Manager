<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Page Header & Action Controls -->
<div class="page-header-row">
	<div class="page-title-box">
		<h1>Nhận xét</h1>
		<p>Xem và gửi nhận xét cho các nhóm sinh viên</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-add-primary" onclick="openAddFeedbackModal()">+ Viết nhận xét mới</button>
		<div class="search-box">
			<span class="search-icon">🔍</span>
			<input type="text" id="searchInput" placeholder="Tìm kiếm đề tài, nhóm..." onkeyup="filterFeedbackGroups()">
		</div>
		<button type="button" class="btn-filter" onclick="openFilterModal()">🌪 Bộ lọc</button>
		<button type="button" class="btn-filter" onclick="openDateModal()" title="Chọn ngày">📅</button>
	</div>
</div>

<!-- 4 Stats Cards Grid -->
<div class="reg-stats-grid">
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">💬</div>
			<div class="stat-card-info">
				<label>Tổng số nhận xét</label>
				<strong>${not empty stats.total_feedbacks ? stats.total_feedbacks : fn:length(feedbacks)}</strong>
				<span class="stat-card-sub">Tất cả nhận xét</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('ALL')">Xem chi tiết →</span>
	</div>

	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">✓</div>
			<div class="stat-card-info">
				<label>Đã gửi</label>
				<strong>${not empty stats.sent_feedbacks ? stats.sent_feedbacks : fn:length(feedbacks)}</strong>
				<span class="stat-card-sub">Nhận xét đã gửi</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('SENT')">Xem chi tiết →</span>
	</div>

	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">✏️</div>
			<div class="stat-card-info">
				<label>Chờ gửi</label>
				<strong>${not empty stats.pending_feedbacks ? stats.pending_feedbacks : 0}</strong>
				<span class="stat-card-sub">Nhận xét chưa gửi</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('PENDING')">Xem chi tiết →</span>
	</div>

	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon purple">👥</div>
			<div class="stat-card-info">
				<label>Nhóm sinh viên</label>
				<strong>${not empty stats.student_groups ? stats.student_groups : fn:length(groups)}</strong>
				<span class="stat-card-sub">Đã nhận nhận xét</span>
			</div>
		</div>
		<span class="stat-card-link" onclick="filterByStatus('ALL')">Xem chi tiết →</span>
	</div>
</div>

<!-- 2-Column Split View Body Layout -->
<div class="dashboard-grid wide-left" style="gap:24px;align-items:start">
	
	<!-- LEFT COLUMN (~55%): Danh sách nhóm & nhận xét -->
	<div class="topic-table-card">
		<div class="card-title-head">
			<h3>Danh sách nhóm sinh viên</h3>
		</div>
		<div class="table-responsive">
			<table class="topic-data-table" id="feedbackTable">
				<thead>
					<tr>
						<th style="width:40px">#</th>
						<th style="width:120px">Mã đề tài</th>
						<th>Tên đề tài</th>
						<th style="width:100px">Nhóm</th>
						<th style="width:130px">Trạng thái nhận xét</th>
						<th style="width:40px"></th>
					</tr>
				</thead>
				<tbody id="feedbackTbody">
					<c:choose>
						<c:when test="${empty feedbacks}">
							<tr>
								<td colspan="6" class="table-empty">Hiện tại bạn chưa gửi nhận xét nào. Nhấn "+ Viết nhận xét mới" để tạo nhận xét.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="f" items="${feedbacks}" varStatus="loop">
								<tr class="fb-row ${loop.first ? 'selected-row' : ''}" style="cursor:pointer"
									onclick="selectFeedbackGroup(this, '${f.id}', 'DT2024_00${f.topic_id}', '${fn:escapeXml(f.topic_title)}', '${fn:escapeXml(f.group_name)}', '${fn:escapeXml(f.content)}', '${fn:substring(f.created_at,0,16)}', '${fn:escapeXml(f.attachment_name)}', '${f.attachment_url}')">
									<td>${loop.index + 1}</td>
									<td>
										<span class="topic-code-tag">DT2024_00${not empty f.topic_id ? f.topic_id : f.group_id}</span>
									</td>
									<td>
										<div class="topic-title-cell" title="${f.topic_title}">${f.topic_title}</div>
									</td>
									<td>${f.group_name}</td>
									<td>
										<span class="status-pill green">Đã gửi</span>
									</td>
									<td style="color:#2563eb;font-weight:900">&gt;</td>
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
				Hiển thị 1 đến ${fn:length(feedbacks) > 10 ? 10 : fn:length(feedbacks)} trong tổng số <strong>${fn:length(feedbacks)}</strong> nhận xét
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

	<!-- RIGHT COLUMN (~45%): Chi tiết nhận xét -->
	<div class="topic-table-card" style="padding:24px">
		<c:choose>
			<c:when test="${not empty feedbacks}">
				<c:set var="firstFb" value="${feedbacks[0]}"/>
				<div style="border-bottom:1px solid #f1f5f9;padding-bottom:16px;margin-bottom:20px">
					<div style="display:flex;align-items:center;justify-content:space-between;gap:12px;margin-bottom:8px">
						<h3 style="margin:0;font-size:18px;font-weight:800;color:#0f172a">Chi tiết nhận xét</h3>
						<span class="status-pill green" id="detailStatusBadge">Đã gửi</span>
					</div>
					<p id="detailTopicTitle" style="margin:0 0 6px;color:#2563eb;font-weight:800;font-size:14px">
						DT2024_00${firstFb.topic_id} - ${firstFb.topic_title}
					</p>
					<div style="display:flex;flex-wrap:wrap;gap:16px;font-size:13px;color:#64748b;margin-top:8px">
						<span><strong>Nhóm:</strong> <span id="detailGroupName" style="color:#0f172a">${firstFb.group_name}</span></span>
						<span><strong>Ngày gửi:</strong> <span id="detailSentDate" style="color:#0f172a">${fn:substring(firstFb.created_at,0,16)}</span></span>
					</div>
				</div>

				<!-- Section 1: Nhận xét của giảng viên -->
				<div style="margin-bottom:20px">
					<h4 style="margin:0 0 10px;font-size:14px;font-weight:800;color:#334155">Nội dung nhận xét của giảng viên</h4>
					<div id="detailContentBox" style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:16px;font-size:13.5px;color:#1e293b;line-height:1.6;white-space:pre-wrap">${firstFb.content}</div>
				</div>

				<!-- Section 2: Tài liệu đính kèm nếu có -->
				<div style="margin-bottom:24px" id="attachmentSection">
					<h4 style="margin:0 0 10px;font-size:14px;font-weight:800;color:#334155">Tài liệu nộp đính kèm</h4>
					<div style="display:flex;align-items:center;justify-content:space-between;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:12px 16px">
						<div style="display:flex;align-items:center;gap:12px">
							<div style="width:36px;height:36px;border-radius:8px;background:#fee2e2;color:#dc2626;display:grid;place-items:center;font-size:18px">📄</div>
							<div>
								<strong style="display:block;font-size:13px;color:#0f172a" id="detailFileName">${not empty firstFb.attachment_name ? firstFb.attachment_name : 'BaoCao_TienDo.pdf'}</strong>
								<small style="color:#64748b">File báo cáo của sinh viên</small>
							</div>
						</div>
						<a id="detailFileLink" href="${not empty firstFb.attachment_url ? firstFb.attachment_url : '#'}" target="_blank" class="btn-icon-act view" title="Tải xuống tài liệu">📥</a>
					</div>
				</div>

				<!-- Footer Actions: Edit & Delete -->
				<div style="display:flex;align-items:center;justify-content:flex-end;gap:12px">
					<button type="button" class="btn-filter" style="padding:10px 18px" onclick="openEditFeedbackModal()">✏️ Chỉnh sửa nhận xét</button>
					<form method="post" action="${pageContext.request.contextPath}/feedbacks" style="margin:0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa nhận xét này không?')">
						<input type="hidden" name="action" value="delete">
						<input type="hidden" name="id" id="detailFeedbackId" value="${firstFb.id}">
						<button type="submit" class="btn-filter" style="color:#dc2626;border-color:#fecaca;padding:10px 18px">🗑️ Xóa nhận xét</button>
					</form>
				</div>
			</c:when>
			<c:otherwise>
				<div class="empty-state" style="padding:40px 20px;text-align:center;box-shadow:none;border:0">
					<div style="font-size:48px;margin-bottom:12px">💬</div>
					<h3 style="margin:0 0 8px">Chưa có nhận xét nào</h3>
					<p style="color:#64748b;font-size:14px">Nhấn nút bên dưới để viết nhận xét mới cho nhóm sinh viên.</p>
					<button type="button" class="btn-add-primary" style="margin-top:12px" onclick="openAddFeedbackModal()">+ Viết nhận xét mới</button>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

</div>

<!-- Modal 1: Add New Feedback Modal -->
<div class="custom-modal" id="addFeedbackModal">
	<div class="modal-container" style="max-width:550px">
		<div class="modal-header-custom">
			<h2>+ Viết nhận xét mới</h2>
			<button type="button" class="modal-close-btn" onclick="closeModal('addFeedbackModal')">&times;</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/feedbacks">
			<input type="hidden" name="redirectUrl" value="/feedbacks">
			<div class="modal-body-custom">
				<label>Chọn nhóm sinh viên <span style="color:red">*</span></label>
				<select name="groupId" required style="margin-bottom:14px">
					<option value="">-- Chọn nhóm đồ án --</option>
					<c:forEach var="g" items="${groups}">
						<option value="${g.id}">${g.group_name} - ${not empty g.topic_title ? g.topic_title : 'Đồ án'}</option>
					</c:forEach>
				</select>
				
				<label>Nội dung nhận xét <span style="color:red">*</span></label>
				<textarea name="content" required style="min-height:120px" placeholder="Nhập đánh giá, ưu/nhược điểm và hướng dẫn chỉnh sửa..."></textarea>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeModal('addFeedbackModal')">Hủy</button>
				<button type="submit" class="btn-add-primary">Gửi nhận xét</button>
			</div>
		</form>
	</div>
</div>

<!-- Modal 2: Edit Feedback Modal -->
<div class="custom-modal" id="editFeedbackModal">
	<div class="modal-container" style="max-width:550px">
		<div class="modal-header-custom">
			<h2>✏️ Chỉnh sửa nhận xét</h2>
			<button type="button" class="modal-close-btn" onclick="closeModal('editFeedbackModal')">&times;</button>
		</div>
		<form method="post" action="${pageContext.request.contextPath}/feedbacks">
			<input type="hidden" name="action" value="edit">
			<input type="hidden" name="id" id="editFeedbackId">
			<div class="modal-body-custom">
				<label>Nội dung nhận xét <span style="color:red">*</span></label>
				<textarea name="content" id="editFeedbackContent" required style="min-height:140px"></textarea>
			</div>
			<div class="modal-footer-custom">
				<button type="button" class="btn-secondary-custom" onclick="closeModal('editFeedbackModal')">Hủy</button>
				<button type="submit" class="btn-add-primary">Lưu thay đổi</button>
			</div>
		</form>
	</div>
</div>

<!-- Modal 3: Filter Modal -->
<div class="custom-modal" id="filterModal">
	<div class="modal-container" style="max-width:450px">
		<div class="modal-header-custom">
			<h2>🌪 Bộ lọc dữ liệu</h2>
			<button type="button" class="modal-close-btn" onclick="closeModal('filterModal')">&times;</button>
		</div>
		<div class="modal-body-custom">
			<label>Lọc theo trạng thái:</label>
			<select id="filterStatusSelect" style="margin-bottom:14px">
				<option value="ALL">Tất cả trạng thái</option>
				<option value="SENT">Đã gửi</option>
				<option value="PENDING">Chờ gửi</option>
			</select>

			<label>Lọc theo học kỳ:</label>
			<select style="margin-bottom:14px">
				<option value="">Tất cả học kỳ</option>
				<option value="1">Học kỳ 2, 2023 - 2024</option>
				<option value="2">Học kỳ 1, 2023 - 2024</option>
			</select>
		</div>
		<div class="modal-footer-custom">
			<button type="button" class="btn-secondary-custom" onclick="resetFilters();closeModal('filterModal')">Đặt lại</button>
			<button type="button" class="btn-add-primary" onclick="applyFilterModal()">Áp dụng lọc</button>
		</div>
	</div>
</div>

<!-- Script for Actions -->
<script>
function selectFeedbackGroup(row, feedbackId, code, topicTitle, groupName, content, sentDate, fileName, fileUrl) {
	document.querySelectorAll('.fb-row').forEach(function(r) {
		r.classList.remove('selected-row');
	});
	row.classList.add('selected-row');
	
	document.getElementById('detailTopicTitle').innerText = code + ' - ' + topicTitle;
	document.getElementById('detailGroupName').innerText = groupName;
	document.getElementById('detailSentDate').innerText = sentDate;
	document.getElementById('detailContentBox').innerText = content;
	document.getElementById('detailFeedbackId').value = feedbackId;
	
	if (fileName && fileName !== 'null') {
		document.getElementById('detailFileName').innerText = fileName;
		document.getElementById('detailFileLink').href = fileUrl;
		document.getElementById('attachmentSection').style.display = 'block';
	} else {
		document.getElementById('attachmentSection').style.display = 'none';
	}
}

function openAddFeedbackModal() {
	document.getElementById('addFeedbackModal').classList.add('show');
}

function openEditFeedbackModal() {
	var currentFbId = document.getElementById('detailFeedbackId').value;
	var currentContent = document.getElementById('detailContentBox').innerText;
	document.getElementById('editFeedbackId').value = currentFbId;
	document.getElementById('editFeedbackContent').value = currentContent;
	document.getElementById('editFeedbackModal').classList.add('show');
}

function openFilterModal() {
	document.getElementById('filterModal').classList.add('show');
}

function openDateModal() {
	var d = prompt("Nhập ngày bắt đầu lọc (định dạng YYYY-MM-DD):", "2024-02-01");
	if (d) {
		document.getElementById('searchInput').value = d;
		filterFeedbackGroups();
	}
}

function applyFilterModal() {
	var st = document.getElementById('filterStatusSelect').value;
	filterByStatus(st);
	closeModal('filterModal');
}

function closeModal(modalId) {
	document.getElementById(modalId).classList.remove('show');
}

function filterFeedbackGroups() {
	var query = document.getElementById('searchInput').value.toLowerCase();
	var rows = document.querySelectorAll('.fb-row');
	rows.forEach(function(row) {
		var text = row.innerText.toLowerCase();
		if (text.indexOf(query) !== -1) {
			row.style.display = '';
		} else {
			row.style.display = 'none';
		}
	});
}

function filterByStatus(st) {
	var rows = document.querySelectorAll('.fb-row');
	rows.forEach(function(row) {
		if (st === 'ALL') {
			row.style.display = '';
		} else {
			row.style.display = '';
		}
	});
}

function resetFilters() {
	document.getElementById('searchInput').value = '';
	filterFeedbackGroups();
}
</script>

<style>
.fb-row.selected-row td {
	background: #eff6ff !important;
}
</style>

<%@ include file="../common/footer.jsp"%>
