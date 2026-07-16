<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Đăng nhập - Edu Project</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body class="auth-page">
	<div class="auth-shell">
		<section class="auth-hero">
			<div class="logo-mark">EP</div>
			<h1>Quản lý đồ án sinh viên</h1>
			<p>Theo dõi đề tài, nhóm, tiến độ, bài nộp, nhận xét và điểm số
				trong một hệ thống gọn gàng.</p>
			<ul>
				<li>Admin quản lý tài khoản, lớp, học kỳ</li>
				<li>Giảng viên duyệt đề tài, nhận xét, chấm điểm</li>
				<li>Sinh viên tạo nhóm, nộp báo cáo, xem điểm</li>
			</ul>
		</section>
		<section class="auth-card">
			<h2>Đăng nhập hệ thống</h2>
			<p class="muted">Dùng tài khoản được cấp hoặc tài khoản sinh viên
				đã đăng ký.</p>
			<%
			if (request.getAttribute("error") != null) {
			%><div class="error"><%=request.getAttribute("error")%></div>
			<%
			}
			%>
			<%
			if (request.getAttribute("message") != null) {
			%><div
				class="success-message"><%=request.getAttribute("message")%></div>
			<%
			}
			%>
			<form method="post" autocomplete="on">
				<label>Tên đăng nhập</label><input name="username"
					placeholder="Ví dụ: admin" required autofocus> <label>Mật
					khẩu</label><input type="password" name="password"
					placeholder="Nhập mật khẩu" required>
				<button class="btn-primary" type="submit">Đăng nhập</button>
			</form>
			<p class="auth-switch">
				Chưa có tài khoản sinh viên? <a
					href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
			</p>
		</section>
	</div>
</body>
</html>
