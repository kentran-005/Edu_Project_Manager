package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/feedbacks")
public class FeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        long groupId=0;
        try{
            groupId=RequestUtils.longValue(req,"groupId","Thiếu nhóm cần nhận xét");
            if(!new GroupDao().isSupervisor(groupId,user.getId())){resp.sendError(403);return;}
            Long lecturerId=new TopicDao().lecturerIdByUser(user.getId());
            if(lecturerId==null) throw new IllegalArgumentException("Tài khoản chưa được gắn hồ sơ giảng viên");
            new ReportDao().feedback(groupId,RequestUtils.nullableLong(req,"reportId"),
                RequestUtils.nullableLong(req,"submissionId"),lecturerId,RequestUtils.text(req,"content"));
            WebUtils.flashMessage(req,"Đã gửi nhận xét");
            resp.sendRedirect(req.getContextPath()+"/groups/"+groupId);
        }catch(Exception ex){
            WebUtils.flashError(req,ex.getMessage());
            resp.sendRedirect(req.getContextPath()+(groupId>0?"/groups/"+groupId:"/groups"));
        }
    }
}
