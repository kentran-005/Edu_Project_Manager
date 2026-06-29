<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %><h1>Quản lý học kỳ</h1><div class="card"><form method="post">
<div class="row"><div><label>Mã học kỳ</label><input name="code" required><label>Tên</label><input name="name" required>
<label>Trạng thái</label><select name="status"><option>UPCOMING</option><option>ACTIVE</option><option>CLOSED</option></select></div>
<div><label>Ngày bắt đầu</label><input type="date" name="startDate" required><label>Ngày kết thúc</label><input type="date" name="endDate" required>
<label>Hạn đăng ký</label><input type="date" name="registrationDeadline"></div></div><button>Thêm học kỳ</button></form></div>
<table><tr><th>Mã</th><th>Tên</th><th>Bắt đầu</th><th>Kết thúc</th><th>Trạng thái</th></tr>
<c:forEach var="s" items="${semesters}"><tr><td>${s.code}</td><td>${s.name}</td><td>${s.start_date}</td><td>${s.end_date}</td><td>${s.status}</td></tr></c:forEach></table>
<%@ include file="../common/footer.jsp" %>
