<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>
<h1>Dashboard giảng viên</h1><div class="grid"><div class="card"><h3>Đề tài của tôi</h3><div class="stat">${topics.size()}</div></div>
<div class="card"><h3>Nhóm hướng dẫn</h3><div class="stat">${groups.size()}</div></div></div>
<div class="card"><h3>Nhóm đang hướng dẫn</h3><table><tr><th>Nhóm</th><th>Đề tài</th><th>Trạng thái</th></tr>
<c:forEach var="g" items="${groups}"><tr><td><a href="${pageContext.request.contextPath}/groups/${g.id}">${g.group_name}</a></td><td>${g.topic_title}</td><td>${g.status}</td></tr></c:forEach></table></div>
<%@ include file="../common/footer.jsp" %>
