package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/lecturer/registrations")
public class RegistrationServlet extends HttpServlet {
    private final GroupDao groups=new GroupDao();
    private final TopicDao topics=new TopicDao();
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            req.setAttribute("registrations",groups.registrationsForLecturer(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/lecturer/registrations.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            Long lecturerId=topics.lecturerIdByUser(user.getId());
            if(lecturerId==null) throw new IllegalArgumentException("Tài khoản chưa được gắn hồ sơ giảng viên");
            groups.review(RequestUtils.longValue(req,"id","Thiếu đăng ký cần xử lý"),lecturerId,
                RequestUtils.text(req,"status"),RequestUtils.text(req,"note"));
            WebUtils.flashMessage(req,"Đã xử lý đăng ký đề tài");
            resp.sendRedirect(req.getContextPath()+"/lecturer/registrations");
        }catch(Exception ex){req.setAttribute("error",ex.getMessage());doGet(req,resp);}
    }
}
