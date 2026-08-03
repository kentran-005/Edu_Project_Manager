<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<form method="post" action="${pageContext.request.contextPath}/grades" id="gradingForm">
	<input type="hidden" name="redirectUrl" value="/grades">

	<!-- Page Header & Actions -->
	<div class="page-header-row">
		<div class="page-title-box">
			<h1>Chấm điểm đề tài</h1>
			<p style="color:#64748b;font-size:13px">Dashboard / Chấm điểm đề tài</p>
		</div>
		<div class="page-header-actions">
			<a class="btn-filter" href="${pageContext.request.contextPath}/groups">← Quay lại danh sách</a>
			<button type="submit" class="btn-add-primary">💾 Lưu điểm</button>
		</div>
	</div>

	<!-- Selector Bar: Choose Group and Student to Grade -->
	<div class="topic-table-card" style="padding:18px 20px;margin-bottom:24px;background:#f8fafc">
		<div class="row" style="align-items:center;gap:16px">
			<div>
				<label style="margin:0 0 6px;color:#334155;font-weight:800">Chọn nhóm đồ án cần chấm: <span style="color:red">*</span></label>
				<select name="groupId" id="groupIdSelect" required onchange="onGroupSelectChange(this.value)" style="margin:0;font-weight:700">
					<option value="">-- Chọn nhóm đồ án --</option>
					<c:forEach var="g" items="${groups}">
						<option value="${g.id}">${g.group_name} - ${not empty g.topic_title ? g.topic_title : 'Đồ án'}</option>
					</c:forEach>
				</select>
			</div>
			<div>
				<label style="margin:0 0 6px;color:#334155;font-weight:800">Chọn sinh viên chấm điểm: <span style="color:red">*</span></label>
				<select name="studentId" id="studentIdSelect" required style="margin:0;font-weight:700">
					<option value="">-- Chọn nhóm trước --</option>
				</select>
			</div>
		</div>
	</div>

	<!-- Main 2-Column Layout -->
	<div class="dashboard-grid wide-left" style="gap:24px;align-items:start">
		
		<!-- LEFT COLUMN (~60%): Topic Info & Detailed Rubric Table -->
		<div style="display:flex;flex-direction:column;gap:24px">
			
			<!-- Card 1: Thông tin đề tài -->
			<div class="topic-table-card" style="padding:20px">
				<div style="display:flex;align-items:center;gap:12px;margin-bottom:14px">
					<div style="width:42px;height:42px;border-radius:12px;background:#2563eb;color:white;display:grid;place-items:center;font-size:20px">📄</div>
					<div>
						<h3 style="margin:0;font-size:16px;font-weight:800;color:#0f172a">Thông tin đề tài</h3>
					</div>
				</div>
				<div class="row" style="gap:16px 24px;font-size:13.5px">
					<div>
						<p style="margin:0 0 8px"><span style="color:#64748b">Mã đề tài:</span> <span class="topic-code-tag" id="dispTopicCode">DT2024_001</span></p>
						<p style="margin:0 0 8px"><span style="color:#64748b">Tên đề tài:</span> <strong style="color:#0f172a" id="dispTopicTitle">Vui lòng chọn nhóm bên trên</strong></p>
						<p style="margin:0"><span style="color:#64748b">Nhóm:</span> <strong style="color:#0f172a" id="dispGroupName">--</strong></p>
					</div>
					<div>
						<p style="margin:0 0 8px"><span style="color:#64748b">Giảng viên hướng dẫn:</span> <strong style="color:#0f172a">${sessionScope.currentUser.fullName}</strong></p>
						<p style="margin:0"><span style="color:#64748b">Ngày bảo vệ:</span> <strong style="color:#0f172a">20/06/2024</strong></p>
					</div>
				</div>
			</div>

			<!-- Card 2: Bảng chấm điểm tiêu chí (Rubric) -->
			<div class="topic-table-card">
				<div class="card-title-head">
					<h3>Bảng chấm điểm</h3>
				</div>
				<div class="table-responsive">
					<table class="topic-data-table" style="font-size:13px">
						<thead>
							<tr>
								<th>Tiêu chí đánh giá</th>
								<th style="width:100px;text-align:center">Thang điểm</th>
								<th style="width:110px;text-align:center">Trọng số (%)</th>
								<th style="width:110px;text-align:center">Điểm (GV)</th>
								<th style="width:110px;text-align:center">Điểm quy đổi</th>
							</tr>
						</thead>
						<tbody>
							<!-- Section 1 -->
							<tr style="background:#f8fafc;font-weight:800;color:#0f172a">
								<td colspan="2">1. Nội dung đề tài</td>
								<td style="text-align:center">40%</td>
								<td></td>
								<td style="text-align:center;color:#2563eb" id="sec1Sum">3.40</td>
							</tr>
							<tr>
								<td style="padding-left:24px">1.1 Tính cấp thiết và ý nghĩa của đề tài</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">10%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="8.5" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">0.85</td>
							</tr>
							<tr>
								<td style="padding-left:24px">1.2 Mục tiêu và phạm vi nghiên cứu</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">10%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="8.0" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">0.80</td>
							</tr>
							<tr>
								<td style="padding-left:24px">1.3 Nội dung và giải pháp thực hiện</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">20%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="8.7" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">1.74</td>
							</tr>

							<!-- Section 2 -->
							<tr style="background:#f8fafc;font-weight:800;color:#0f172a">
								<td colspan="2">2. Sản phẩm</td>
								<td style="text-align:center">30%</td>
								<td></td>
								<td style="text-align:center;color:#2563eb" id="sec2Sum">2.55</td>
							</tr>
							<tr>
								<td style="padding-left:24px">2.1 Tính đúng đắn và đầy đủ của chức năng</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">15%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="8.5" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">1.28</td>
							</tr>
							<tr>
								<td style="padding-left:24px">2.2 Giao diện và trải nghiệm người dùng</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">10%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="8.2" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">0.82</td>
							</tr>
							<tr>
								<td style="padding-left:24px">2.3 Hiệu suất và tính ổn định</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">5%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="9.0" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">0.45</td>
							</tr>

							<!-- Section 3 -->
							<tr style="background:#f8fafc;font-weight:800;color:#0f172a">
								<td colspan="2">3. Báo cáo và thuyết trình</td>
								<td style="text-align:center">20%</td>
								<td></td>
								<td style="text-align:center;color:#2563eb" id="sec3Sum">1.75</td>
							</tr>
							<tr>
								<td style="padding-left:24px">3.1 Báo cáo đầy đủ, đúng mẫu</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">10%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="8.5" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">0.85</td>
							</tr>
							<tr>
								<td style="padding-left:24px">3.2 Thuyết trình rõ ràng, logic</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">10%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="9.0" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">0.90</td>
							</tr>

							<!-- Section 4 -->
							<tr style="background:#f8fafc;font-weight:800;color:#0f172a">
								<td colspan="2">4. Thái độ và quá trình thực hiện</td>
								<td style="text-align:center">10%</td>
								<td></td>
								<td style="text-align:center;color:#2563eb" id="sec4Sum">1.00</td>
							</tr>
							<tr>
								<td style="padding-left:24px">4.1 Thái độ làm việc và hợp tác nhóm</td>
								<td style="text-align:center;color:#64748b">0 - 10</td>
								<td style="text-align:center">10%</td>
								<td><input type="number" step="0.1" min="0" max="10" value="10.0" class="grading-input" onchange="recalculateGrade()"></td>
								<td style="text-align:center" class="conv-score">1.00</td>
							</tr>

							<!-- Summary Rows -->
							<tr style="background:#eff6ff;font-weight:900;font-size:14px;color:#1e3a8a">
								<td colspan="2">Tổng điểm quy đổi</td>
								<td style="text-align:center">100%</td>
								<td></td>
								<td style="text-align:center;color:#1d4ed8;font-size:16px" id="totalScore">8.70 / 10</td>
							</tr>
							<tr style="background:white;font-weight:800">
								<td colspan="3" style="vertical-align:middle">Điểm tổng kết lưu vào hệ thống</td>
								<td colspan="2" style="text-align:right">
									<div style="display:inline-flex;align-items:center;gap:6px">
										<input type="number" step="0.1" min="0" max="10" name="score" id="roundedScore" value="8.7" required style="width:80px!important;padding:8px!important;text-align:center!important;font-weight:900!important;font-size:16px!important;color:#1d4ed8!important;border:1px solid #93c5fd!important;margin:0!important">
										<span>/ 10</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

		</div>

		<!-- RIGHT COLUMN (~40%): Real Group Members, Review, Letter Grade, History Table -->
		<div style="display:flex;flex-direction:column;gap:24px">
			
			<!-- Card 3: Thành viên nhóm (Dynamic DB Members) -->
			<div class="topic-table-card">
				<div class="card-title-head">
					<h3>👥 Thành viên nhóm</h3>
				</div>
				<div class="table-responsive">
					<table class="topic-data-table">
						<thead>
							<tr>
								<th style="width:40px">#</th>
								<th style="width:110px">Mã SV</th>
								<th>Họ và tên</th>
								<th style="width:100px">Vai trò</th>
							</tr>
						</thead>
						<tbody id="groupMembersTbody">
							<tr>
								<td colspan="4" class="table-empty">Vui lòng chọn nhóm đồ án để xem thành viên.</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!-- Card 4: Nhận xét chung -->
			<div class="topic-table-card" style="padding:20px">
				<h3 style="margin:0 0 12px;font-size:16px;font-weight:800;color:#0f172a">Nhận xét chung</h3>
				<textarea name="comment" style="min-height:100px" placeholder="Nhận xét tổng quan kết quả đồ án...">Nhóm hoàn thành tốt đề tài. Sản phẩm đáp ứng yêu cầu cơ bản, báo cáo rõ ràng.</textarea>
			</div>

			<!-- Card 5: Trạng thái công bố -->
			<div class="topic-table-card" style="padding:20px">
				<h3 style="margin:0 0 12px;font-size:16px;font-weight:800;color:#0f172a">Trạng thái điểm</h3>
				<select name="status" style="font-weight:800;color:#1d4ed8;padding:10px!important">
					<option value="PUBLISHED" selected>PUBLISHED (Công bố công khai cho sinh viên)</option>
					<option value="DRAFT">DRAFT (Lưu nháp / Chưa công bố)</option>
				</select>
			</div>

			<!-- Card 6: Danh sách điểm đã chấm gần đây (Real DB Data) -->
			<div class="topic-table-card">
				<div class="card-title-head">
					<h3>🏆 Bảng điểm đã chấm (${fn:length(grades)})</h3>
				</div>
				<div class="table-responsive">
					<table class="topic-data-table">
						<thead>
							<tr>
								<th>Sinh viên / Nhóm</th>
								<th style="width:70px">Điểm</th>
								<th style="width:100px">Trạng thái</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${empty grades}">
									<tr>
										<td colspan="3" class="table-empty">Chưa có điểm nào được lưu trong hệ thống.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="gr" items="${grades}">
										<tr>
											<td>
												<strong style="color:#0f172a">${gr.student_name}</strong>
												<small style="display:block;color:#64748b">${gr.group_name} - ${gr.topic_title}</small>
											</td>
											<td><strong style="font-size:16px;color:#15803d">${gr.score}</strong></td>
											<td>
												<c:choose>
													<c:when test="${gr.status=='PUBLISHED'}">
														<span class="status-pill green">Công bố</span>
													</c:when>
													<c:otherwise>
														<span class="status-pill orange">Lưu nháp</span>
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

			<!-- Alert Box -->
			<div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:12px;padding:14px;display:flex;align-items:center;gap:10px;color:#1e40af;font-size:13px">
				<span>ℹ️</span>
				<span><strong>Lưu ý:</strong> Điểm số sau khi chọn Công bố sẽ được thông báo tự động tới tài khoản Sinh viên.</span>
			</div>

		</div>

	</div>
</form>

<style>
.grading-input {
	width: 76px !important;
	padding: 6px !important;
	text-align: center !important;
	font-weight: 800 !important;
	border: 1px solid #cbd5e1 !important;
	border-radius: 8px !important;
	margin: 0 auto !important;
	display: block !important;
}
</style>

<script>
var groupsData = [
	<c:forEach var="g" items="${groups}" varStatus="loop">
		{
			id: '${g.id}',
			name: '${fn:escapeXml(g.group_name)}',
			title: '${fn:escapeXml(g.topic_title)}'
		}${!loop.last ? ',' : ''}
	</c:forEach>
];

function onGroupSelectChange(groupId) {
	var studentSelect = document.getElementById('studentIdSelect');
	var membersTbody = document.getElementById('groupMembersTbody');
	
	studentSelect.innerHTML = '<option value="">-- Đang tải thành viên... --</option>';
	membersTbody.innerHTML = '<tr><td colspan="4" class="table-empty">Đang tải danh sách thành viên từ CSDL...</td></tr>';
	
	if (!groupId) {
		document.getElementById('dispTopicTitle').innerText = 'Vui lòng chọn nhóm bên trên';
		document.getElementById('dispGroupName').innerText = '--';
		studentSelect.innerHTML = '<option value="">-- Chọn nhóm trước --</option>';
		membersTbody.innerHTML = '<tr><td colspan="4" class="table-empty">Vui lòng chọn nhóm đồ án để xem thành viên.</td></tr>';
		return;
	}
	
	var found = groupsData.find(function(g) { return g.id === groupId; });
	if (found) {
		document.getElementById('dispTopicCode').innerText = 'DT2024_00' + found.id;
		document.getElementById('dispTopicTitle').innerText = found.title || 'Đồ án chuyên ngành';
		document.getElementById('dispGroupName').innerText = found.name;
	}
	
	// Fetch REAL group members from DB via AJAX
	fetch('${pageContext.request.contextPath}/grades?action=getMembers&groupId=' + groupId)
		.then(function(res) { return res.json(); })
		.then(function(members) {
			studentSelect.innerHTML = '';
			membersTbody.innerHTML = '';
			
			if (!members || members.length === 0) {
				studentSelect.innerHTML = '<option value="">-- Không có sinh viên nào --</option>';
				membersTbody.innerHTML = '<tr><td colspan="4" class="table-empty">Nhóm này chưa có thành viên.</td></tr>';
				return;
			}
			
			members.forEach(function(m, idx) {
				var roleName = (m.role === 'LEADER' ? 'Trưởng nhóm' : 'Thành viên');
				var roleBadge = (m.role === 'LEADER' ? '<span class="status-pill orange">Trưởng nhóm</span>' : '<span class="status-pill blue">Thành viên</span>');
				
				// Populate Student Dropdown
				var opt = document.createElement('option');
				opt.value = m.student_id;
				opt.innerText = m.full_name + ' (' + m.student_code + ' - ' + roleName + ')';
				studentSelect.appendChild(opt);
				
				// Populate Group Members Table
				var tr = document.createElement('tr');
				tr.innerHTML = '<td>' + (idx + 1) + '</td>' +
							   '<td><span class="topic-code-tag">' + m.student_code + '</span></td>' +
							   '<td><strong style="color:#0f172a">' + m.full_name + '</strong></td>' +
							   '<td>' + roleBadge + '</td>';
				membersTbody.appendChild(tr);
			});
		})
		.catch(function(err) {
			console.error("Error fetching group members:", err);
			studentSelect.innerHTML = '<option value="">-- Lỗi tải danh sách --</option>';
			membersTbody.innerHTML = '<tr><td colspan="4" class="table-empty">Không thể kết nối CSDL lấy danh sách thành viên.</td></tr>';
		});
}

function recalculateGrade() {
	var inputs = document.querySelectorAll('.grading-input');
	var weights = [0.10, 0.10, 0.20, 0.15, 0.10, 0.05, 0.10, 0.10, 0.10];
	var total = 0;
	
	inputs.forEach(function(inp, idx) {
		var val = parseFloat(inp.value) || 0;
		var w = weights[idx] || 0.10;
		var conv = val * w;
		total += conv;
		var convCell = inp.closest('tr').querySelector('.conv-score');
		if (convCell) convCell.innerText = conv.toFixed(2);
	});
	
	document.getElementById('totalScore').innerText = total.toFixed(2) + ' / 10';
	document.getElementById('roundedScore').value = total.toFixed(1);
}

// Auto-select first group if available on page load
window.addEventListener('DOMContentLoaded', function() {
	var grpSelect = document.getElementById('groupIdSelect');
	if (grpSelect.options.length > 1) {
		grpSelect.selectedIndex = 1;
		onGroupSelectChange(grpSelect.value);
	}
});
</script>

<%@ include file="../common/footer.jsp"%>
