package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/groups/*")
public class GroupServlet extends HttpServlet {
    private final GroupDao groups=new GroupDao();
    private final AdminDao admin=new AdminDao();
    private final TopicDao topics=new TopicDao();

    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            String path=req.getPathInfo();
            if(path!=null && path.matches("/\\d+")){
                long id=Long.parseLong(path.substring(1));
                boolean allowed="ADMIN".equals(user.getRole())
                    || ("LECTURER".equals(user.getRole()) && groups.isSupervisor(id,user.getId()))
                    || ("STUDENT".equals(user.getRole()) && groups.membership(id,user.getId())!=null);
                if(!allowed){resp.sendError(403);return;}
                req.setAttribute("group",groups.find(id));req.setAttribute("members",groups.members(id));
                req.setAttribute("reports",new ReportDao().findByGroup(id));
                req.setAttribute("submissions",new ReportDao().submissions(id));
                req.setAttribute("feedbacks",new ReportDao().feedbackByGroup(id));
                req.setAttribute("grades",new GradeDao().byGroup(id));
                req.getRequestDispatcher("/WEB-INF/views/student/group-detail.jsp").forward(req,resp);return;
            }
            req.setAttribute("groups",groups.groupsForUser(user.getId(),user.getRole()));
            req.setAttribute("semesters",admin.semesters());
            req.setAttribute("topics",topics.findAll(null,"OPEN"));
            req.getRequestDispatcher("/WEB-INF/views/student/groups.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }

    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        if(!"STUDENT".equals(user.getRole())){resp.sendError(403);return;}
        try{
            String action=req.getParameter("action");
            Long studentId=groups.studentIdByUser(user.getId());
            if(studentId==null) throw new IllegalArgumentException("Tài khoản chưa được gắn hồ sơ sinh viên");
            if("create".equals(action)) groups.create(studentId,
                RequestUtils.longValue(req,"semesterId","Vui lòng chọn học kỳ trước khi tạo nhóm"),
                RequestUtils.text(req,"groupName"));
            else if("join".equals(action)) groups.join(studentId,RequestUtils.text(req,"inviteCode").toUpperCase());
            else if("register".equals(action)) groups.register(
                RequestUtils.longValue(req,"groupId","Vui lòng chọn nhóm đăng ký đề tài"),
                RequestUtils.longValue(req,"topicId","Vui lòng chọn đề tài cần đăng ký"),
                RequestUtils.text(req,"note"),user.getId());
            else {resp.sendError(400);return;}
            WebUtils.flashMessage(req,"Thao tác nhóm thành công");
            resp.sendRedirect(req.getContextPath()+"/groups");
        }catch(Exception ex){
            req.setAttribute("error",ex.getMessage());
            doGet(req,resp);
        }
    }
}
