package com.poly.manager.service;

import com.poly.manager.dao.UserDao;
import com.poly.manager.model.User;
import com.poly.manager.util.PasswordUtils;

import java.sql.SQLException;

public class AuthService {
    private final UserDao users = new UserDao();

    public User authenticate(String username,String password) throws SQLException {
        if(username==null || password==null) return null;
        User user=users.findByUsername(username.trim());
        if(user==null || !"ACTIVE".equals(user.getStatus())) return null;
        return PasswordUtils.matches(password,user.getPassword()) ? user : null;
    }

    public long registerStudent(String username, String email, String password,
                                String confirmPassword, String fullName,
                                String phone, String studentCode) throws SQLException {
        username = safe(username);
        email = safe(email);
        fullName = safe(fullName);
        phone = safe(phone);
        studentCode = safe(studentCode).toUpperCase();

        if (username.length() < 4) throw new IllegalArgumentException("Tên đăng nhập phải có ít nhất 4 ký tự");
        if (!email.matches("^[\\w.+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) throw new IllegalArgumentException("Email không hợp lệ");
        if (password == null || password.length() < 6) throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự");
        if (!password.equals(confirmPassword)) throw new IllegalArgumentException("Mật khẩu nhập lại không khớp");
        if (fullName.isEmpty()) throw new IllegalArgumentException("Họ tên là bắt buộc");
        if (studentCode.isEmpty()) throw new IllegalArgumentException("Mã sinh viên là bắt buộc");
        if (users.findByUsername(username) != null) throw new IllegalArgumentException("Tên đăng nhập đã tồn tại");
        if (users.findByEmail(email) != null) throw new IllegalArgumentException("Email đã tồn tại");
        if (users.existsStudentCode(studentCode)) throw new IllegalArgumentException("Mã sinh viên đã tồn tại");

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(PasswordUtils.hash(password));
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setRole("STUDENT");
        return users.create(user, studentCode, null, null, null);
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
