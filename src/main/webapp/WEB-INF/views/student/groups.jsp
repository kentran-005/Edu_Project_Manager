<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Breadcrumb -->
<div class="page-header-row" style="margin-bottom: 16px;">
	<div class="page-title-box">
		<h1>Xem nhóm / tiến độ</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Xem nhóm / tiến độ</p>
	</div>
</div>

<!-- Tabs Navigation -->
<div style="display: flex; gap: 24px; border-bottom: 2px solid #e2e8f0; margin-bottom: 24px;">
	<div id="tab-btn-create" onclick="switchGroupTab('create')" style="padding: 10px 4px; font-weight: 800; font-size: 14px; color: #1d4ed8; border-bottom: 2px solid #1d4ed8; margin-bottom: -2px; cursor: pointer; display: flex; align-items: center; gap: 8px;">
		<span>👤</span> Tạo nhóm
	</div>
	<div id="tab-btn-join" onclick="switchGroupTab('join')" style="padding: 10px 4px; font-weight: 700; font-size: 14px; color: #64748b; margin-bottom: -2px; cursor: pointer; display: flex; align-items: center; gap: 8px;">
		<span>👥</span> Tham gia nhóm
	</div>
	<div id="tab-btn-register" onclick="switchGroupTab('register')" style="padding: 10px 4px; font-weight: 700; font-size: 14px; color: #64748b; margin-bottom: -2px; cursor: pointer; display: flex; align-items: center; gap: 8px;">
		<span>📄</span> Đăng ký đề tài
	</div>
</div>

<!-- Dynamic Action Section (Content changes per selected tab) -->
<div style="margin-bottom: 28px;">

	<!-- Tab Content 1: Tạo nhóm mới -->
	<div id="tab-content-create" class="admin-panel" style="border-radius: 16px; max-width: 680px; padding: 24px;">
		<div style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
			<span style="width: 32px; height: 32px; border-radius: 8px; background: #1d4ed8; color: white; display: grid; place-items: center; font-weight: 900; font-size: 15px;">1</span>
			<div>
				<h3 style="margin: 0; font-size: 18px; font-weight: 800; color: #0f172a;">Tạo nhóm mới</h3>
				<small style="color: #64748b;">Khởi tạo nhóm đồ án để cùng các thành viên thực hiện đồ án môn học</small>
			</div>
		</div>

		<form method="post" action="${pageContext.request.contextPath}/groups">
			<input type="hidden" name="action" value="create">
			
			<label>Tên nhóm <span style="color:red">*</span></label>
			<input type="text" name="groupName" required placeholder="Nhập tên nhóm đồ án (Ví dụ: Nhóm SE2024_01)...">

			<label>Học kỳ <span style="color:red">*</span></label>
			<select name="semesterId" required>
				<option value="">-- Chọn học kỳ --</option>
				<c:forEach var="s" items="${semesters}">
					<option value="${s.id}">${s.name}</option>
				</c:forEach>
			</select>

			<label>Số lượng thành viên tối đa <span style="color:red">*</span></label>
			<select name="maxMembers">
				<option value="4" selected>4 thành viên</option>
				<option value="3">3 thành viên</option>
				<option value="5">5 thành viên</option>
			</select>

			<div style="background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 10px; padding: 14px; margin-top: 16px; margin-bottom: 20px; font-size: 13px; color: #1e40af;">
				<strong style="display:block; margin-bottom:4px;">ℹ Lưu ý khi tạo nhóm</strong>
				<ul style="margin: 0; padding-left: 18px;">
					<li>Số lượng thành viên tối đa từ 2 đến 6 người.</li>
					<li>Tài khoản tạo nhóm sẽ tự động trở thành <b>Trưởng nhóm</b> và có quyền mời các thành viên khác.</li>
				</ul>
			</div>

			<div style="text-align: right;">
				<c:choose>
					<c:when test="${empty semesters}">
						<button type="button" class="btn-add-primary" disabled title="Cần có học kỳ trước khi tạo nhóm">+ Tạo nhóm mới</button>
					</c:when>
					<c:otherwise>
						<button type="submit" class="btn-add-primary">+ Tạo nhóm mới</button>
					</c:otherwise>
				</c:choose>
			</div>
		</form>
	</div>

	<!-- Tab Content 2: Tham gia nhóm -->
	<div id="tab-content-join" class="admin-panel" style="display: none; border-radius: 16px; max-width: 680px; padding: 24px;">
		<div style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
			<span style="width: 32px; height: 32px; border-radius: 8px; background: #1d4ed8; color: white; display: grid; place-items: center; font-weight: 900; font-size: 15px;">2</span>
			<div>
				<h3 style="margin: 0; font-size: 18px; font-weight: 800; color: #0f172a;">Tham gia nhóm</h3>
				<small style="color: #64748b;">Nhập mã mời được cung cấp bởi Trưởng nhóm để gia nhập</small>
			</div>
		</div>

		<form method="post" action="${pageContext.request.contextPath}/groups">
			<input type="hidden" name="action" value="join">
			
			<label>Nhập Mã mời nhóm <span style="color:red">*</span></label>
			<div style="display: flex; gap: 10px; margin-bottom: 16px;">
				<input type="text" name="inviteCode" required placeholder="Ví dụ: G7K9L2..." style="margin:0; text-transform:uppercase; font-family:monospace; font-size:15px; letter-spacing:1px;">
			</div>

			<div style="background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px; padding: 14px; margin-bottom: 20px; font-size: 13px; color: #166534;">
				<strong style="display:block; margin-bottom:4px;">ℹ Hướng dẫn tham gia</strong>
				<ul style="margin: 0; padding-left: 18px;">
					<li>Liên hệ Trưởng nhóm của bạn để nhận Mã mời (Invite Code).</li>
					<li>Nhập đúng Mã mời và bấm "Tham gia nhóm" để hoàn tất.</li>
				</ul>
			</div>

			<div style="text-align: right;">
				<button type="submit" class="btn-add-primary">👥 Tham gia nhóm ngay</button>
			</div>
		</form>
	</div>

	<!-- Tab Content 3: Đăng ký đề tài -->
	<div id="tab-content-register" class="admin-panel" style="display: none; border-radius: 16px; max-width: 680px; padding: 24px;">
		<div style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
			<span style="width: 32px; height: 32px; border-radius: 8px; background: #1d4ed8; color: white; display: grid; place-items: center; font-weight: 900; font-size: 15px;">3</span>
			<div>
				<h3 style="margin: 0; font-size: 18px; font-weight: 800; color: #0f172a;">Đăng ký đề tài đồ án</h3>
				<small style="color: #64748b;">Lựa chọn đề tài phù hợp và gửi yêu cầu đăng ký lên Giảng viên</small>
			</div>
		</div>

		<form method="post" action="${pageContext.request.contextPath}/groups">
			<input type="hidden" name="action" value="register">

			<label>Chọn nhóm của bạn <span style="color:red">*</span></label>
			<select name="groupId" required style="margin-bottom: 14px;">
				<option value="">-- Chọn nhóm đăng ký --</option>
				<c:forEach var="g" items="${groups}">
					<c:if test="${g.status=='FORMING'}">
						<option value="${g.id}">${g.group_name}</option>
					</c:if>
				</c:forEach>
			</select>

			<label>Chọn đề tài mong muốn <span style="color:red">*</span></label>
			<select name="topicId" id="topicSelect" required onchange="updateTopicInfoDisplay(this)" style="margin-bottom: 14px;">
				<option value="">-- Chọn đề tài --</option>
				<c:forEach var="t" items="${topics}">
					<option value="${t.id}" data-desc="${fn:escapeXml(t.description)}" data-tech="${fn:escapeXml(t.technology)}">${t.title}</option>
				</c:forEach>
			</select>

			<label>Ghi chú gửi giảng viên</label>
			<textarea name="note" placeholder="Nhập ghi chú hoặc nguyện vọng bổ sung của nhóm..." style="min-height:70px; margin-bottom: 14px;"></textarea>

			<div style="background: #fffbeb; border: 1px solid #fef3c7; border-radius: 10px; padding: 14px; margin-bottom: 20px; font-size: 13px; color: #92400e;" id="topicInfoBox">
				<strong style="display:block; margin-bottom:4px;">ℹ Thông tin đề tài đã chọn</strong>
				<span id="topicInfoText">Vui lòng chọn một đề tài trong danh sách trên để xem chi tiết.</span>
			</div>

			<div style="text-align: right;">
				<button type="submit" class="btn-add-primary">📄 Đăng ký đề tài này</button>
			</div>
		</form>
	</div>

</div>

<!-- Bottom Section: "Các nhóm của bạn" Table Card -->
<div class="topic-table-card">
	<div class="card-title-head">
		<h3>Các nhóm của bạn</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table">
			<thead>
				<tr>
					<th style="width: 120px;">Mã nhóm</th>
					<th>Tên nhóm</th>
					<th style="width: 130px; text-align:center;">Số thành viên</th>
					<th style="width: 160px;">Trưởng nhóm</th>
					<th>Đề tài</th>
					<th style="width: 140px;">Trạng thái</th>
					<th style="width: 130px; text-align:center;">Hành động</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty groups}">
						<tr>
							<td colspan="7" class="table-empty" style="padding: 40px 20px!important;">
								<div style="font-size: 42px; margin-bottom: 8px;">📁</div>
								<strong style="font-size: 15px; color: #0f172a; display: block; margin-bottom: 4px;">Bạn chưa tham gia nhóm nào.</strong>
								<span style="font-size: 13px; color: #64748b;">Hãy chọn "Tạo nhóm" hoặc "Tham gia nhóm" ở trên để bắt đầu đồ án.</span>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="g" items="${groups}" varStatus="loop">
							<tr>
								<td><span class="topic-code-tag">GR2024_0${g.id}</span></td>
								<td>
									<strong style="color: #0f172a;">${g.group_name}</strong>
									<small style="display:block; color:#64748b;">Mã mời: <code style="background:#f1f5f9; padding:2px 6px; border-radius:4px; font-weight:800;">${g.invite_code}</code></small>
								</td>
								<td style="text-align: center; font-weight: 700;">
									${not empty g.member_count ? g.member_count : 1} / ${not empty g.max_members ? g.max_members : 5}
								</td>
								<td>${not empty g.leader_name ? g.leader_name : sessionScope.currentUser.fullName}</td>
								<td>
									<c:choose>
										<c:when test="${not empty g.topic_title}">
											<span style="font-weight: 700; color: #0f172a;">${g.topic_title}</span>
										</c:when>
										<c:otherwise>
											<span style="color: #94a3b8; font-style: italic;">Chưa đăng ký đề tài</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${g.status=='IN_PROGRESS'}">
											<span class="status-pill green">Đang thực hiện</span>
										</c:when>
										<c:when test="${g.status=='FORMING'}">
											<span class="status-pill orange">Đang tạo nhóm</span>
										</c:when>
										<c:when test="${g.status=='COMPLETED'}">
											<span class="status-pill purple">Hoàn thành</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill blue">${g.status}</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td style="text-align: center;">
									<a href="${pageContext.request.contextPath}/groups/${g.id}" class="btn-add-primary" style="padding: 6px 12px!important; font-size: 12.5px!important; border-radius: 8px!important;">
										Xem tiến độ →
									</a>
								</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>

<script>
	function switchGroupTab(tabName) {
		// Reset Tab buttons style
		document.getElementById('tab-btn-create').style.color = '#64748b';
		document.getElementById('tab-btn-create').style.borderBottom = 'none';
		document.getElementById('tab-btn-create').style.fontWeight = '700';

		document.getElementById('tab-btn-join').style.color = '#64748b';
		document.getElementById('tab-btn-join').style.borderBottom = 'none';
		document.getElementById('tab-btn-join').style.fontWeight = '700';

		document.getElementById('tab-btn-register').style.color = '#64748b';
		document.getElementById('tab-btn-register').style.borderBottom = 'none';
		document.getElementById('tab-btn-register').style.fontWeight = '700';

		// Hide all Tab Contents
		document.getElementById('tab-content-create').style.display = 'none';
		document.getElementById('tab-content-join').style.display = 'none';
		document.getElementById('tab-content-register').style.display = 'none';

		// Activate selected Tab
		var activeBtn = document.getElementById('tab-btn-' + tabName);
		var activeContent = document.getElementById('tab-content-' + tabName);

		if (activeBtn && activeContent) {
			activeBtn.style.color = '#1d4ed8';
			activeBtn.style.borderBottom = '2px solid #1d4ed8';
			activeBtn.style.fontWeight = '800';
			activeContent.style.display = 'block';
		}
	}

	function updateTopicInfoDisplay(selectEl) {
		var selectedOption = selectEl.options[selectEl.selectedIndex];
		var desc = selectedOption.getAttribute('data-desc');
		var tech = selectedOption.getAttribute('data-tech');
		var infoBox = document.getElementById('topicInfoText');

		if (desc || tech) {
			infoBox.innerHTML = '<b>Công nghệ:</b> ' + (tech || 'Chưa xác định') + '<br><b>Mô tả:</b> ' + (desc || 'Không có mô tả');
		} else {
			infoBox.innerText = 'Vui lòng chọn một đề tài trong danh sách trên để xem chi tiết.';
		}
	}
</script>

<%@ include file="../common/footer.jsp" %>

