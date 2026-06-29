package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/lecturer/registrations")
public class RegistrationServlet extends HttpServlet {
    private final GroupDao groups=new GroupDao();
    private final TopicDao topics=new TopicDao();
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            req.setAttribute("registrations",groups.registrationsForLecturer(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/lecturer/registrations.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            groups.review(Long.parseLong(req.getParameter("id")),topics.lecturerIdByUser(user.getId()),
                req.getParameter("status"),req.getParameter("note"));
            resp.sendRedirect(req.getContextPath()+"/lecturer/registrations");
        }catch(Exception ex){req.setAttribute("error",ex.getMessage());doGet(req,resp);}
    }
}
