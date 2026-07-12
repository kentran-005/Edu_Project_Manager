package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            if("ADMIN".equals(user.getRole())) req.setAttribute("stats",new DashboardDao().admin());
            req.setAttribute("groups",new GroupDao().groupsForUser(user.getId(),user.getRole()));
            req.setAttribute("topics","LECTURER".equals(user.getRole())
                ?new TopicDao().findByLecturer(user.getId()):new TopicDao().findAll(null,"OPEN"));
            if("LECTURER".equals(user.getRole()))
                req.setAttribute("registrations",new GroupDao().registrationsForLecturer(user.getId()));
            if("STUDENT".equals(user.getRole()))
                req.setAttribute("grades",new GradeDao().publishedForStudent(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/"+user.getRole().toLowerCase()+"/dashboard.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
}
