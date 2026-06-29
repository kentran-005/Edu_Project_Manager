package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/topics")
public class TopicServlet extends HttpServlet {
    private final TopicDao topics=new TopicDao();
    private final AdminDao admin=new AdminDao();
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            req.setAttribute("topics","LECTURER".equals(user.getRole())
                ?topics.findByLecturer(user.getId()):topics.findAll(null,req.getParameter("status")));
            req.setAttribute("semesters",admin.semesters());
            req.getRequestDispatcher("/WEB-INF/views/"+("LECTURER".equals(user.getRole())?"lecturer":"student")+"/topics.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        if(!"LECTURER".equals(user.getRole())){resp.sendError(403);return;}
        try{
            Long lecturerId=topics.lecturerIdByUser(user.getId());
            topics.create(lecturerId,Long.parseLong(req.getParameter("semesterId")),req.getParameter("title"),
                req.getParameter("description"),req.getParameter("requirements"),req.getParameter("technology"),
                Integer.parseInt(req.getParameter("maxMembers")),req.getParameter("status"));
            resp.sendRedirect(req.getContextPath()+"/topics");
        }catch(Exception ex){req.setAttribute("error",ex.getMessage());doGet(req,resp);}
    }
}
