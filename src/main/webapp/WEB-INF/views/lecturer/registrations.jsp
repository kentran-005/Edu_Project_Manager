<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%><h1>Duyệt đăng ký đề tài</h1>
<table>
	<tr>
		<th>Nhóm</th>
		<th>Đề tài</th>
		<th>Ghi chú</th>
		<th>Trạng thái</th>
		<th>Xử lý</th>
	</tr>
	<c:forEach var="r" items="${registrations}">
		<tr>
			<td>${r.group_name}</td>
			<td>${r.topic_title}</td>
			<td>${r.note}</td>
			<td>${r.status}</td>
			<td><c:if test="${r.status=='PENDING'}">
					<form method="post">
						<input type="hidden" name="id" value="${r.id}">
						<textarea name="note" placeholder="Nhận xét"></textarea>
						<button name="status" value="APPROVED" class="success">Duyệt</button>
						<button name="status" value="REJECTED" class="danger">Từ
							chối</button>
					</form>
				</c:if></td>
		</tr>
	</c:forEach>
</table>
<%@ include file="../common/footer.jsp"%>
