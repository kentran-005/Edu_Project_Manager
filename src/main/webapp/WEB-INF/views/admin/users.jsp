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
		<th>Mã/Lớp/Bộ môn</th>
		<th>Trạng thái</th>
		<th>Thao tác</th>
	</tr>
	<c:forEach var="u" items="${users}">
		<tr>
			<td>${u.username}</td>
			<td>${u.full_name}</td>
			<td>${u.email}</td>
			<td>${u.role}</td>
			<td>
				<c:if test="${u.role=='STUDENT'}">${u.student_code} · ${u.class_code}</c:if>
				<c:if test="${u.role=='LECTURER'}">${u.lecturer_code} · ${u.department}</c:if>
				<c:if test="${u.role=='ADMIN'}">Quản trị</c:if>
			</td>
			<td>${u.status}</td>
			<td>
				<form method="post" action="${pageContext.request.contextPath}/admin/user-status" class="inline-form">
					<input type="hidden" name="id" value="${u.id}">
					<select name="status">
						<c:choose><c:when test="${u.status=='ACTIVE'}"><option selected>ACTIVE</option></c:when><c:otherwise><option>ACTIVE</option></c:otherwise></c:choose>
						<c:choose><c:when test="${u.status=='INACTIVE'}"><option selected>INACTIVE</option></c:when><c:otherwise><option>INACTIVE</option></c:otherwise></c:choose>
						<c:choose><c:when test="${u.status=='LOCKED'}"><option selected>LOCKED</option></c:when><c:otherwise><option>LOCKED</option></c:otherwise></c:choose>
					</select>
					<button>Cập nhật</button>
				</form>
			</td>
		</tr>
	</c:forEach>
</table>
<%@ include file="../common/footer.jsp"%>
