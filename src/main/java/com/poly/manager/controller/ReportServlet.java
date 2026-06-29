package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    private final ReportDao reports=new ReportDao();
    private final GroupDao groups=new GroupDao();
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            long groupId=Long.parseLong(req.getParameter("groupId"));
            if(groups.membership(groupId,user.getId())==null){resp.sendError(403);return;}
            reports.create(groupId,Integer.parseInt(req.getParameter("weekNumber")),req.getParameter("title"),
                req.getParameter("completedWork"),req.getParameter("nextPlan"),req.getParameter("difficulties"));
            resp.sendRedirect(req.getContextPath()+"/groups/"+groupId);
        }catch(Exception ex){throw new ServletException(ex);}
    }
}
