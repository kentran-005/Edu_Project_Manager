package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.service.PdfService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/pdf/group")
public class PdfServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        try{
            long groupId=Long.parseLong(req.getParameter("groupId"));
            User user=(User)req.getSession().getAttribute("currentUser");
            GroupDao groups=new GroupDao();
            boolean allowed="ADMIN".equals(user.getRole())
                || ("LECTURER".equals(user.getRole())&&groups.isSupervisor(groupId,user.getId()))
                || ("STUDENT".equals(user.getRole())&&groups.membership(groupId,user.getId())!=null);
            if(!allowed){resp.sendError(403);return;}
            ReportDao reports=new ReportDao();
            byte[] pdf=new PdfService().groupProgress(groups.find(groupId),groups.members(groupId),
                reports.findByGroup(groupId),reports.feedbackByGroup(groupId));
            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition","attachment; filename=group-progress-"+groupId+".pdf");
            resp.setContentLength(pdf.length);resp.getOutputStream().write(pdf);
        }catch(Exception ex){throw new ServletException(ex);}
    }
}
