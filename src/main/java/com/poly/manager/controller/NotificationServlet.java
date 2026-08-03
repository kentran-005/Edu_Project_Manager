package com.poly.manager.controller;

import com.poly.manager.dao.DashboardDao;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        try {
            DashboardDao dashboardDao = new DashboardDao();
            req.setAttribute("notifications", dashboardDao.studentNotifications(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/student/notifications.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
