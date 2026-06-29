<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>
<h1>Dashboard quản trị</h1><div class="grid">
<c:forEach var="item" items="${stats}"><div class="card"><div>${item.key}</div><div class="stat">${item.value}</div></div></c:forEach>
</div><div class="card"><h3>Nhóm gần đây</h3><table><tr><th>Tên nhóm</th><th>Đề tài</th><th>Trạng thái</th></tr>
<c:forEach var="g" items="${groups}"><tr><td><a href="${pageContext.request.contextPath}/groups/${g.id}">${g.group_name}</a></td><td>${g.topic_title}</td><td>${g.status}</td></tr></c:forEach>
</table></div><%@ include file="../common/footer.jsp" %>
