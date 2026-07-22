<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="vi">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Đăng nhập - Edu Project Manager</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
	</head>

	<body class="auth-body-new">
		<div class="auth-bg-blob-1"></div>
		<div class="auth-bg-blob-2"></div>
		<!-- Brand logo at top-left corner -->
		<a href="#" class="auth-brand">
			<div class="auth-brand-logo">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round">
					<path d="M22 10v6M2 10l10-5 10 5-10 5z" />
					<path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5" />
				</svg>
			</div>
			<div class="auth-brand-text">
				<span class="auth-brand-title">EDU PROJECT</span>
				<span class="auth-brand-sub">MANAGER</span>
			</div>
		</a>

		<div class="auth-container-new">
			<!-- Left Side: Standalone Login Card -->
			<div class="auth-card-new">
				<!-- Header -->
				<div class="auth-header">
					<h2>Đăng nhập</h2>
					<p>Chào mừng bạn quay trở lại hệ thống quản lý đồ án</p>
				</div>

				<!-- Alerts -->
				<% if (request.getAttribute("error") !=null) { %>
					<div class="auth-alert-new auth-alert-error">
						<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18"
							height="18" stroke-linecap="round" stroke-linejoin="round">
							<circle cx="12" cy="12" r="10"></circle>
							<line x1="12" y1="8" x2="12" y2="12"></line>
							<line x1="12" y1="16" x2="12.01" y2="16"></line>
						</svg>
						<span>
							<%=request.getAttribute("error")%>
						</span>
					</div>
					<% } %>
						<% if (request.getAttribute("message") !=null) { %>
							<div class="auth-alert-new auth-alert-success">
								<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18"
									height="18" stroke-linecap="round" stroke-linejoin="round">
									<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
									<polyline points="22 4 12 14.01 9 11.01"></polyline>
								</svg>
								<span>
									<%=request.getAttribute("message")%>
								</span>
							</div>
							<% } %>

								<!-- Form -->
								<form method="post" autocomplete="on">
									<!-- Username / Email -->
									<div class="form-group-new">
										<label for="username">Email hoặc tên đăng nhập</label>
										<div class="input-wrapper-new">
											<span class="input-icon-left">
												<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
													stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
													<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
													<circle cx="12" cy="7" r="4" />
												</svg>
											</span>
											<input id="username" name="username"
												placeholder="Nhập email hoặc tên đăng nhập" required autofocus>
										</div>
									</div>

									<!-- Password -->
									<div class="form-group-new">
										<label for="password">Mật khẩu</label>
										<div class="input-wrapper-new">
											<span class="input-icon-left">
												<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
													stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
													<rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
													<path d="M7 11V7a5 5 0 0 1 10 0v4" />
												</svg>
											</span>
											<input id="password" type="password" name="password"
												placeholder="Nhập mật khẩu" required>
											<span class="input-icon-toggle" id="password-toggle">
												<svg id="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
													stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
													<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
													<circle cx="12" cy="12" r="3" />
												</svg>
											</span>
										</div>
									</div>

									<!-- Options -->
									<div class="form-options-new">
										<label class="remember-checkbox">
											<input type="checkbox" name="remember">
											<span>Ghi nhớ đăng nhập</span>
										</label>
										<a href="#" class="forgot-pw-link">Quên mật khẩu?</a>
									</div>

									<!-- Submit Button -->
									<button type="submit" class="btn-submit-new">
										<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
											stroke-linecap="round" stroke-linejoin="round">
											<path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
											<polyline points="10 17 15 12 10 7" />
											<line x1="15" y1="12" x2="3" y2="12" />
										</svg>
										<span>Đăng nhập</span>
									</button>
								</form>

								<div class="auth-divider">hoặc</div>

								<!-- Google Login Placeholder -->
								<button type="button" class="btn-google-new"
									onclick="alert('Đang kết nối API đăng nhập bằng Google...')">
									<svg viewBox="0 0 24 24">
										<path fill="#4285F4"
											d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
										<path fill="#34A853"
											d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
										<path fill="#FBBC05"
											d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z" />
										<path fill="#EA4335"
											d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z" />
									</svg>
									<span>Đăng nhập với Google</span>
								</button>

								<!-- Switch to Register -->
								<p class="auth-switch-new">
									Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký
										ngay</a>
								</p>
			</div>

			<!-- Right Side: Vector Illustration (Floating) -->
			<div class="auth-illustration-side">
				<div class="auth-illustration-wrapper">
					<img class="auth-illustration-img"
						src="${pageContext.request.contextPath}/assets/images/login_illustration.png"
						alt="Edu Project Illustration">
				</div>
				<!-- Decorative dots matrix matching mockup -->
				<div class="auth-dot-pattern"></div>
			</div>
		</div>

		<!-- Copyright -->
		<div class="auth-footer-new">
			&copy; 2026 Edu Project Manager. All rights reserved.
		</div>

		<!-- Interactive JS for Password Toggle -->
		<script>
			document.addEventListener("DOMContentLoaded", function () {
				const passwordInput = document.getElementById('password');
				const passwordToggle = document.getElementById('password-toggle');
				const eyeIcon = document.getElementById('eye-icon');

				if (passwordToggle && passwordInput && eyeIcon) {
					passwordToggle.addEventListener('click', function () {
						const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
						passwordInput.setAttribute('type', type);

						if (type === 'text') {
							// Eye-off icon
							eyeIcon.innerHTML = `
                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                            <line x1="1" y1="1" x2="23" y2="23"/>
                        `;
						} else {
							// Eye icon
							eyeIcon.innerHTML = `
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        `;
						}
					});
				}
			});
		</script>
	</body>

	</html>