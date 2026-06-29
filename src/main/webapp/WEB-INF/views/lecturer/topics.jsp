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
					min="1" max="10"> <label>Học kỳ</label><select
					name="semesterId"><c:forEach var="s" items="${semesters}">
						<option value="${s.id}">${s.name}</option>
					</c:forEach></select> <label>Trạng thái</label><select name="status"><option>DRAFT</option>
					<option>OPEN</option></select>
			</div>
		</div>
		<button>Thêm đề tài</button>
	</form>
</div>
<table>
	<tr>
		<th>Tiêu đề</th>
		<th>Học kỳ</th>
		<th>Công nghệ</th>
		<th>Thành viên</th>
		<th>Trạng thái</th>
	</tr>
	<c:forEach var="t" items="${topics}">
		<tr>
			<td>${t.title}</td>
			<td>${t.semester_name}</td>
			<td>${t.technology}</td>
			<td>${t.max_members}</td>
			<td>${t.status}</td>
		</tr>
	</c:forEach>
</table>
<%@ include file="../common/footer.jsp"%>
