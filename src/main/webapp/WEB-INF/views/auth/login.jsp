<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng nhập</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
	<div class="container" style="max-width: 440px; padding-top: 100px">
		<div class="card">
			<h2>Đăng nhập hệ thống</h2>
			<%
			if (request.getAttribute("error") != null) {
			%><div class="error"><%=request.getAttribute("error")%></div>
			<%
			}
			%>
			<form method="post">
				<label>Tên đăng nhập</label><input name="username" required>
				<label>Mật khẩu</label><input type="password" name="password"
					required>
				<button type="submit">Đăng nhập</button>
			</form>
		</div>
	</div>
</body>
</html>
