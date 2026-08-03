package com.poly.manager.controller;

import com.poly.manager.dao.DashboardDao;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/schedule")
public class ScheduleServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        try {
            DashboardDao dashboardDao = new DashboardDao();
            req.setAttribute("milestones", dashboardDao.studentMilestones(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/student/schedule.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
