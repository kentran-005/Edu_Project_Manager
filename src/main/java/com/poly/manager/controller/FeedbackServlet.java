package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/feedbacks")
public class FeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            long groupId=Long.parseLong(req.getParameter("groupId"));
            if(!new GroupDao().isSupervisor(groupId,user.getId())){resp.sendError(403);return;}
            Long lecturerId=new TopicDao().lecturerIdByUser(user.getId());
            new ReportDao().feedback(groupId,longOrNull(req.getParameter("reportId")),
                longOrNull(req.getParameter("submissionId")),lecturerId,req.getParameter("content"));
            resp.sendRedirect(req.getContextPath()+"/groups/"+groupId);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    private Long longOrNull(String v){return v==null||v.trim().isEmpty()?null:Long.valueOf(v);}
}
