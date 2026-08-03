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
    private final GroupDao groups=new GroupDao();
    private final TopicDao topics=new TopicDao();
    private final ReportDao reports=new ReportDao();
    private final com.poly.manager.service.EmailService emailService=new com.poly.manager.service.EmailService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            boolean isLecturer = "LECTURER".equals(user.getRole());
            if (isLecturer) {
                req.setAttribute("groups", groups.groupsForUser(user.getId(), user.getRole()));
                req.setAttribute("feedbacks", reports.feedbacksForLecturer(user.getId()));
                req.setAttribute("stats", reports.getLecturerFeedbackStats(user.getId()));
            }
            req.getRequestDispatcher("/WEB-INF/views/" + (isLecturer ? "lecturer" : "student") + "/feedbacks.jsp").forward(req, resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }

    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        long groupId=0;
        try{
            Long lecturerId=topics.lecturerIdByUser(user.getId());
            if(lecturerId==null) throw new IllegalArgumentException("Tài khoản chưa được gắn hồ sơ giảng viên");
            String action=req.getParameter("action");
            if("delete".equals(action)){
                long feedbackId=RequestUtils.longValue(req,"id","Thiếu nhận xét cần xóa");
                reports.deleteFeedback(feedbackId,lecturerId);
                WebUtils.flashMessage(req,"Đã xóa nhận xét thành công");
                resp.sendRedirect(req.getContextPath()+"/feedbacks");
                return;
            }
            if("edit".equals(action)){
                long feedbackId=RequestUtils.longValue(req,"id","Thiếu nhận xét cần sửa");
                String content=RequestUtils.text(req,"content");
                reports.updateFeedback(feedbackId,lecturerId,content);
                WebUtils.flashMessage(req,"Đã cập nhật nhận xét thành công");
                resp.sendRedirect(req.getContextPath()+"/feedbacks");
                return;
            }
            groupId=RequestUtils.longValue(req,"groupId","Thiếu nhóm cần nhận xét");
            if(!groups.isSupervisor(groupId,user.getId())){resp.sendError(403);return;}
            String content=RequestUtils.text(req,"content");
            reports.feedback(groupId,RequestUtils.nullableLong(req,"reportId"),
                RequestUtils.nullableLong(req,"submissionId"),lecturerId,content);
            emailService.notifyStudentsOnFeedback(groupId,content,user.getFullName());
            WebUtils.flashMessage(req,"Đã gửi nhận xét thành công");
            resp.sendRedirect(req.getContextPath()+(req.getParameter("redirectUrl")!=null?req.getParameter("redirectUrl"):"/feedbacks"));
        }catch(Exception ex){
            WebUtils.flashError(req,ex.getMessage());
            resp.sendRedirect(req.getContextPath()+(groupId>0?"/groups/"+groupId:"/feedbacks"));
        }
    }
}
