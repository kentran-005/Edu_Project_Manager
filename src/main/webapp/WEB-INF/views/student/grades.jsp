<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Title -->
<div class="page-header-row" style="margin-bottom: 20px;">
	<div class="page-title-box">
		<h1>Đánh giá & Kết quả điểm số</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Kết quả đồ án môn học</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-filter" onclick="window.print()">🖨 In bảng điểm</button>
	</div>
</div>

<!-- 4 Phase Breakdown Cards Grid (Dynamic Data based on Lecturer Grades) -->
<div class="topic-stats-grid" style="grid-template-columns: repeat(4, 1fr)!important; margin-bottom: 24px;">
	<c:set var="hasGrade" value="${not empty grades && fn:length(grades) > 0}"/>
	<c:set var="myScore" value="${hasGrade ? grades[0].score : null}"/>

	<!-- Phase 1: Đề cương -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon blue">📝</div>
			<div class="stat-card-info">
				<label>Giai đoạn 1: Đề cương (20%)</label>
				<strong>
					<c:choose>
						<c:when test="${hasGrade}">
							<fmt:formatNumber value="${myScore}" maxFractionDigits="1"/> <small style="font-size:13px; color:#64748b;">/10</small>
						</c:when>
						<c:otherwise>-- <small style="font-size:13px; color:#64748b;">/10</small></c:otherwise>
					</c:choose>
				</strong>
				<span class="stat-card-sub">Trọng số 20% tổng điểm</span>
			</div>
		</div>
		<span class="stat-card-link" style="color:${hasGrade ? '#16a34a' : '#94a3b8'}!important;">
			${hasGrade ? '✓ Đã chấm điểm' : 'Chưa có điểm'}
		</span>
	</div>

	<!-- Phase 2: Báo cáo giữa kỳ -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon green">📊</div>
			<div class="stat-card-info">
				<label>Giai đoạn 2: Giữa kỳ (30%)</label>
				<strong>
					<c:choose>
						<c:when test="${hasGrade}">
							<fmt:formatNumber value="${myScore}" maxFractionDigits="1"/> <small style="font-size:13px; color:#64748b;">/10</small>
						</c:when>
						<c:otherwise>-- <small style="font-size:13px; color:#64748b;">/10</small></c:otherwise>
					</c:choose>
				</strong>
				<span class="stat-card-sub">Trọng số 30% tổng điểm</span>
			</div>
		</div>
		<span class="stat-card-link" style="color:${hasGrade ? '#16a34a' : '#94a3b8'}!important;">
			${hasGrade ? '✓ Đã chấm điểm' : 'Chưa có điểm'}
		</span>
	</div>

	<!-- Phase 3: Bảo vệ đồ án -->
	<div class="topic-stat-card">
		<div class="stat-card-top">
			<div class="stat-card-icon orange">🏆</div>
			<div class="stat-card-info">
				<label>Giai đoạn 3: Cuối kỳ (50%)</label>
				<strong>
					<c:choose>
						<c:when test="${hasGrade}">
							<fmt:formatNumber value="${myScore}" maxFractionDigits="1"/> <small style="font-size:13px; color:#64748b;">/10</small>
						</c:when>
						<c:otherwise>-- <small style="font-size:13px; color:#64748b;">/10</small></c:otherwise>
					</c:choose>
				</strong>
				<span class="stat-card-sub">Trọng số 50% tổng điểm</span>
			</div>
		</div>
		<span class="stat-card-link" style="color:${hasGrade ? '#1d4ed8' : '#94a3b8'}!important;">
			${hasGrade ? '★ Điểm từ Giảng viên' : 'Chờ công bố'}
		</span>
	</div>

	<!-- Final Grade Overall Card -->
	<div class="topic-stat-card" style="background:#eff6ff!important; border-color:#bfdbfe!important;">
		<div class="stat-card-top">
			<div class="stat-card-icon purple">🎓</div>
			<div class="stat-card-info">
				<label style="color:#1e40af!important;">Điểm Tổng Kết Học Kỳ</label>
				<strong style="color:#1d4ed8!important; font-size:26px!important;">
					<c:choose>
						<c:when test="${hasGrade}">${myScore} <small style="font-size:14px; font-weight:normal; color:#1e40af;">/10</small></c:when>
						<c:otherwise>-- <small style="font-size:14px; font-weight:normal; color:#1e40af;">/10</small></c:otherwise>
					</c:choose>
				</strong>
				<span class="stat-card-sub" style="color:#3b82f6!important;">
					Xếp loại: <b>
					<c:choose>
						<c:when test="${hasGrade && myScore >= 9.0}">Xuất sắc</c:when>
						<c:when test="${hasGrade && myScore >= 8.0}">Giỏi</c:when>
						<c:when test="${hasGrade && myScore >= 6.5}">Khá</c:when>
						<c:when test="${hasGrade && myScore >= 5.0}">Trung bình</c:when>
						<c:when test="${hasGrade}">Chưa đạt</c:when>
						<c:otherwise>Chưa công bố</c:otherwise>
					</c:choose>
					</b>
				</span>
			</div>
		</div>
		<span class="stat-card-link" style="color:#1d4ed8!important;">
			Trạng thái: <b>${hasGrade ? 'Đã công bố' : 'Đang chấm'}</b>
		</span>
	</div>
</div>

<!-- Detailed Grades Table Breakdown (Live Database Rows from Lecturer) -->
<div class="topic-table-card">
	<div class="card-title-head">
		<h3>Bảng điểm kết quả do Giảng viên công bố</h3>
	</div>
	<div class="table-responsive">
		<table class="topic-data-table">
			<thead>
				<tr>
					<th style="width: 50px;">#</th>
					<th>Tên nhóm đồ án</th>
					<th>Tên đề tài</th>
					<th style="width: 170px;">Giảng viên chấm điểm</th>
					<th style="width: 110px; text-align:center;">Điểm chính thức</th>
					<th>Nhận xét & Đánh giá của Giảng viên</th>
					<th style="width: 120px;">Trạng thái</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty grades}">
						<tr>
							<td colspan="7" class="table-empty" style="padding: 40px 20px!important;">
								<div style="font-size: 42px; margin-bottom: 8px;">📊</div>
								<strong style="font-size: 15px; color: #0f172a; display: block; margin-bottom: 4px;">Chưa có điểm số nào được công bố.</strong>
								<span style="font-size: 13px; color: #64748b;">Điểm số chính thức sẽ xuất hiện tại đây ngay khi Giảng viên hoàn tất chấm điểm và công bố (PUBLISHED).</span>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="g" items="${grades}" varStatus="loop">
							<tr>
								<td>${loop.index + 1}</td>
								<td><strong style="color: #0f172a;">${g.group_name}</strong></td>
								<td><span style="font-weight: 700; color: #1d4ed8;">${not empty g.topic_title ? g.topic_title : 'Đồ án môn học'}</span></td>
								<td>
									<div style="display:flex; align-items:center; gap:8px;">
										<span style="width:24px; height:24px; border-radius:50%; background:#dbeafe; color:#1d4ed8; display:grid; place-items:center; font-size:10px; font-weight:800;">GV</span>
										<span>${not empty g.lecturer_name ? g.lecturer_name : 'Giảng viên hướng dẫn'}</span>
									</div>
								</td>
								<td style="text-align: center;">
									<span style="font-size: 20px; font-weight: 950; color: #1d4ed8;">${g.score}</span>
									<small style="color: #64748b;">/10</small>
								</td>
								<td>
									<span style="font-size: 13px; color: #334155; line-height: 1.4;">
										${not empty g.comment ? g.comment : 'Giảng viên chưa nhập thêm nhận xét.'}
									</span>
								</td>
								<td>
									<span class="status-pill green">Đã công bố</span>
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



