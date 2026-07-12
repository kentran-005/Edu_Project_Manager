package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
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
        long groupId=0;
        try{
            groupId=RequestUtils.longValue(req,"groupId","Thiếu nhóm cần nộp báo cáo");
            if(groups.membership(groupId,user.getId())==null){resp.sendError(403);return;}
            reports.create(groupId,RequestUtils.intValue(req,"weekNumber",0),RequestUtils.text(req,"title"),
                RequestUtils.text(req,"completedWork"),RequestUtils.text(req,"nextPlan"),RequestUtils.text(req,"difficulties"));
            WebUtils.flashMessage(req,"Đã nộp báo cáo tiến độ");
            resp.sendRedirect(req.getContextPath()+"/groups/"+groupId);
        }catch(Exception ex){
            WebUtils.flashError(req,ex.getMessage());
            resp.sendRedirect(req.getContextPath()+(groupId>0?"/groups/"+groupId:"/groups"));
        }
    }
}
