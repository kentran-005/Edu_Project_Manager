<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header & Action Controls -->
<div class="page-header-row" style="margin-bottom: 20px;">
	<div class="page-title-box">
		<h1>Thông báo hệ thống</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Thông báo</p>
	</div>
	<div class="page-header-actions">
		<button type="button" class="btn-filter" onclick="alert('Đã đánh dấu tất cả thông báo là Đã đọc');">Đánh dấu tất cả đã đọc</button>
	</div>
</div>

<!-- Notification Feed List -->
<div style="display: flex; flex-direction: column; gap: 14px; max-width: 900px;">
	<c:choose>
		<c:when test="${empty notifications}">
			<div class="admin-panel" style="border-radius: 16px; padding: 40px; text-align: center;">
				<div style="font-size: 38px; margin-bottom: 8px;">🔔</div>
				<strong style="font-size: 15px; color: #0f172a; display: block; margin-bottom: 4px;">Bạn không có thông báo mới nào.</strong>
				<span style="font-size: 13px; color: #64748b;">Mọi thông báo về phê duyệt nhóm, nhận xét từ Giảng viên và công bố điểm sẽ xuất hiện tại đây.</span>
			</div>
		</c:when>
		<c:otherwise>
			<c:forEach var="notif" items="${notifications}">
				<div class="admin-panel" style="border-radius: 16px; padding: 18px; border-left: 4px solid ${notif.n_type == 'SUCCESS' ? '#2563eb' : (notif.n_type == 'GRADE' ? '#9333ea' : '#16a34a')}; background: #f8fafc;">
					<div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6px;">
						<div style="display: flex; align-items: center; gap: 10px;">
							<span style="width: 32px; height: 32px; border-radius: 50%; background: #dbeafe; color: #1d4ed8; display: grid; place-items: center; font-size: 14px; font-weight: 900;">
								${notif.n_type == 'SUCCESS' ? '☑' : (notif.n_type == 'GRADE' ? '🎓' : '💬')}
							</span>
							<strong style="font-size: 15px; color: #0f172a;">${notif.n_title}</strong>
						</div>
						<small style="color: #64748b; font-weight: 700;">${notif.n_date}</small>
					</div>
					<p style="margin: 4px 0 10px 42px; font-size: 13.5px; color: #334155; line-height: 1.5;">
						${notif.n_content}
					</p>
					<c:if test="${not empty notif.n_link}">
						<div style="margin-left: 42px;">
							<a href="${pageContext.request.contextPath}${notif.n_link}" style="font-size: 12.5px; font-weight: 800; color: #1d4ed8; text-decoration: underline;">Xem chi tiết →</a>
						</div>
					</c:if>
				</div>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</div>

<%@ include file="../common/footer.jsp" %>
