<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng nhập hệ thống</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/app.css">
	<style>
	.login-page-wrapper{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    padding:30px;
}

.login-page-card{
    width:420px;
    background:#ffffff;
    border-radius:18px;
    box-shadow:0 15px 40px rgba(0,0,0,.18);
    overflow:hidden;
}

.login-page-header{
    background:#2563eb;
    color:white;
    padding:35px;
    text-align:center;
}

.login-page-header h2{
    margin:0;
    font-size:28px;
    font-weight:700;
}

.login-page-header p{
    margin-top:8px;
    opacity:.9;
    font-size:14px;
}

.login-page-body{
    padding:35px;
}

.login-page-group{
    margin-bottom:22px;
}

.login-page-label{
    display:block;
    margin-bottom:8px;
    font-weight:600;
    color:#444;
}

.login-page-input{
    width:100%;
    height:46px;
    border:1px solid #d6dbe5;
    border-radius:10px;
    padding:0 15px;
    font-size:15px;
    transition:.25s;
}

.login-page-input:focus{
    outline:none;
    border-color:#2563eb;
    box-shadow:0 0 0 4px rgba(37,99,235,.15);
}

.login-page-button{
    width:100%;
    height:48px;
    border:none;
    border-radius:10px;
    background:#2563eb;
    color:white;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    transition:.25s;
}

.login-page-button:hover{
    background:#1d4ed8;
}

.login-page-error{
    background:#fdecec;
    color:#d63031;
    padding:12px 15px;
    border-radius:8px;
    margin-bottom:20px;
    border-left:4px solid #d63031;
}

.login-page-footer{
    text-align:center;
    color:#888;
    font-size:13px;
    margin-top:25px;
}</style>
	
</head>

<body>

<div class="login-page-wrapper">

    <div class="login-page-card">

        <div class="login-page-header">

            <h2>Hệ thống Quản lý Đồ án</h2>

            <p>Student Project Management System</p>

        </div>

        <div class="login-page-body">

            <%
            if(request.getAttribute("error") != null){
            %>

            <div class="login-page-error">
                <%=request.getAttribute("error")%>
            </div>

            <%
            }
            %>

            <form method="post">

                <div class="login-page-group">

                    <label class="login-page-label">
                        Tên đăng nhập
                    </label>

                    <input
                        class="login-page-input"
                        name="username"
                        required>

                </div>

                <div class="login-page-group">

                    <label class="login-page-label">
                        Mật khẩu
                    </label>

                    <input
                        class="login-page-input"
                        type="password"
                        name="password"
                        required>

                </div>

                <button
                    class="login-page-button"
                    type="submit">

                    Đăng nhập

                </button>

            </form>

            <div class="login-page-footer">

                © Student Project Management

            </div>

        </div>

    </div>