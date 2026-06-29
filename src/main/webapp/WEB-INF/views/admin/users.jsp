<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%><h1>Quản lý tài khoản</h1>
<div class="card">
	<form method="post">
		<div class="row">
			<div>
				<label>Username</label><input name="username" required> <label>Email</label><input
					type="email" name="email" required><label>Mật khẩu</label><input
					type="password" name="password" required> <label>Họ
					tên</label><input name="fullName" required>
			</div>
			<div>
				<label>Điện thoại</label><input name="phone"> <label>Vai
					trò</label><select name="role"><option>STUDENT</option>
					<option>LECTURER</option>
					<option>ADMIN</option></select> <label>Mã SV/GV</label><input name="code"><label>Lớp</label><select
					name="classId"><option value="">-- Chọn --</option>
					<c:forEach var="c" items="${classes}">
						<option value="${c.id}">${c.code}</option>
					</c:forEach></select> <label>Khoa/Bộ môn</label><input name="department"><label>Học
					hàm</label><input name="academicRank">
			</div>
		</div>
		<button>Thêm tài khoản</button>
	</form>
</div>
<table>
	<tr>
		<th>Username</th>
		<th>Họ tên</th>
		<th>Email</th>
		<th>Vai trò</th>
		<th>Trạng thái</th>
	</tr>
	<c:forEach var="u" items="${users}">
		<tr>
			<td>${u.username}</td>
			<td>${u.full_name}</td>
			<td>${u.email}</td>
			<td>${u.role}</td>
			<td>${u.status}</td>
		</tr>
	</c:forEach>
</table>
<%@ include file="../common/footer.jsp"%>
