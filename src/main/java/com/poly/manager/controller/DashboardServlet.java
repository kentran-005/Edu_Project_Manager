package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            DashboardDao dashboard=new DashboardDao();
            GroupDao groupDao=new GroupDao();
            if("ADMIN".equals(user.getRole())) {
                req.setAttribute("stats",dashboard.admin());
                req.setAttribute("groupStatus",dashboard.adminGroupStatus());
                req.setAttribute("recentReports",dashboard.adminRecentReports());
                req.setAttribute("activities",dashboard.adminActivities());
            }
            List<Map<String,Object>> groups=groupDao.groupsForUser(user.getId(),user.getRole());
            req.setAttribute("groups",groups);
            req.setAttribute("topics","LECTURER".equals(user.getRole())
                ?new TopicDao().findByLecturer(user.getId()):new TopicDao().findAll(null,"OPEN"));
            if("LECTURER".equals(user.getRole())) {
                req.setAttribute("registrations",new GroupDao().registrationsForLecturer(user.getId()));
                req.setAttribute("lecturerStats",dashboard.lecturer(user.getId()));
                req.setAttribute("reportStatus",dashboard.lecturerReportStatus(user.getId()));
                req.setAttribute("recentReports",dashboard.lecturerRecentReports(user.getId()));
            }
            if("STUDENT".equals(user.getRole())) {
                req.setAttribute("grades",new GradeDao().publishedForStudent(user.getId()));
                req.setAttribute("studentStats",dashboard.student(user.getId()));
                req.setAttribute("reportStatus",dashboard.studentReportStatus(user.getId()));
                req.setAttribute("recentItems",dashboard.studentRecentItems(user.getId()));
                req.setAttribute("milestones",dashboard.studentMilestones(user.getId()));
                if(!groups.isEmpty()) req.setAttribute("members",groupDao.members(((Number)groups.get(0).get("id")).longValue()));
            }
            req.getRequestDispatcher("/WEB-INF/views/"+user.getRole().toLowerCase()+"/dashboard.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
}
