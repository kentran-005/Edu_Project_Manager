package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    private final ReportDao reports = new ReportDao();
    private final GroupDao groups = new GroupDao();
    private final com.poly.manager.service.EmailService emailService = new com.poly.manager.service.EmailService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        try {
            List<Map<String, Object>> myGroups = groups.groupsForUser(user.getId(), user.getRole());
            req.setAttribute("groups", myGroups);

            if (!myGroups.isEmpty()) {
                long groupId = ((Number) myGroups.get(0).get("id")).longValue();
                req.setAttribute("reports", reports.findByGroup(groupId));
                req.setAttribute("submissions", reports.submissions(groupId));
            }
            req.getRequestDispatcher("/WEB-INF/views/student/reports.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        long groupId = 0;
        try {
            groupId = RequestUtils.longValue(req, "groupId", "Thiếu nhóm cần nộp báo cáo");
            if (groups.membership(groupId, user.getId()) == null) {
                resp.sendError(403);
                return;
            }
            String reportTitle = RequestUtils.text(req, "title");
            reports.create(groupId, RequestUtils.intValue(req, "weekNumber", 0), reportTitle,
                    RequestUtils.text(req, "completedWork"), RequestUtils.text(req, "nextPlan"), RequestUtils.text(req, "difficulties"));
            emailService.notifyLecturerOnReportSubmission(groupId, reportTitle, user.getFullName());
            WebUtils.flashMessage(req, "Đã nộp báo cáo tiến độ thành công");
            resp.sendRedirect(req.getContextPath() + "/groups/" + groupId);
        } catch (Exception ex) {
            WebUtils.flashError(req, ex.getMessage());
            resp.sendRedirect(req.getContextPath() + (groupId > 0 ? "/groups/" + groupId : "/groups"));
        }
    }
}

