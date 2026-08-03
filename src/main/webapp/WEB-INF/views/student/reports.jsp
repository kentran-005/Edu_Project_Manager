<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Action Controls -->
<div class="page-header-row" style="margin-bottom: 20px;">
	<div class="page-title-box">
		<h1>Quản lý Báo cáo / Bài nộp</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Báo cáo / Bài nộp</p>
	</div>
	<div class="page-header-actions">
		<c:choose>
			<c:when test="${not empty groups}">
				<a class="btn-add-primary" href="${pageContext.request.contextPath}/groups/${groups[0].id}" style="text-decoration:none;">+ Nộp báo cáo / Bài nộp</a>
			</c:when>
			<c:otherwise>
				<a class="btn-add-primary" href="${pageContext.request.contextPath}/groups" style="text-decoration:none;">+ Tham gia nhóm để nộp</a>
			</c:otherwise>
		</c:choose>
	</div>
</div>

<!-- Tabs Navigation -->
<div style="display: flex; gap: 24px; border-bottom: 2px solid #e2e8f0; margin-bottom: 24px;">
	<div id="rep-tab-btn-reports" onclick="switchReportTab('reports')" style="padding: 10px 4px; font-weight: 800; font-size: 14px; color: #1d4ed8; border-bottom: 2px solid #1d4ed8; margin-bottom: -2px; cursor: pointer; display: flex; align-items: center; gap: 8px;">
		<span>📝</span> Báo cáo tiến độ tuần
	</div>
	<div id="rep-tab-btn-submissions" onclick="switchReportTab('submissions')" style="padding: 10px 4px; font-weight: 700; font-size: 14px; color: #64748b; margin-bottom: -2px; cursor: pointer; display: flex; align-items: center; gap: 8px;">
		<span>☁️</span> Bài nộp Cloudinary / Mã nguồn
	</div>
</div>

<!-- Tab Content 1: Báo cáo tiến độ tuần -->
<div id="rep-tab-content-reports" class="topic-table-card">
	<div class="card-title-head">
		<h3>Danh sách Báo cáo tiến độ đã gửi</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table">
			<thead>
				<tr>
					<th style="width: 70px;">Tuần</th>
					<th>Tiêu đề báo cáo</th>
					<th>Nội dung công việc đã hoàn thành</th>
					<th>Kế hoạch tiếp theo</th>
					<th style="width: 130px;">Trạng thái</th>
					<th style="width: 100px; text-align:center;">Thao tác</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty reports}">
						<tr>
							<td colspan="6" class="table-empty" style="padding: 40px 20px!important;">
								<div style="font-size: 38px; margin-bottom: 8px;">📝</div>
								<strong style="font-size: 15px; color: #0f172a; display: block; margin-bottom: 4px;">Chưa có báo cáo tiến độ nào.</strong>
								<span style="font-size: 13px; color: #64748b;">Hãy truy cập trang Chi tiết nhóm để bắt đầu gửi báo cáo hàng tuần.</span>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="r" items="${reports}">
							<tr>
								<td><span class="topic-code-tag" style="background:#f1f5f9; color:#334155;">Tuần ${r.week_number}</span></td>
								<td><strong style="color:#0f172a;">${r.title}</strong></td>
								<td><span style="font-size: 13px; color: #475569;">${r.completed_work}</span></td>
								<td><span style="font-size: 13px; color: #64748b;">${not empty r.next_plan ? r.next_plan : '--'}</span></td>
								<td>
									<c:choose>
										<c:when test="${r.status=='REVIEWED'}">
											<span class="status-pill green">Đã nhận xét</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill orange">Chờ nhận xét</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td style="text-align: center;">
									<c:if test="${not empty groups}">
										<a class="btn-filter" style="padding: 4px 10px!important; font-size: 12px!important; text-decoration:none;" href="${pageContext.request.contextPath}/groups/${groups[0].id}">Xem nhóm</a>
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>

<!-- Tab Content 2: Bài nộp Cloudinary -->
<div id="rep-tab-content-submissions" class="topic-table-card" style="display:none;">
	<div class="card-title-head">
		<h3>Danh sách tệp nộp / Mã nguồn (Cloudinary Storage)</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table">
			<thead>
				<tr>
					<th style="width: 50px;">#</th>
					<th>Tên tệp tin</th>
					<th>Phân loại tài liệu</th>
					<th>Người nộp</th>
					<th style="width: 140px;">Thời gian nộp</th>
					<th style="width: 120px; text-align:center;">Tải về / Xem</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty submissions}">
						<tr>
							<td colspan="6" class="table-empty" style="padding: 40px 20px!important;">
								<div style="font-size: 38px; margin-bottom: 8px;">☁️</div>
								<strong style="font-size: 15px; color: #0f172a; display: block; margin-bottom: 4px;">Chưa có tài liệu hoặc bài nộp nào.</strong>
								<span style="font-size: 13px; color: #64748b;">Bạn có thể upload Proposal, Progress hay Source code (ZIP) lên Cloudinary từ trang chi tiết nhóm.</span>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="s" items="${submissions}" varStatus="loop">
							<tr>
								<td>${loop.index + 1}</td>
								<td>
									<a href="${s.file_url}" target="_blank" style="font-weight: 700; color: #1d4ed8; text-decoration: underline;">
										📁 ${s.file_name}
									</a>
								</td>
								<td><span class="tag blue">${s.type}</span></td>
								<td><span style="font-size: 13px; color: #334155;">${s.submitted_by_name}</span></td>
								<td><span style="font-size: 12px; color: #64748b;">${s.created_at}</span></td>
								<td style="text-align: center;">
									<a href="${s.file_url}" target="_blank" class="btn-add-primary" style="padding: 4px 10px!important; font-size: 12px!important; text-decoration:none;">
										📥 Tải xuống
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
	function switchReportTab(tabName) {
		document.getElementById('rep-tab-btn-reports').style.color = '#64748b';
		document.getElementById('rep-tab-btn-reports').style.borderBottom = 'none';
		document.getElementById('rep-tab-btn-reports').style.fontWeight = '700';

		document.getElementById('rep-tab-btn-submissions').style.color = '#64748b';
		document.getElementById('rep-tab-btn-submissions').style.borderBottom = 'none';
		document.getElementById('rep-tab-btn-submissions').style.fontWeight = '700';

		document.getElementById('rep-tab-content-reports').style.display = 'none';
		document.getElementById('rep-tab-content-submissions').style.display = 'none';

		var activeBtn = document.getElementById('rep-tab-btn-' + tabName);
		var activeContent = document.getElementById('rep-tab-content-' + tabName);

		if (activeBtn && activeContent) {
			activeBtn.style.color = '#1d4ed8';
			activeBtn.style.borderBottom = '2px solid #1d4ed8';
			activeBtn.style.fontWeight = '800';
			activeContent.style.display = 'block';
		}
	}
</script>

<%@ include file="../common/footer.jsp" %>
