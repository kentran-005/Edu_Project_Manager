<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Action Controls -->
<div class="page-header-row" style="margin-bottom: 20px;">
	<div class="page-title-box">
		<h1>Lịch trình học kỳ & Đồ án</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Lịch trình</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-filter" onclick="window.print()">🖨 In lịch trình</button>
	</div>
</div>

<!-- Semester Progress Timeline Overview -->
<div class="admin-panel" style="border-radius: 16px; margin-bottom: 24px; padding: 22px;">
	<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
		<div>
			<h3 style="margin:0; font-size:18px; color:#0f172a;">Lộ trình thực hiện đồ án môn học</h3>
			<small style="color:#64748b;">Học kỳ 2 (2023 - 2024)</small>
		</div>
		<span class="status-pill green">Đang diễn ra (Tuần 8 / 15)</span>
	</div>

	<!-- Visual Step Timeline -->
	<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; background: #f8fafc; padding: 20px; border-radius: 12px; border: 1px solid #e2e8f0; text-align: center;">
		<div style="position: relative;">
			<div style="width: 36px; height: 36px; border-radius: 50%; background: #22c55e; color: white; display: grid; place-items: center; margin: 0 auto 8px; font-weight: 900;">✓</div>
			<strong style="font-size: 13.5px; color: #0f172a; display: block;">1. Đăng ký đề tài</strong>
			<small style="color: #64748b; font-size: 11.5px;">Tuần 1 - Tuần 3</small>
		</div>
		<div style="position: relative;">
			<div style="width: 36px; height: 36px; border-radius: 50%; background: #2563eb; color: white; display: grid; place-items: center; margin: 0 auto 8px; font-weight: 900;">2</div>
			<strong style="font-size: 13.5px; color: #1d4ed8; display: block;">2. Phân tích & Báo cáo</strong>
			<small style="color: #64748b; font-size: 11.5px;">Tuần 4 - Tuần 10</small>
		</div>
		<div style="position: relative;">
			<div style="width: 36px; height: 36px; border-radius: 50%; background: #cbd5e1; color: white; display: grid; place-items: center; margin: 0 auto 8px; font-weight: 900;">3</div>
			<strong style="font-size: 13.5px; color: #64748b; display: block;">3. Nộp sản phẩm & Code</strong>
			<small style="color: #94a3b8; font-size: 11.5px;">Tuần 11 - Tuần 13</small>
		</div>
		<div>
			<div style="width: 36px; height: 36px; border-radius: 50%; background: #cbd5e1; color: white; display: grid; place-items: center; margin: 0 auto 8px; font-weight: 900;">4</div>
			<strong style="font-size: 13.5px; color: #64748b; display: block;">4. Bảo vệ đồ án</strong>
			<small style="color: #94a3b8; font-size: 11.5px;">Tuần 14 - Tuần 15</small>
		</div>
	</div>
</div>

<!-- Milestones Table Card -->
<div class="topic-table-card">
	<div class="card-title-head">
		<h3>Danh sách mốc thời gian chi tiết</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table">
			<thead>
				<tr>
					<th style="width: 60px;">Mốc</th>
					<th>Tên sự kiện / Mốc công việc</th>
					<th>Mô tả & Nêu yêu cầu</th>
					<th style="width: 140px;">Hạn chót (Deadline)</th>
					<th style="width: 130px;">Trạng thái</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty milestones}">
						<tr>
							<td colspan="5" class="table-empty" style="padding: 40px 20px!important;">
								<div style="font-size: 38px; margin-bottom: 8px;">▦</div>
								<strong style="font-size: 15px; color: #0f172a; display: block; margin-bottom: 4px;">Chưa có mốc thời gian nào trong học kỳ này.</strong>
								<span style="font-size: 13px; color: #64748b;">Lịch trình môn học sẽ được Ban quản trị công bố theo từng giai đoạn.</span>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="m" items="${milestones}" varStatus="loop">
							<tr>
								<td><span class="topic-code-tag">M${loop.index + 1}</span></td>
								<td><strong style="color:#0f172a;">${m.name}</strong></td>
								<td>${not empty m.description ? m.description : 'Đồ án môn học'}</td>
								<td><span style="font-weight:700; color:#dc2626;">${m.due_date}</span></td>
								<td>
									<c:choose>
										<c:when test="${m.status == 'COMPLETED'}">
											<span class="status-pill green">Đã hoàn thành</span>
										</c:when>
										<c:when test="${m.status == 'IN_PROGRESS'}">
											<span class="status-pill blue">Đang thực hiện</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill orange">Sắp tới</span>
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

<%@ include file="../common/footer.jsp" %>
