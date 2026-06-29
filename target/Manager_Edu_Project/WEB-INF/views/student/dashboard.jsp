<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>
<h1>Dashboard sinh viên</h1><div class="card"><h3>Nhóm của tôi</h3>
<table><tr><th>Nhóm</th><th>Đề tài</th><th>Vai trò</th><th>Trạng thái</th></tr>
<c:forEach var="g" items="${groups}"><tr><td><a href="${pageContext.request.contextPath}/groups/${g.id}">${g.group_name}</a></td><td>${g.topic_title}</td><td>${g.member_role}</td><td>${g.status}</td></tr></c:forEach></table></div>
<div class="card"><h3>Đề tài đang mở</h3><table><tr><th>Tên</th><th>Giảng viên</th><th>Công nghệ</th></tr>
<c:forEach var="t" items="${topics}"><tr><td>${t.title}</td><td>${t.lecturer_name}</td><td>${t.technology}</td></tr></c:forEach></table></div>
<%@ include file="../common/footer.jsp" %>
