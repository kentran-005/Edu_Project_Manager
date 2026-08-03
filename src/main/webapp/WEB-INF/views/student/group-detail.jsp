<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Action Controls -->
<div class="page-header-row" style="margin-bottom: 18px;">
	<div class="page-title-box">
		<h1>Chi tiết nhóm</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Xem nhóm / tiến độ &gt; Chi tiết nhóm</p>
	</div>
	<div class="page-header-actions">
		<a class="btn-filter" href="${pageContext.request.contextPath}/groups" style="text-decoration:none;">← Quay lại danh sách</a>
	</div>
</div>

<!-- Top Section Grid: Left (Group Info) & Right (Topic Info) -->
<div class="row" style="grid-template-columns: 1.65fr 1fr; gap: 20px; margin-bottom: 24px; align-items: stretch;">

	<!-- Card Left: Thông tin nhóm -->
	<div class="admin-panel" style="border-radius: 16px; display: flex; flex-direction: column; justify-content: space-between; padding: 22px;">
		<div>
			<small style="color: #64748b; font-weight: 700; font-size: 13px; display: block; margin-bottom: 12px;">Thông tin nhóm</small>
			
			<div style="display: flex; align-items: flex-start; justify-content: space-between; gap: 16px;">
				<div style="display: flex; gap: 14px; align-items: center;">
					<div style="width: 52px; height: 52px; border-radius: 50%; background: #2563eb; color: white; display: grid; place-items: center; font-size: 24px; font-weight: 900; box-shadow: 0 8px 18px rgba(37,99,235,0.25);">
						👥
					</div>
					<div>
						<div style="display: flex; align-items: center; gap: 10px;">
							<h2 style="margin: 0; font-size: 22px; font-weight: 900; color: #1d4ed8;">${group.group_name}</h2>
							<span class="status-pill green">Đang hoạt động</span>
						</div>
						<p style="margin: 4px 0 0; font-size: 13px; color: #475569;">
							<b>Đề tài:</b> ${not empty group.topic_title ? group.topic_title : 'Chưa đăng ký'}<br>
							<b>Giảng viên:</b> ${not empty group.lecturer_name ? group.lecturer_name : 'Chưa phân công'} &nbsp;|&nbsp; <b>Học kỳ:</b> ${not empty group.semester_name ? group.semester_name : 'HK2 2023 - 2024'}
						</p>
					</div>
				</div>

				<!-- Invite Code Box -->
				<div style="text-align: center; background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 12px; padding: 10px 16px;">
					<small style="color: #64748b; font-size: 11px; display: block; font-weight: 700;">Mã mời nhóm</small>
					<strong id="inviteCodeText" style="font-size: 18px; color: #1d4ed8; letter-spacing: 1px; font-family: monospace; display: block; margin: 2px 0 6px;">${group.invite_code}</strong>
					<button type="button" class="btn-filter" style="padding: 4px 10px; font-size: 11.5px; border-radius: 6px; width: 100%; justify-content: center;" onclick="navigator.clipboard.writeText('${group.invite_code}'); alert('Đã sao chép mã mời: ${group.invite_code}');">
						📋 Chia sẻ mã mời
					</button>
				</div>
			</div>
		</div>

		<!-- 4 Stats Pill Row inside Group Info -->
		<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-top: 20px; background: #f8fafc; padding: 14px; border-radius: 12px;">
			<div style="display: flex; gap: 10px; align-items: center;">
				<span style="width: 32px; height: 32px; border-radius: 50%; background: #dbeafe; color: #1d4ed8; display: grid; place-items: center; font-size: 14px;">👥</span>
				<div>
					<small style="color: #64748b; font-size: 11px; display: block;">Số thành viên</small>
					<strong style="color: #0f172a; font-size: 14px;">${fn:length(members)} / ${not empty group.max_members ? group.max_members : 5}</strong>
				</div>
			</div>
			<div style="display: flex; gap: 10px; align-items: center;">
				<span style="width: 32px; height: 32px; border-radius: 50%; background: #dbeafe; color: #1d4ed8; display: grid; place-items: center; font-size: 14px;">📅</span>
				<div>
					<small style="color: #64748b; font-size: 11px; display: block;">Ngày tạo nhóm</small>
					<strong style="color: #0f172a; font-size: 13.5px;">${not empty group.created_at ? fn:substring(group.created_at,0,10) : '10/05/2024'}</strong>
				</div>
			</div>
			<div style="display: flex; gap: 10px; align-items: center;">
				<span style="width: 32px; height: 32px; border-radius: 50%; background: #dbeafe; color: #1d4ed8; display: grid; place-items: center; font-size: 14px;">👤</span>
				<div>
					<small style="color: #64748b; font-size: 11px; display: block;">Trưởng nhóm</small>
					<strong style="color: #0f172a; font-size: 13.5px;">${not empty group.leader_name ? group.leader_name : sessionScope.currentUser.fullName}</strong>
				</div>
			</div>
			<div style="display: flex; gap: 10px; align-items: center;">
				<span style="width: 32px; height: 32px; border-radius: 50%; background: #dcfce7; color: #15803d; display: grid; place-items: center; font-size: 14px;">✓</span>
				<div>
					<small style="color: #64748b; font-size: 11px; display: block;">Trạng thái</small>
					<strong style="color: #15803d; font-size: 13px;">Đang hoạt động</strong>
				</div>
			</div>
		</div>
	</div>

	<!-- Card Right: Đề tài của nhóm -->
	<div class="admin-panel" style="border-radius: 16px; display: flex; flex-direction: column; justify-content: space-between; padding: 22px;">
		<div>
			<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
				<small style="color: #64748b; font-weight: 700; font-size: 13px;">Đề tài của nhóm</small>
				<span class="status-pill green">Đã đăng ký</span>
			</div>
			
			<h3 style="margin: 0 0 10px; font-size: 18px; font-weight: 800; color: #1d4ed8;">
				${not empty group.topic_title ? group.topic_title : 'Chưa đăng ký đề tài'}
			</h3>

			<div style="font-size: 13px; color: #475569; line-height: 1.6;">
				<p style="margin: 0;"><b>Giảng viên hướng dẫn:</b> ${not empty group.lecturer_name ? group.lecturer_name : 'TS. Nguyễn Văn A'}</p>
				<p style="margin: 2px 0;"><b>Học kỳ:</b> ${not empty group.semester_name ? group.semester_name : 'HK2 2023 - 2024'}</p>
				<p style="margin: 2px 0;"><b>Công nghệ:</b> Java Spring Boot, MySQL, ReactJS</p>
			</div>
		</div>

		<div style="margin-top: 18px;">
			<a class="btn-filter" style="width: 100%; justify-content: center; text-decoration: none; font-size: 13px;" href="${pageContext.request.contextPath}/topics">
				Xem chi tiết đề tài →
			</a>
		</div>
	</div>

</div>

<!-- Middle Section Grid: Left (Members Table & Actions) & Right (Topic Approval Card) -->
<div class="row" style="grid-template-columns: 1.65fr 1fr; gap: 20px; margin-bottom: 24px; align-items: start;">

	<!-- Left: Thành viên nhóm Table Box -->
	<div class="topic-table-card" style="margin:0;">
		<div class="card-title-head" style="justify-content: space-between;">
			<h3>Thành viên nhóm</h3>
			<span style="font-size: 13px; color: #64748b;">${fn:length(members)} / ${not empty group.max_members ? group.max_members : 5} thành viên</span>
		</div>
		<div class="table-responsive">
			<table class="topic-data-table">
				<thead>
					<tr>
						<th style="width: 40px;">#</th>
						<th>Thành viên</th>
						<th style="width: 130px;">Vai trò</th>
						<th style="width: 120px;">Ngày tham gia</th>
						<th style="width: 110px;">Trạng thái</th>
						<th style="width: 40px; text-align:center;">⋮</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="m" items="${members}" varStatus="loop">
						<tr>
							<td>${loop.index + 1}</td>
							<td>
								<div style="display: flex; align-items: center; gap: 10px;">
									<span style="width: 30px; height: 30px; border-radius: 50%; background: #dbeafe; color: #1d4ed8; display: grid; place-items: center; font-size: 12px; font-weight: 800;">SV</span>
									<div>
										<strong style="color: #0f172a; font-size: 13.5px;">${m.full_name} ${m.user_id == sessionScope.currentUser.id ? '(Bạn)' : ''}</strong>
										<small style="display:block; color:#64748b; font-size: 11px;">${m.student_code}</small>
									</div>
								</div>
							</td>
							<td>
								<c:choose>
									<c:when test="${m.role=='LEADER'}">
										<span class="status-pill blue" style="font-size:11px!important; padding:3px 8px!important;">Trưởng nhóm</span>
									</c:when>
									<c:otherwise>
										<span class="status-pill purple" style="font-size:11px!important; padding:3px 8px!important; background:#f1f5f9!important; color:#475569!important;">Thành viên</span>
									</c:otherwise>
								</c:choose>
							</td>
							<td><span style="font-size:12.5px; color:#64748b;">10/05/2024</span></td>
							<td><span class="status-pill green" style="font-size:11px!important; padding:3px 8px!important;">Hoạt động</span></td>
							<td style="text-align:center; color:#94a3b8; cursor:pointer;">⋮</td>
						</tr>
					</c:forEach>
					<c:if test="${fn:length(members) < (not empty group.max_members ? group.max_members : 5)}">
						<tr style="background: #fafafa;">
							<td>${fn:length(members) + 1}</td>
							<td><span style="color: #94a3b8; font-style: italic;">Chưa có thành viên</span></td>
							<td>--</td>
							<td>--</td>
							<td><span class="status-pill orange" style="font-size:11px!important; background:#fee2e2!important; color:#dc2626!important;">Chưa tham gia</span></td>
							<td>--</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
		<div style="padding: 14px 20px; background: white; border-top: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center;">
			<button type="button" class="btn-secondary-custom" style="color: #dc2626!important; border-color: #fecaca!important;" onclick="alert('Bạn có chắc chắn muốn rời nhóm này?');">Rời nhóm</button>
			<button type="button" class="btn-add-primary" onclick="navigator.clipboard.writeText('${group.invite_code}'); alert('Đã sao chép mã mời: ${group.invite_code}');">+ Mời thêm thành viên</button>
		</div>
	</div>

	<!-- Right: Đăng ký đề tài & Phê duyệt status -->
	<div class="admin-panel" style="border-radius: 16px; padding: 22px;">
		<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px;">
			<small style="color: #64748b; font-weight: 700; font-size: 13px;">Đăng ký đề tài</small>
			<a href="${pageContext.request.contextPath}/groups" style="font-size: 12px; font-weight: 800; color: #1d4ed8; text-decoration: none;">Đổi đề tài</a>
		</div>

		<div style="background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 12px; padding: 14px; margin-bottom: 16px;">
			<strong style="color: #1e40af; font-size: 13px; display: block; margin-bottom: 4px;">ℹ Nhóm đã đăng ký đề tài thành công.</strong>
			<small style="color: #3b82f6;">Ngày đăng ký: 10/05/2024 14:30</small>
		</div>

		<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px;">
			<small style="color: #64748b; font-size: 12px;">Trạng thái duyệt</small>
			<span class="status-pill green">Đã phê duyệt</span>
		</div>
		<small style="color: #94a3b8; display: block; margin-bottom: 14px;">Ngày duyệt: 11/05/2024 09:15</small>

		<label style="font-size: 12px; color: #475569; margin-bottom: 4px;">Nhận xét của giảng viên:</label>
		<div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 12px; font-size: 13px; color: #334155; line-height: 1.5;">
			"Đề tài phù hợp với năng lực nhóm. Chúc các em hoàn thành tốt đồ án môn học!"
		</div>
	</div>

</div>

<!-- Bottom Section Grid: Tabs (Báo cáo, Bài nộp, Nhận xét, Điểm) & Total Summary Card -->
<div class="row" style="grid-template-columns: 1.65fr 1fr; gap: 20px; align-items: start;">

	<!-- Left Tab Box: Progress, Reports, Submissions, Feedbacks -->
	<div class="topic-table-card" style="margin:0;">
		<!-- Tab Headers -->
		<div style="display: flex; gap: 20px; border-bottom: 1px solid #e2e8f0; padding: 0 20px; background: #f8fafc;">
			<div id="tab-btn-rep" onclick="switchDetailTab('rep')" style="padding: 14px 0; font-weight: 800; font-size: 13.5px; color: #1d4ed8; border-bottom: 2px solid #1d4ed8; margin-bottom: -1px; cursor: pointer;">
				Báo cáo tiến độ
			</div>
			<div id="tab-btn-sub" onclick="switchDetailTab('sub')" style="padding: 14px 0; font-weight: 700; font-size: 13.5px; color: #64748b; margin-bottom: -1px; cursor: pointer;">
				Bài nộp Cloudinary
			</div>
			<div id="tab-btn-fb" onclick="switchDetailTab('fb')" style="padding: 14px 0; font-weight: 700; font-size: 13.5px; color: #64748b; margin-bottom: -1px; cursor: pointer;">
				Nhận xét giảng viên
			</div>
		</div>

		<!-- Tab Content 1: Báo cáo tiến độ -->
		<div id="tab-content-rep" class="table-responsive">
			<table class="topic-data-table">
				<thead>
					<tr>
						<th style="width: 40px;">#</th>
						<th>Loại báo cáo / Tuần</th>
						<th>Mô tả</th>
						<th style="width: 100px;">Hạn nộp</th>
						<th style="width: 100px;">Trạng thái</th>
						<th style="width: 80px;">Điểm</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty reports}">
							<tr>
								<td colspan="6" class="table-empty">Chưa có báo cáo tiến độ nào.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="r" items="${reports}" varStatus="loop">
								<tr>
									<td>${loop.index + 1}</td>
									<td><strong style="color:#0f172a;">Tuần ${r.week_number} - ${r.title}</strong></td>
									<td><span style="font-size:13px; color:#475569;">${r.completed_work}</span></td>
									<td><span style="font-size:12px; color:#64748b;">15/05/2024</span></td>
									<td>
										<c:choose>
											<c:when test="${r.status=='REVIEWED'}">
												<span class="status-pill green" style="font-size:11px!important;">Đã nộp</span>
											</c:when>
											<c:otherwise>
												<span class="status-pill orange" style="font-size:11px!important;">Đang xử lý</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td><strong style="color:#1d4ed8;">8.5</strong></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>

		<!-- Tab Content 2: Bài nộp Cloudinary -->
		<div id="tab-content-sub" class="table-responsive" style="display:none;">
			<table class="topic-data-table">
				<thead>
					<tr>
						<th>Tên file</th>
						<th>Loại tài liệu</th>
						<th>Người nộp</th>
						<th>Thời gian</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty submissions}">
							<tr>
								<td colspan="4" class="table-empty">Chưa có tệp nộp nào trên Cloudinary.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="s" items="${submissions}">
								<tr>
									<td>
										<a href="${s.file_url}" target="_blank" style="font-weight: 700; color: #1d4ed8; text-decoration: underline;">
											📁 ${s.file_name}
										</a>
									</td>
									<td><span class="tag blue">${s.type}</span></td>
									<td><span style="font-size:12px; color:#64748b;">${s.submitted_by_name}</span></td>
									<td><span style="font-size:12px; color:#94a3b8;">${s.created_at}</span></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>

		<!-- Tab Content 3: Nhận xét -->
		<div id="tab-content-fb" style="display:none; padding: 20px;">
			<c:choose>
				<c:when test="${empty feedbacks}">
					<p class="table-empty" style="padding: 10px 0!important;">Chưa có nhận xét từ giảng viên.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="f" items="${feedbacks}">
						<div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 14px; margin-bottom: 12px;">
							<strong style="color: #0f172a; font-size: 14px; display: block; margin-bottom: 4px;">👨‍🏫 ${f.lecturer_name}</strong>
							<p style="margin: 0; font-size: 13px; color: #334155; line-height: 1.5;">${f.content}</p>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- Right Card: Tổng kết điểm -->
	<div class="admin-panel" style="border-radius: 16px; padding: 22px;">
		<small style="color: #64748b; font-weight: 700; font-size: 13px; display: block; margin-bottom: 14px;">Tổng kết điểm</small>

		<div style="display: grid; grid-template-columns: 1fr auto; gap: 10px; font-size: 13.5px; color: #475569; margin-bottom: 8px;">
			<span>Điểm báo cáo</span>
			<strong style="color: #0f172a;">8.5</strong>
		</div>
		<div style="display: grid; grid-template-columns: 1fr auto; gap: 10px; font-size: 13.5px; color: #475569; margin-bottom: 8px;">
			<span>Điểm bảo vệ</span>
			<strong style="color: #94a3b8;">--</strong>
		</div>
		<div style="display: grid; grid-template-columns: 1fr auto; gap: 10px; font-size: 13.5px; color: #475569; margin-bottom: 14px;">
			<span>Điểm chuyên cần</span>
			<strong style="color: #94a3b8;">--</strong>
		</div>

		<div style="border-top: 1px solid #e2e8f0; padding-top: 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
			<strong style="font-size: 15px; color: #0f172a;">Điểm tổng kết</strong>
			<span style="font-size: 24px; font-weight: 950; color: #1d4ed8;">8.5</span>
		</div>

		<div style="background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 10px; padding: 12px; font-size: 12px; color: #1e40af; line-height: 1.4;">
			<strong style="display:block; margin-bottom:2px;">ℹ Lưu ý</strong>
			Điểm tổng kết sẽ được cập nhật sau khi hoàn tất tất cả báo cáo cuối kỳ và bảo vệ. Sinh viên theo dõi tiến độ và nộp đúng hạn để tránh bị trừ điểm.
		</div>
	</div>

</div>

<script>
	function switchDetailTab(tabName) {
		document.getElementById('tab-btn-rep').style.color = '#64748b';
		document.getElementById('tab-btn-rep').style.borderBottom = 'none';
		document.getElementById('tab-btn-sub').style.color = '#64748b';
		document.getElementById('tab-btn-sub').style.borderBottom = 'none';
		document.getElementById('tab-btn-fb').style.color = '#64748b';
		document.getElementById('tab-btn-fb').style.borderBottom = 'none';

		document.getElementById('tab-content-rep').style.display = 'none';
		document.getElementById('tab-content-sub').style.display = 'none';
		document.getElementById('tab-content-fb').style.display = 'none';

		var activeTab = document.getElementById('tab-btn-' + tabName);
		var activeContent = document.getElementById('tab-content-' + tabName);

		if (activeTab && activeContent) {
			activeTab.style.color = '#1d4ed8';
			activeTab.style.borderBottom = '2px solid #1d4ed8';
			activeContent.style.display = 'block';
		}
	}
</script>

<%@ include file="../common/footer.jsp" %>

