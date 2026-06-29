package com.poly.manager.dao;

import com.poly.manager.model.User;

import java.sql.*;
import java.util.*;

public class UserDao extends BaseDao {
    public User findByUsername(String username) throws SQLException {
        Map<String,Object> row = one("SELECT TOP 1 * FROM users WHERE username=?", username);
        return row == null ? null : map(row);
    }

    public List<Map<String,Object>> findAll() throws SQLException {
        return query("SELECT id,username,email,full_name,phone,role,status,created_at FROM users ORDER BY id DESC");
    }

    public long create(final User user, final String code, final Long classId,
                       final String department, final String academicRank) throws SQLException {
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

    public int changeStatus(long id, String status) throws SQLException {
        return update("UPDATE users SET status=?,updated_at=SYSDATETIME() WHERE id=?",status,id);
    }

    public Map<String,Object> profile(long userId) throws SQLException {
        return one("SELECT u.id,u.username,u.email,u.full_name,u.phone,u.role,u.status," +
            "s.id student_id,s.student_code,c.code class_code,l.id lecturer_id,l.lecturer_code,l.department " +
            "FROM users u LEFT JOIN students s ON s.user_id=u.id " +
            "LEFT JOIN academic_classes c ON c.id=s.class_id " +
            "LEFT JOIN lecturers l ON l.user_id=u.id WHERE u.id=?", userId);
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
