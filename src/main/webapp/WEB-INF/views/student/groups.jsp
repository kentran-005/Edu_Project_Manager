<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%><h1>Quản lý nhóm</h1>
<c:if test="${sessionScope.currentUser.role=='STUDENT'}">
	<div class="grid">
		<div class="card">
			<h3>Tạo nhóm</h3>
			<form method="post">
				<input type="hidden" name="action" value="create"> <label>Tên
					nhóm</label><input name="groupName" required><label>Học kỳ</label><select
					name="semesterId" required>
					<option value="">-- Chọn học kỳ --</option>
					<c:forEach var="s" items="${semesters}">
						<option value="${s.id}">${s.name}</option>
					</c:forEach>
				</select>
				<c:if test="${empty semesters}">
					<p class="hint error-text">Chưa có học kỳ. Vui lòng nhờ Admin tạo học kỳ trước.</p>
				</c:if>
				<c:choose>
					<c:when test="${empty semesters}"><button disabled>Tạo nhóm</button></c:when>
					<c:otherwise><button>Tạo nhóm</button></c:otherwise>
				</c:choose>
			</form>
		</div>
		<div class="card">
			<h3>Tham gia nhóm</h3>
			<form method="post">
				<input type="hidden" name="action" value="join"> <label>Mã
					mời</label><input name="inviteCode" required>
				<button>Tham gia</button>
			</form>
		</div>
	</div>
</c:if>
<div class="card">
	<h3>Danh sách nhóm</h3>
	<table>
		<tr>
			<th>Tên nhóm</th>
			<th>Mã mời</th>
			<th>Đề tài</th>
			<th>Trạng thái</th>
		</tr>
		<c:forEach var="g" items="${groups}">
			<tr>
				<td><a href="${pageContext.request.contextPath}/groups/${g.id}">${g.group_name}</a></td>
				<td>${g.invite_code}</td>
				<td>${g.topic_title}</td>
				<td>${g.status}</td>
			</tr>
		</c:forEach>
	</table>
</div>
<c:if test="${sessionScope.currentUser.role=='STUDENT'}">
	<div class="card">
		<h3>Đăng ký đề tài</h3>
		<form method="post">
			<input type="hidden" name="action" value="register"><label>Nhóm</label><select
				name="groupId" required><option value="">-- Chọn nhóm --</option><c:forEach var="g" items="${groups}">
					<c:if test="${g.status=='FORMING'}">
					<option value="${g.id}">${g.group_name}</option>
					</c:if>
				</c:forEach></select> <label>Đề tài</label><select name="topicId" required>
				<option value="">-- Chọn đề tài --</option><c:forEach
					var="t" items="${topics}">
					<option value="${t.id}">${t.title}</option>
				</c:forEach></select> <label>Ghi chú</label>
			<textarea name="note"></textarea>
			<button>Gửi đăng ký</button>
		</form>
	</div>
</c:if>
<%@ include file="../common/footer.jsp"%>
