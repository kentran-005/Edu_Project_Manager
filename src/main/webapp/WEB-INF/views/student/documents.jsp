<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Action Controls -->
<div class="page-header-row" style="margin-bottom: 20px;">
	<div class="page-title-box">
		<h1>Tài liệu tham khảo & Biểu mẫu</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Tài liệu tham khảo</p>
	</div>
	<div class="page-header-actions">
		<c:if test="${sessionScope.currentUser.role == 'LECTURER' || sessionScope.currentUser.role == 'ADMIN'}">
			<button type="button" class="btn-add-primary" onclick="document.getElementById('uploadDocModal').style.display='flex'">+ Tải lên tài liệu tham khảo</button>
		</c:if>
		<div class="search-box">
			<span class="search-icon">🔍</span>
			<input type="text" id="docSearchInput" placeholder="Tìm tài liệu, biểu mẫu..." onkeyup="filterDocs()">
		</div>
	</div>
</div>

<!-- Dynamic Category Stats Calculation -->
<c:set var="countForm" value="0"/>
<c:set var="countRules" value="0"/>
<c:set var="countSample" value="0"/>
<c:forEach var="d" items="${documents}">
	<c:choose>
		<c:when test="${d.type == 'Biểu mẫu'}"><c:set var="countForm" value="${countForm + 1}"/></c:when>
		<c:when test="${d.type == 'Quy định'}"><c:set var="countRules" value="${countRules + 1}"/></c:when>
		<c:otherwise><c:set var="countSample" value="${countSample + 1}"/></c:otherwise>
	</c:choose>
</c:forEach>

<!-- Category Cards Grid (Dynamic Counters) -->
<div class="row" style="grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px;">
	<div class="admin-panel" style="border-radius:16px; display:flex; gap:14px; align-items:center;">
		<div style="width:46px; height:46px; border-radius:12px; background:#dbeafe; color:#1d4ed8; display:grid; place-items:center; font-size:22px; font-weight:900;">📋</div>
		<div>
			<strong style="font-size:15px; color:#0f172a; display:block;">Biểu mẫu đồ án (${countForm})</strong>
			<small style="color:#64748b;">Mẫu Báo cáo, Đề cương, Slide</small>
		</div>
	</div>
	<div class="admin-panel" style="border-radius:16px; display:flex; gap:14px; align-items:center;">
		<div style="width:46px; height:46px; border-radius:12px; background:#dcfce7; color:#15803d; display:grid; place-items:center; font-size:22px; font-weight:900;">📘</div>
		<div>
			<strong style="font-size:15px; color:#0f172a; display:block;">Quy định & Hướng dẫn (${countRules})</strong>
			<small style="color:#64748b;">Quy định trình bày & Đánh giá</small>
		</div>
	</div>
	<div class="admin-panel" style="border-radius:16px; display:flex; gap:14px; align-items:center;">
		<div style="width:46px; height:46px; border-radius:12px; background:#fef3c7; color:#b45309; display:grid; place-items:center; font-size:22px; font-weight:900;">💻</div>
		<div>
			<strong style="font-size:15px; color:#0f172a; display:block;">Đề tài mẫu & Mã nguồn (${countSample})</strong>
			<small style="color:#64748b;">Tham khảo đồ án các khóa trước</small>
		</div>
	</div>
</div>

<!-- Document List Table Card -->
<div class="topic-table-card">
	<div class="card-title-head">
		<h3>Tài liệu hệ thống công bố</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table" id="docTable">
			<thead>
				<tr>
					<th style="width: 50px;">#</th>
					<th>Tên tài liệu / Biểu mẫu</th>
					<th style="width: 140px;">Loại tài liệu</th>
					<th style="width: 100px;">Dung lượng</th>
					<th style="width: 120px;">Cập nhật</th>
					<th style="width: 130px; text-align:center;">Tải về</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty documents}">
						<tr>
							<td colspan="6" class="table-empty" style="padding: 40px 20px!important;">
								<div style="font-size: 38px; margin-bottom: 8px;">▤</div>
								<strong style="font-size: 15px; color: #0f172a; display: block; margin-bottom: 4px;">Chưa có tài liệu tham khảo nào trong hệ thống.</strong>
								<span style="font-size: 13px; color: #64748b;">Tài liệu và tệp đính kèm sẽ được tự động tổng hợp khi có các nhóm upload bài nộp.</span>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="doc" items="${documents}" varStatus="loop">
							<tr class="doc-row">
								<td>${loop.index + 1}</td>
								<td>
									<strong style="color:#0f172a;">${doc.file_name}</strong>
									<small style="display:block; color:#64748b;">Đề tài: ${doc.topic_title} (${doc.group_name})</small>
								</td>
								<td><span class="tag blue">${not empty doc.type ? doc.type : 'Biểu mẫu'}</span></td>
								<td>--</td>
								<td><span style="font-size:12px; color:#64748b;">${doc.created_at}</span></td>
								<td style="text-align:center;">
									<c:choose>
										<c:when test="${fn:startsWith(doc.file_url, 'http://') || fn:startsWith(doc.file_url, 'https://')}">
											<a class="btn-add-primary" style="padding:4px 10px!important; font-size:12px!important; text-decoration:none;" href="${doc.file_url}" target="_blank">📥 Tải về</a>
										</c:when>
										<c:otherwise>
											<a class="btn-add-primary" style="padding:4px 10px!important; font-size:12px!important; text-decoration:none;" href="${doc.file_url}" download>📥 Tải về tệp</a>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>

<!-- Upload Document Modal for Lecturer -->
<div id="uploadDocModal" class="modal-overlay" style="display:none; position:fixed; inset:0; background:rgba(15,23,42,0.6); backdrop-filter:blur(4px); z-index:9999; justify-content:center; align-items:center;">
	<div class="admin-panel" style="width:100%; max-width:540px; border-radius:16px; background:white; padding:24px; box-shadow:0 20px 25px -5px rgba(0,0,0,0.1);">
		<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; border-bottom:1px solid #e2e8f0; padding-bottom:12px;">
			<h3 style="margin:0; font-size:18px; color:#0f172a;">Tải lên tài liệu tham khảo</h3>
			<button type="button" onclick="document.getElementById('uploadDocModal').style.display='none'" style="background:none; border:none; font-size:20px; cursor:pointer; color:#64748b;">✕</button>
		</div>

		<form method="post" action="${pageContext.request.contextPath}/documents" enctype="multipart/form-data">
			<label>Tên tài liệu / Biểu mẫu <span style="color:red">*</span></label>
			<input type="text" name="fileName" required placeholder="Ví dụ: Mẫu báo cáo đề cương đồ án môn học..." style="margin-bottom:12px;">

			<label>Đề tài hướng dẫn áp dụng <span style="color:red">*</span></label>
			<select name="topicId" style="margin-bottom:12px;">
				<option value="">-- Tất cả đề tài hướng dẫn --</option>
				<c:forEach var="t" items="${topics}">
					<option value="${t.id}">${t.title} (${t.semester_name})</option>
				</c:forEach>
			</select>

			<label>Phân loại tài liệu <span style="color:red">*</span></label>
			<select name="type" required style="margin-bottom:12px;">
				<option value="Biểu mẫu">Biểu mẫu (Template Word/PPT)</option>
				<option value="Quy định">Quy định & Hướng dẫn (PDF)</option>
				<option value="Tham khảo">Đề tài mẫu & Mã nguồn (ZIP)</option>
			</select>

			<label>Chọn tệp từ máy tính (PDF, DOCX, ZIP, PPTX...)</label>
			<input type="file" name="fileUpload" style="margin-bottom:12px; background:#f8fafc; padding:8px;">

			<div style="text-align:center; font-size:12px; color:#64748b; margin-bottom:10px;">-- HOẶC dán đường dẫn tệp (Nếu có) --</div>

			<label>Đường dẫn tệp tin / Link URL</label>
			<input type="text" name="fileUrl" placeholder="https://drive.google.com/... hoặc đường dẫn tệp" style="margin-bottom:16px;">

			<div style="text-align:right; display:flex; gap:10px; justify-content:flex-end;">
				<button type="button" class="btn-filter" onclick="document.getElementById('uploadDocModal').style.display='none'">Hủy</button>
				<button type="submit" class="btn-add-primary">Lưu & Đăng tài liệu</button>
			</div>
		</form>
	</div>
</div>

<script>
	function filterDocs() {
		var q = document.getElementById('docSearchInput').value.toLowerCase();
		var rows = document.querySelectorAll('.doc-row');
		rows.forEach(function(r) {
			var text = r.innerText.toLowerCase();
			r.style.display = text.indexOf(q) !== -1 ? '' : 'none';
		});
	}
</script>

<%@ include file="../common/footer.jsp" %>
