package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
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
        try{
            String action=req.getParameter("action");
            Long studentId=groups.studentIdByUser(user.getId());
            if("create".equals(action)) groups.create(studentId,Long.parseLong(req.getParameter("semesterId")),req.getParameter("groupName"));
            else if("join".equals(action)) groups.join(studentId,req.getParameter("inviteCode").trim().toUpperCase());
            else if("register".equals(action)) groups.register(Long.parseLong(req.getParameter("groupId")),
                Long.parseLong(req.getParameter("topicId")),req.getParameter("note"),user.getId());
            else {resp.sendError(400);return;}
            resp.sendRedirect(req.getContextPath()+"/groups");
        }catch(Exception ex){req.setAttribute("error",ex.getMessage());doGet(req,resp);}
    }
}
