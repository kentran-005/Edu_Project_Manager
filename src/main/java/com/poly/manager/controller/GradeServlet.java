package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/grades")
public class GradeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            req.setAttribute("grades",new GradeDao().publishedForStudent(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/student/grades.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        if(!"LECTURER".equals(user.getRole())){resp.sendError(403);return;}
        try{
            long groupId=Long.parseLong(req.getParameter("groupId"));
            if(!new GroupDao().isSupervisor(groupId,user.getId())){resp.sendError(403);return;}
            new GradeDao().save(groupId,Long.parseLong(req.getParameter("studentId")),
                new TopicDao().lecturerIdByUser(user.getId()),Double.parseDouble(req.getParameter("score")),
                req.getParameter("comment"),req.getParameter("status"));
            resp.sendRedirect(req.getContextPath()+"/groups/"+groupId);
        }catch(Exception ex){throw new ServletException(ex);}
    }
}
