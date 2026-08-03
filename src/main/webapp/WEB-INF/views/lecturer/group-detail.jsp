<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<!-- Detail Banner Header -->
<div class="page-header-row" style="background:white;padding:24px;border-radius:18px;border:1px solid #e2e8f0;box-shadow:0 4px 16px rgba(15,23,42,0.04);margin-bottom:24px">
	<div>
		<div style="display:flex;align-items:center;gap:10px;margin-bottom:8px">
			<span class="topic-code-tag">NHOM_00${group.id}</span>
			<c:choose>
				<c:when test="${group.status=='IN_PROGRESS'}">
					<span class="status-pill green">Đang thực hiện</span>
				</c:when>
				<c:when test="${group.status=='COMPLETED'}">
					<span class="status-pill purple">Hoàn thành</span>
				</c:when>
				<c:otherwise>
					<span class="status-pill orange">Khởi tạo</span>
				</c:otherwise>
			</c:choose>
		</div>
		<h1 style="font-size:26px;font-weight:800;color:#0f172a;margin:0 0 6px">${group.group_name}</h1>
		<p style="margin:0;color:#2563eb;font-weight:700;font-size:15px">📘 Đề tài: ${group.topic_title}</p>
	</div>
	<div class="page-header-actions">
		<a class="btn-add-primary" href="${pageContext.request.contextPath}/pdf/group?groupId=${group.id}" target="_blank" style="background:#15803d">
			📄 Xuất PDF tiến độ
		</a>
		<a class="btn-filter" href="${pageContext.request.contextPath}/groups">
			← Quay lại danh sách
		</a>
	</div>
</div>

<!-- 2-Column Dashboard Grid -->
<div class="dashboard-grid wide-left" style="gap:24px">
	
	<!-- LEFT COLUMN: Members, Reports, Submissions -->
	<div style="display:flex;flex-direction:column;gap:24px">
		
		<!-- Card 1: Thành viên nhóm -->
		<div class="topic-table-card">
			<div class="card-title-head">
				<h3>👥 Thành viên nhóm (${fn:length(members)})</h3>
			</div>
			<div class="table-responsive">
				<table class="topic-data-table">
					<thead>
						<tr>
							<th style="width:120px">Mã SV</th>
							<th>Họ tên</th>
							<th>Email</th>
							<th style="width:110px">Vai trò</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="m" items="${members}">
							<tr>
								<td><strong>${m.student_code}</strong></td>
								<td><strong style="color:#0f172a">${m.full_name}</strong></td>
								<td>${m.email}</td>
								<td>
									<c:choose>
										<c:when test="${m.role=='LEADER'}">
											<span class="status-pill orange">Trưởng nhóm</span>
										</c:when>
										<c:otherwise>
											<span class="status-pill blue">Thành viên</span>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>

		<!-- Card 2: Báo cáo tiến độ -->
		<div class="topic-table-card">
			<div class="card-title-head">
				<h3>📋 Báo cáo tiến độ đồ án</h3>
			</div>
			<div class="table-responsive">
				<table class="topic-data-table">
					<thead>
						<tr>
							<th style="width:60px">Tuần</th>
							<th>Tiêu đề báo cáo</th>
							<th>Đã hoàn thành</th>
							<th style="width:120px">Trạng thái</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty reports}">
								<tr>
									<td colspan="4" class="table-empty">Nhóm chưa nộp báo cáo tiến độ nào.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="r" items="${reports}">
									<tr>
										<td><strong>T${r.week_number}</strong></td>
										<td>
											<strong style="color:#0f172a">${r.title}</strong>
											<c:if test="${not empty r.next_plan}">
												<small style="display:block;color:#64748b;margin-top:2px">Next: ${r.next_plan}</small>
											</c:if>
										</td>
										<td>${r.completed_work}</td>
										<td>
											<c:choose>
												<c:when test="${r.status=='REVIEWED'}">
													<span class="status-pill green">Đã nhận xét</span>
												</c:when>
												<c:otherwise>
													<span class="status-pill orange">Đã nộp</span>
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

		<!-- Card 3: Bài nộp (Submissions) -->
		<div class="topic-table-card">
			<div class="card-title-head">
				<h3>📁 Bài nộp & Tài liệu</h3>
			</div>
			<div class="table-responsive">
				<table class="topic-data-table">
					<thead>
						<tr>
							<th>Tên file</th>
							<th style="width:110px">Loại</th>
							<th style="width:140px">Người nộp</th>
							<th style="width:120px">Thời gian</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty submissions}">
								<tr>
									<td colspan="4" class="table-empty">Chưa có bài nộp nào từ nhóm.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="s" items="${submissions}">
									<tr>
										<td>
											<a href="${s.file_url}" target="_blank" style="font-weight:800;color:#2563eb">
												📎 ${s.file_name}
											</a>
										</td>
										<td><span class="topic-code-tag">${s.type}</span></td>
										<td>${s.submitted_by_name}</td>
										<td>${fn:substring(s.created_at,0,10)}</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>

	</div>

	<!-- RIGHT COLUMN: Feedback, Grading, History -->
	<div style="display:flex;flex-direction:column;gap:24px">
		
		<!-- Card 4: Gửi nhận xét -->
		<div class="topic-table-card" id="feedback">
			<div class="card-title-head">
				<h3>💬 Viết nhận xét cho nhóm</h3>
			</div>
			<form method="post" action="${pageContext.request.contextPath}/feedbacks" style="padding:20px">
				<input type="hidden" name="groupId" value="${group.id}">
				
				<label>Chọn báo cáo tiến độ</label>
				<select name="reportId">
					<option value="">-- Không chọn báo cáo --</option>
					<c:forEach var="r" items="${reports}">
						<option value="${r.id}">Tuần ${r.week_number} - ${r.title}</option>
					</c:forEach>
				</select>
				
				<label>Chọn bài nộp</label>
				<select name="submissionId">
					<option value="">-- Không chọn bài nộp --</option>
					<c:forEach var="s" items="${submissions}">
						<option value="${s.id}">${s.file_name}</option>
					</c:forEach>
				</select>
				
				<label>Nội dung nhận xét <span style="color:red">*</span></label>
				<textarea name="content" required placeholder="Nhập lời khuyên, nhận xét cho sinh viên..."></textarea>
				
				<button type="submit" class="btn-add-primary" style="width:100%;margin-top:8px">Gửi nhận xét</button>
			</form>
		</div>

		<!-- Card 5: Chấm điểm đồ án -->
		<div class="topic-table-card" id="grade">
			<div class="card-title-head">
				<h3>⭐ Chấm điểm sinh viên</h3>
			</div>
			<form method="post" action="${pageContext.request.contextPath}/grades" style="padding:20px">
				<input type="hidden" name="groupId" value="${group.id}">
				
				<label>Chọn sinh viên <span style="color:red">*</span></label>
				<select name="studentId" required>
					<option value="">-- Chọn sinh viên --</option>
					<c:forEach var="m" items="${members}">
						<option value="${m.student_id}">${m.student_code} - ${m.full_name}</option>
					</c:forEach>
				</select>
				
				<label>Điểm số (thang điểm 10) <span style="color:red">*</span></label>
				<input type="number" step="0.1" min="0" max="10" name="score" required placeholder="Nhập điểm từ 0.0 đến 10.0">
				
				<label>Đánh giá / Nhận xét điểm</label>
				<textarea name="comment" placeholder="Đánh giá chi tiết ưu/nhược điểm..."></textarea>
				
				<label>Trạng thái công bố</label>
				<select name="status">
					<option value="DRAFT">DRAFT (Lưu nháp)</option>
					<option value="PUBLISHED" selected>PUBLISHED (Công bố cho sinh viên)</option>
				</select>
				
				<button type="submit" class="btn-add-primary" style="width:100%;margin-top:8px;background:#15803d">Lưu điểm</button>
			</form>
		</div>

		<!-- Card 6: Lịch sử nhận xét & Bảng điểm -->
		<div class="topic-table-card">
			<div class="card-title-head">
				<h3>🏆 Điểm số đã chấm</h3>
			</div>
			<div class="table-responsive">
				<table class="topic-data-table">
					<thead>
						<tr>
							<th>Sinh viên</th>
							<th style="width:70px">Điểm</th>
							<th style="width:100px">Trạng thái</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty grades}">
								<tr>
									<td colspan="3" class="table-empty">Chưa có điểm nào được chấm.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="gr" items="${grades}">
									<tr>
										<td>
											<strong style="color:#0f172a">${gr.student_name}</strong>
											<small style="display:block;color:#64748b">${gr.comment}</small>
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

	</div>

</div>

<%@ include file="../common/footer.jsp"%>
