<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%><h1>Đề tài của tôi</h1>
<div class="card">
	<form method="post">
		<div class="row">
			<div>
				<label>Tiêu đề</label><input name="title" required> <label>Mô
					tả</label>
				<textarea name="description" required></textarea>
				<label>Yêu cầu</label>
				<textarea name="requirements"></textarea>
			</div>
			<div>
				<label>Công nghệ</label><input name="technology"><label>Số
					thành viên tối đa</label><input type="number" name="maxMembers" value="3"
					min="1" max="10" min="1" max="10"> <label>Học kỳ</label><select
					name="semesterId" required>
					<option value="">-- Chọn học kỳ --</option>
					<c:forEach var="s" items="${semesters}">
						<option value="${s.id}">${s.name}</option>
					</c:forEach>
				</select>
				<c:if test="${empty semesters}">
					<p class="hint error-text">Chưa có học kỳ. Vui lòng nhờ Admin
						tạo học kỳ trước khi thêm đề tài.</p>
				</c:if>
				<label>Trạng thái</label><select name="status"><option>DRAFT</option>
					<option>OPEN</option></select>
			</div>
		</div>
		<c:choose>
			<c:when test="${empty semesters}">
				<button disabled>Thêm đề tài</button>
			</c:when>
			<c:otherwise>
				<button>Thêm đề tài</button>
			</c:otherwise>
		</c:choose>
	</form>
</div>
<table>
	<tr>
		<th>Tiêu đề</th>
		<th>Học kỳ</th>
		<th>Công nghệ</th>
		<th>Thành viên</th>
		<th>Trạng thái</th>
		<th>Cập nhật</th>
	</tr>
	<c:forEach var="t" items="${topics}">
		<tr>
			<td>${t.title}</td>
			<td>${t.semester_name}</td>
			<td>${t.technology}</td>
			<td>${t.max_members}</td>
			<td>${t.status}</td>
			<td><c:if test="${t.status!='ASSIGNED'}">
					<form method="post" class="compact-form">
						<input type="hidden" name="action" value="update"> <input
							type="hidden" name="id" value="${t.id}"> <label>Tiêu
							đề</label><input name="title" value="${t.title}" required> <label>Mô
							tả</label>
						<textarea name="description" required>${t.description}</textarea>
						<label>Yêu cầu</label>
						<textarea name="requirements">${t.requirements}</textarea>
						<label>Công nghệ</label><input name="technology"
							value="${t.technology}"> <label>Số thành viên</label><input
							type="number" name="maxMembers" value="${t.max_members}" min="1"
							max="10"> <label>Trạng thái</label><select name="status">
							<c:choose>
								<c:when test="${t.status=='DRAFT'}">
									<option selected>DRAFT</option>
								</c:when>
								<c:otherwise>
									<option>DRAFT</option>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${t.status=='OPEN'}">
									<option selected>OPEN</option>
								</c:when>
								<c:otherwise>
									<option>OPEN</option>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${t.status=='CLOSED'}">
									<option selected>CLOSED</option>
								</c:when>
								<c:otherwise>
									<option>CLOSED</option>
								</c:otherwise>
							</c:choose>
						</select>
						<button>Cập nhật đề tài</button>
					</form>
				</c:if> <c:if test="${t.status=='ASSIGNED'}">
					<span class="muted">Đã giao, không sửa</span>
				</c:if></td>
		</tr>
	</c:forEach>
</table>
<%@ include file="../common/footer.jsp"%>
