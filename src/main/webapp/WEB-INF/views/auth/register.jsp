<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Đăng ký - Edu Project</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css"></head>
<body class="auth-page"><div class="auth-shell">
<section class="auth-hero">
<div class="logo-mark">EP</div>
<h1>Tạo tài khoản sinh viên</h1>
<p>Tài khoản đăng ký ở đây mặc định là sinh viên. Tài khoản giảng viên và admin sẽ do quản trị viên tạo trong hệ thống.</p>
</section>
<section class="auth-card wide">
<h2>Đăng ký tài khoản</h2>
<p class="muted">Nhập đúng mã sinh viên để sau này hệ thống gắn nhóm, báo cáo và điểm.</p>
<% if(request.getAttribute("error")!=null){ %><div class="error"><%=request.getAttribute("error")%></div><% } %>
<form method="post" autocomplete="on">
<div class="row">
<div><label>Tên đăng nhập</label><input name="username" placeholder="Ít nhất 4 ký tự" required></div>
<div><label>Mã sinh viên</label><input name="studentCode" placeholder="Ví dụ: PS12345" required></div>
</div>
<div class="row">
<div><label>Họ tên</label><input name="fullName" placeholder="Nguyễn Văn A" required></div>
<div><label>Email</label><input type="email" name="email" placeholder="email@domain.com" required></div>
</div>
<label>Số điện thoại</label><input name="phone" placeholder="Có thể để trống">
<div class="row">
<div><label>Mật khẩu</label><input type="password" name="password" minlength="6" required></div>
<div><label>Nhập lại mật khẩu</label><input type="password" name="confirmPassword" minlength="6" required></div>
</div>
<button class="btn-primary" type="submit">Tạo tài khoản sinh viên</button>
</form>
<p class="auth-switch">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a></p>
</section></div></body></html>
