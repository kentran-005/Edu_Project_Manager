<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký - Edu Project Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body-new">
    <div class="auth-bg-blob-1"></div>
    <div class="auth-bg-blob-2"></div>

    <!-- Top Navigation Header -->
    <header class="auth-topbar">
        <a href="${pageContext.request.contextPath}/login" class="auth-brand-top">
            <div class="auth-brand-logo">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                    <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/>
                </svg>
            </div>
            <div class="auth-brand-text">
                <span class="auth-brand-title">EDU PROJECT</span>
                <span class="auth-brand-sub">MANAGER</span>
            </div>
        </a>

        <div class="auth-topbar-actions">
            <!-- Mock Notification Bell -->
            <div class="auth-topbar-notification">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/>
                </svg>
                <span class="notification-badge">2</span>
            </div>
            <!-- Redirect to Login Chip -->
            <a href="${pageContext.request.contextPath}/login" class="auth-topbar-profile">
                <div class="profile-avatar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                </div>
                <span>Đăng nhập</span>
            </a>
        </div>
    </header>

    <div class="auth-container-new register-layout">
        <!-- Left Side: Sidebar Feature Presentation -->
        <div class="auth-sidebar-side">
            <div class="auth-sidebar-content">
                <h2>HỆ THỐNG QUẢN LÝ ĐỒ ÁN</h2>
                <p>Nền tảng hỗ trợ sinh viên quản lý, theo dõi tiến độ và hoàn thành đồ án một cách hiệu quả.</p>
                
                <div class="auth-sidebar-illustration">
                    <img src="${pageContext.request.contextPath}/assets/images/login_illustration.png" alt="Edu Project illustration">
                </div>

                <ul class="auth-feature-list">
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                            </svg>
                        </div>
                        <div class="feature-text">
                            <strong>Quản lý đồ án khoa học</strong>
                            <span>Theo dõi tiến độ, báo cáo và tài liệu dễ dàng.</span>
                        </div>
                    </li>
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                <circle cx="9" cy="7" r="4"/>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                            </svg>
                        </div>
                        <div class="feature-text">
                            <strong>Làm việc nhóm hiệu quả</strong>
                            <span>Cộng tác, trao đổi và chia sẻ tài liệu nhanh chóng.</span>
                        </div>
                    </li>
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="18" y1="20" x2="18" y2="10"/>
                                <line x1="12" y1="20" x2="12" y2="4"/>
                                <line x1="6" y1="20" x2="6" y2="14"/>
                            </svg>
                        </div>
                        <div class="feature-text">
                            <strong>Đánh giá minh bạch</strong>
                            <span>Giảng viên đánh giá và nhận xét trực tuyến.</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Right Side: Form Submission Area -->
        <div class="auth-form-side-wide">
            <div class="auth-header-register">
                <h2>Đăng ký tài khoản sinh viên</h2>
                <p>Tạo tài khoản để sử dụng hệ thống quản lý đồ án</p>
            </div>

            <!-- Error Alerts -->
            <%
            if (request.getAttribute("error") != null) {
            %>
            <div class="auth-alert-new auth-alert-error">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <span><%=request.getAttribute("error")%></span>
            </div>
            <%
            }
            %>

            <!-- Registration Form -->
            <form method="post" autocomplete="on">
                <div class="form-grid-new">
                    <!-- Họ và tên -->
                    <div class="form-group-new">
                        <label for="fullName">Họ và tên *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                </svg>
                            </span>
                            <input id="fullName" name="fullName" placeholder="Nhập họ và tên" required autofocus>
                        </div>
                    </div>

                    <!-- Username -->
                    <div class="form-group-new">
                        <label for="username">Username *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                </svg>
                            </span>
                            <input id="username" name="username" placeholder="Nhập username" required>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="form-group-new">
                        <label for="email">Email *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                    <polyline points="22,6 12,13 2,6"/>
                                </svg>
                            </span>
                            <input id="email" type="email" name="email" placeholder="Nhập email" required>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="form-group-new">
                        <label for="password">Mật khẩu *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                            </span>
                            <input id="password" type="password" name="password" minlength="6" placeholder="Nhập mật khẩu" required>
                            <span class="input-icon-toggle" id="password-toggle">
                                <svg id="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                            </span>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group-new">
                        <label for="confirmPassword">Xác nhận mật khẩu *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                            </span>
                            <input id="confirmPassword" type="password" name="confirmPassword" minlength="6" placeholder="Nhập lại mật khẩu" required>
                            <span class="input-icon-toggle" id="confirm-password-toggle">
                                <svg id="confirm-eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                            </span>
                        </div>
                    </div>

                    <!-- Student Code -->
                    <div class="form-group-new">
                        <label for="studentCode">Mã sinh viên *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="4" width="18" height="16" rx="2" ry="2"/>
                                    <line x1="7" y1="8" x2="17" y2="8"/>
                                    <line x1="7" y1="12" x2="17" y2="12"/>
                                    <line x1="7" y1="16" x2="13" y2="16"/>
                                </svg>
                            </span>
                            <input id="studentCode" name="studentCode" placeholder="Nhập mã sinh viên" required>
                        </div>
                    </div>

                    <!-- Class Select Dropdown -->
                    <div class="form-group-new">
                        <label for="classId">Lớp *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                                    <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/>
                                </svg>
                            </span>
                            <select id="classId" name="classId" required class="select-new">
                                <option value="" disabled selected hidden>Chọn lớp</option>
                                <%
                                List<Map<String, Object>> classesList = (List<Map<String, Object>>) request.getAttribute("classes");
                                if (classesList != null) {
                                    for (Map<String, Object> clazz : classesList) {
                                %>
                                    <option value="<%=clazz.get("id")%>"><%=clazz.get("code")%> - <%=clazz.get("name")%></option>
                                <%
                                    }
                                }
                                %>
                            </select>
                            <span class="select-arrow">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"/>
                                </svg>
                            </span>
                        </div>
                    </div>

                    <!-- Phone Number -->
                    <div class="form-group-new">
                        <label for="phone">Số điện thoại *</label>
                        <div class="input-wrapper-new">
                            <span class="input-icon-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                                </svg>
                            </span>
                            <input id="phone" name="phone" placeholder="Nhập số điện thoại" required>
                        </div>
                    </div>
                </div>

                <!-- Warning Alert Banner -->
                <div class="auth-info-banner">
                    <div class="banner-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" y1="16" x2="12" y2="12"/>
                            <line x1="12" y1="8" x2="12.01" y2="8"/>
                        </svg>
                    </div>
                    <span>Thông tin đăng ký sẽ được xác minh bởi phòng đào tạo trước khi kích hoạt tài khoản.</span>
                </div>

                <!-- Footer and Submit -->
                <div class="auth-form-footer-new">
                    <p class="auth-switch-register-new">
                        Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
                    </p>
                    <button type="submit" class="btn-submit-register-new">
                        <span>Đăng ký tài khoản</span>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12"/>
                            <polyline points="12 5 19 12 12 19"/>
                        </svg>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Copyright Footer -->
    <div class="auth-footer-new">
        &copy; 2026 Edu Project Manager. All rights reserved.
    </div>

    <!-- Interactive JS for Password Toggle -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            function setupToggle(inputElId, toggleElId, iconElId) {
                const input = document.getElementById(inputElId);
                const toggle = document.getElementById(toggleElId);
                const icon = document.getElementById(iconElId);
                
                if (input && toggle && icon) {
                    toggle.addEventListener('click', function() {
                        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
                        input.setAttribute('type', type);
                        
                        if (type === 'text') {
                            icon.innerHTML = `
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                                <line x1="1" y1="1" x2="23" y2="23"/>
                            `;
                        } else {
                            icon.innerHTML = `
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            `;
                        }
                    });
                }
            }

            setupToggle('password', 'password-toggle', 'eye-icon');
            setupToggle('confirmPassword', 'confirm-password-toggle', 'confirm-eye-icon');
        });
    </script>
</body>
</html>
