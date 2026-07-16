<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%><h1>${group.group_name}</h1>
<div class="card">
	<p>
		<b>Đề tài:</b> ${group.topic_title}
	</p>
	<p>
		<b>Giảng viên:</b> ${group.lecturer_name}
	</p>
	<p>
		<b>Trạng thái:</b> ${group.status}
	</p>
	<p>
		<b>Mã mời:</b> ${group.invite_code}
	</p>
	<a
		href="${pageContext.request.contextPath}/pdf/group?groupId=${group.id}">Xuất
		PDF tiến độ</a>
</div>
<div class="card">
	<h3>Thành viên</h3>
	<table>
		<tr>
			<th>Mã SV</th>
			<th>Họ tên</th>
			<th>Email</th>
			<th>Vai trò</th>
		</tr>
		<c:forEach var="m" items="${members}">
			<tr>
				<td>${m.student_code}</td>
				<td>${m.full_name}</td>
				<td>${m.email}</td>
				<td>${m.role}</td>
			</tr>
		</c:forEach>
	</table>
</div>
<c:if
	test="${sessionScope.currentUser.role=='STUDENT' && group.status=='IN_PROGRESS'}">
	<div class="grid">
		<div class="card">
			<h3>Nộp tiến độ</h3>
			<form method="post"
				action="${pageContext.request.contextPath}/reports">
				<input type="hidden" name="groupId" value="${group.id}"><label>Tuần</label><input
					type="number" name="weekNumber" min="1" required> <label>Tiêu
					đề</label><input name="title" required><label>Đã hoàn thành</label>
				<textarea name="completedWork" required></textarea>
				<label>Kế hoạch tiếp theo</label>
				<textarea name="nextPlan"></textarea>
				<label>Khó khăn</label>
				<textarea name="difficulties"></textarea>
				<button>Nộp báo cáo</button>
			</form>
		</div>
		<div class="card">
			<h3>Upload bài nộp</h3>
			<form method="post" enctype="multipart/form-data"
				action="${pageContext.request.contextPath}/submissions">
				<input type="hidden" name="groupId" value="${group.id}"><label>Loại</label><select
					name="type"><option>PROPOSAL</option>
					<option>PROGRESS</option>
					<option>FINAL_REPORT</option>
					<option>SOURCE_CODE</option>
					<option>OTHER</option></select>
				<label>Gắn với báo cáo tiến độ</label><select name="reportId">
					<option value="">-- Không gắn báo cáo --</option>
					<c:forEach var="r" items="${reports}">
						<option value="${r.id}">Tuần ${r.week_number} - ${r.title}</option>
					</c:forEach>
				</select>
				<label>File</label><input type="file"
					name="file" required>
				<button>Upload Cloudinary</button>
			</form>
		</div>
	</div>
</c:if>
<div class="card">
	<h3>Báo cáo tiến độ</h3>
	<table>
		<tr>
			<th>Tuần</th>
			<th>Tiêu đề</th>
			<th>Hoàn thành</th>
			<th>Kế hoạch</th>
			<th>Trạng thái</th>
		</tr>
		<c:forEach var="r" items="${reports}">
			<tr>
				<td>${r.week_number}</td>
				<td>${r.title}</td>
				<td>${r.completed_work}</td>
				<td>${r.next_plan}</td>
				<td>${r.status}</td>
			</tr>
		</c:forEach>
	</table>
</div>
<div class="card">
	<h3>Bài nộp</h3>
	<table>
		<tr>
			<th>File</th>
			<th>Loại</th>
			<th>Người nộp</th>
			<th>Thời gian</th>
		</tr>
		<c:forEach var="s" items="${submissions}">
			<tr>
				<td><a href="${s.file_url}" target="_blank">${s.file_name}</a></td>
				<td>${s.type}</td>
				<td>${s.submitted_by_name}</td>
				<td>${s.created_at}</td>
			</tr>
		</c:forEach>
	</table>
</div>
<c:if test="${sessionScope.currentUser.role=='LECTURER'}">
	<div class="grid">
		<div class="card">
			<h3>Nhận xét</h3>
			<form method="post"
				action="${pageContext.request.contextPath}/feedbacks">
				<input type="hidden" name="groupId" value="${group.id}">
				<label>Nhận xét cho báo cáo</label><select name="reportId">
					<option value="">-- Không chọn báo cáo --</option>
					<c:forEach var="r" items="${reports}">
						<option value="${r.id}">Tuần ${r.week_number} - ${r.title}</option>
					</c:forEach>
				</select>
				<label>Nhận xét cho bài nộp</label><select name="submissionId">
					<option value="">-- Không chọn bài nộp --</option>
					<c:forEach var="s" items="${submissions}">
						<option value="${s.id}">${s.file_name}</option>
					</c:forEach>
				</select>
				<label>Nội
					dung</label>
				<textarea name="content" required></textarea>
				<button>Gửi nhận xét</button>
			</form>
		</div>
		<div class="card">
			<h3>Chấm điểm</h3>
			<form method="post"
				action="${pageContext.request.contextPath}/grades">
				<input type="hidden" name="groupId" value="${group.id}"> <label>Sinh
					viên</label><select name="studentId"><c:forEach var="m"
						items="${members}">
						<option value="${m.student_id}">${m.student_code}-
							${m.full_name}</option>
					</c:forEach></select> <label>Điểm</label><input type="number" step="0.01" min="0"
					max="10" name="score" required><label>Nhận xét</label>
				<textarea name="comment"></textarea>
				<label>Trạng thái</label><select name="status"><option>DRAFT</option>
					<option>PUBLISHED</option></select>
				<button>Lưu điểm</button>
			</form>
		</div>
	</div>
</c:if>
<div class="card">
	<h3>Nhận xét</h3>
	<c:forEach var="f" items="${feedbacks}">
		<p>
			<b>${f.lecturer_name}:</b> ${f.content}
		</p>
	</c:forEach>
</div>
<div class="card">
	<h3>Điểm</h3>
	<table>
		<tr>
			<th>Sinh viên</th>
			<th>Điểm</th>
			<th>Nhận xét</th>
			<th>Trạng thái</th>
		</tr>
		<c:forEach var="gr" items="${grades}">
			<tr>
				<td>${gr.student_code} - ${gr.student_name}</td>
				<td>${gr.score}</td>
				<td>${gr.comment}</td>
				<td>${gr.status}</td>
			</tr>
		</c:forEach>
	</table>
</div>
<%@ include file="../common/footer.jsp"%>
