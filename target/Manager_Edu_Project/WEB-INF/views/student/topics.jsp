<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %><h1>Danh sách đề tài</h1>
<table><tr><th>Đề tài</th><th>Giảng viên</th><th>Mô tả</th><th>Công nghệ</th><th>Trạng thái</th></tr>
<c:forEach var="t" items="${topics}"><tr><td>${t.title}</td><td>${t.lecturer_name}</td><td>${t.description}</td><td>${t.technology}</td><td>${t.status}</td></tr></c:forEach></table>
<%@ include file="../common/footer.jsp" %>
