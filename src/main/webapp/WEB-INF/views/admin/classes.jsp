<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%><h1>Quản lý lớp</h1>
<div class="card">
	<form method="post">
		<div class="row">
			<div>
				<label>Mã lớp</label><input name="code" required><label>Tên
					lớp</label><input name="name" required> <label>Ngành</label><input
					name="major">
			</div>
			<div>
				<label>Khóa tuyển sinh</label><input type="number" name="intakeYear">
				<label>Cố vấn</label><select name="advisorId"><option
						value="">-- Chọn --</option>
					<c:forEach var="l" items="${lecturers}">
						<option value="${l.id}">${l.lecturer_code}-
							${l.full_name}</option>
					</c:forEach></select>
			</div>
		</div>
		<button>Thêm lớp</button>
	</form>
</div>
<table>
	<tr>
		<th>Mã</th>
		<th>Tên</th>
		<th>Ngành</th>
		<th>Khóa</th>
		<th>Cố vấn</th>
	</tr>
	<c:forEach var="c" items="${classes}">
		<tr>
			<td>${c.code}</td>
			<td>${c.name}</td>
			<td>${c.major}</td>
			<td>${c.intake_year}</td>
			<td>${c.advisor_name}</td>
		</tr>
	</c:forEach>
</table>
<%@ include file="../common/footer.jsp"%>
