package com.poly.manager.dao;

import com.poly.manager.model.User;

import java.sql.*;
import java.util.*;

public class UserDao extends BaseDao {
    public User findByUsername(String username) throws SQLException {
        Map<String,Object> row = one("SELECT TOP 1 user_id AS id, username, email, password, full_name, phone, role, status, avatar_url, created_at, updated_at FROM users WHERE username=?", username);
        return row == null ? null : map(row);
    }

    public User findByEmail(String email) throws SQLException {
        Map<String,Object> row = one("SELECT TOP 1 user_id AS id, username, email, password, full_name, phone, role, status, avatar_url, created_at, updated_at FROM users WHERE email=?", email);
        return row == null ? null : map(row);
    }

    public boolean existsStudentCode(String studentCode) throws SQLException {
        Map<String,Object> row = one("SELECT TOP 1 student_id FROM students WHERE student_code=?", studentCode);
        return row != null;
    }

    public List<Map<String,Object>> findAll() throws SQLException {
        return query("SELECT u.user_id AS id,u.username,u.email,u.full_name,u.phone,u.role,u.status,u.created_at," +
            "s.student_code,c.code class_code,l.lecturer_code,l.department,l.academic_rank " +
            "FROM users u LEFT JOIN students s ON s.user_id=u.user_id " +
            "LEFT JOIN academic_classes c ON c.class_id=s.class_id " +
            "LEFT JOIN lecturers l ON l.user_id=u.user_id ORDER BY u.user_id DESC");
    }

    public long create(final User user, final String code, final Long classId,
                       final String department, final String academicRank) throws SQLException {
        validateCreate(user, code);
        final long[] id = new long[1];
        transaction(new TransactionWork() {
            public void execute(Connection connection) throws Exception {
                String userSql = "INSERT INTO users(username,email,password,full_name,phone,role,status) VALUES(?,?,?,?,?,?,'ACTIVE')";
                try (PreparedStatement ps = connection.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                    bind(ps,user.getUsername(),user.getEmail(),user.getPassword(),user.getFullName(),user.getPhone(),user.getRole());
                    ps.executeUpdate();
                    try (ResultSet keys=ps.getGeneratedKeys()) { keys.next(); id[0]=keys.getLong(1); }
                }
                if ("STUDENT".equals(user.getRole())) {
                    try (PreparedStatement ps=connection.prepareStatement(
                            "INSERT INTO students(student_code,user_id,class_id) VALUES(?,?,?)")) {
                        bind(ps,code,id[0],classId); ps.executeUpdate();
                    }
                } else if ("LECTURER".equals(user.getRole())) {
                    try (PreparedStatement ps=connection.prepareStatement(
                            "INSERT INTO lecturers(lecturer_code,user_id,department,academic_rank) VALUES(?,?,?,?)")) {
                        bind(ps,code,id[0],department,academicRank); ps.executeUpdate();
                    }
                }
            }
        });
        return id[0];
    }

    private void validateCreate(User user, String code) throws SQLException {
        if (user == null) throw new SQLException("Thiếu thông tin tài khoản");
        if (blank(user.getUsername())) throw new SQLException("Username là bắt buộc");
        if (blank(user.getEmail())) throw new SQLException("Email là bắt buộc");
        if (blank(user.getPassword())) throw new SQLException("Mật khẩu là bắt buộc");
        if (blank(user.getFullName())) throw new SQLException("Họ tên là bắt buộc");
        if (!"ADMIN".equals(user.getRole()) && !"LECTURER".equals(user.getRole()) && !"STUDENT".equals(user.getRole()))
            throw new SQLException("Vai trò không hợp lệ");
        if (findByUsername(user.getUsername().trim()) != null) throw new SQLException("Username đã tồn tại");
        if (findByEmail(user.getEmail().trim()) != null) throw new SQLException("Email đã tồn tại");
        if (("STUDENT".equals(user.getRole()) || "LECTURER".equals(user.getRole())) && blank(code))
            throw new SQLException("Mã sinh viên/giảng viên là bắt buộc");
        if ("STUDENT".equals(user.getRole()) && existsStudentCode(code.trim()))
            throw new SQLException("Mã sinh viên đã tồn tại");
    }

    private boolean blank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public int changeStatus(long id, String status) throws SQLException {
        if (!"ACTIVE".equals(status) && !"INACTIVE".equals(status) && !"LOCKED".equals(status))
            throw new SQLException("Trạng thái tài khoản không hợp lệ");
        return update("UPDATE users SET status=?,updated_at=SYSDATETIME() WHERE user_id=?",status,id);
    }

    public Map<String,Object> profile(long userId) throws SQLException {
        return one("SELECT u.user_id AS id,u.username,u.email,u.full_name,u.phone,u.role,u.status," +
            "s.student_id,s.student_code,c.code class_code,l.lecturer_id,l.lecturer_code,l.department " +
            "FROM users u LEFT JOIN students s ON s.user_id=u.user_id " +
            "LEFT JOIN academic_classes c ON c.class_id=s.class_id " +
            "LEFT JOIN lecturers l ON l.user_id=u.user_id WHERE u.user_id=?", userId);
    }

    private User map(Map<String,Object> row) {
        User u=new User();
        u.setId(((Number)row.get("id")).longValue());
        u.setUsername((String)row.get("username"));
        u.setEmail((String)row.get("email"));
        u.setPassword((String)row.get("password"));
        u.setFullName((String)row.get("full_name"));
        u.setPhone((String)row.get("phone"));
        u.setRole((String)row.get("role"));
        u.setStatus((String)row.get("status"));
        return u;
    }
}
