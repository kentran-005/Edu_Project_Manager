package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
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
        long groupId=0;
        try{
            groupId=RequestUtils.longValue(req,"groupId","Thiếu nhóm cần chấm điểm");
            if(!new GroupDao().isSupervisor(groupId,user.getId())){resp.sendError(403);return;}
            Long lecturerId=new TopicDao().lecturerIdByUser(user.getId());
            if(lecturerId==null) throw new IllegalArgumentException("Tài khoản chưa được gắn hồ sơ giảng viên");
            new GradeDao().save(groupId,RequestUtils.longValue(req,"studentId","Vui lòng chọn sinh viên cần chấm"),
                lecturerId,score(req),
                RequestUtils.text(req,"comment"),RequestUtils.text(req,"status"));
            WebUtils.flashMessage(req,"Đã lưu điểm");
            resp.sendRedirect(req.getContextPath()+"/groups/"+groupId);
        }catch(Exception ex){
            WebUtils.flashError(req,ex.getMessage());
            resp.sendRedirect(req.getContextPath()+(groupId>0?"/groups/"+groupId:"/groups"));
        }
    }
    private double score(HttpServletRequest req){
        try{return Double.parseDouble(RequestUtils.text(req,"score"));}
        catch(NumberFormatException ex){throw new IllegalArgumentException("Điểm phải là một số từ 0 đến 10");}
    }
}
