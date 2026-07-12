package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
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
            if(lecturerId==null) throw new IllegalArgumentException("Tài khoản chưa được gắn hồ sơ giảng viên");
            String action=RequestUtils.text(req,"action");
            String title=RequestUtils.text(req,"title");
            String description=RequestUtils.text(req,"description");
            String requirements=RequestUtils.text(req,"requirements");
            String technology=RequestUtils.text(req,"technology");
            int maxMembers=RequestUtils.intValue(req,"maxMembers",3);
            String status=RequestUtils.text(req,"status");
            if("update".equals(action)){
                long id=RequestUtils.longValue(req,"id","Thiếu mã đề tài cần cập nhật");
                int updated=topics.update(id,lecturerId,title,description,requirements,technology,maxMembers,status);
                if(updated==0) throw new IllegalArgumentException("Không thể cập nhật đề tài đã được giao hoặc không thuộc giảng viên hiện tại");
                WebUtils.flashMessage(req,"Cập nhật đề tài thành công");
            }else{
                long semesterId=RequestUtils.longValue(req,"semesterId","Vui lòng chọn học kỳ trước khi thêm đề tài");
                topics.create(lecturerId,semesterId,title,description,requirements,technology,maxMembers,status);
                WebUtils.flashMessage(req,"Thêm đề tài thành công");
            }
            resp.sendRedirect(req.getContextPath()+"/topics");
        }catch(Exception ex){req.setAttribute("error",ex.getMessage());doGet(req,resp);}
    }
}
