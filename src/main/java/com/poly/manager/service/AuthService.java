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
}
