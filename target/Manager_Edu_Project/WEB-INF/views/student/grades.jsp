<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %><h1>Kết quả đồ án</h1>
<table><tr><th>Nhóm</th><th>Đề tài</th><th>Điểm</th><th>Nhận xét</th><th>Giảng viên</th></tr>
<c:forEach var="g" items="${grades}"><tr><td>${g.group_name}</td><td>${g.topic_title}</td><td>${g.score}</td><td>${g.comment}</td><td>${g.lecturer_name}</td></tr></c:forEach></table>
<%@ include file="../common/footer.jsp" %>
