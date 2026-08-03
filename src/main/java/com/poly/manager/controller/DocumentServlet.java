package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/documents")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 50, maxRequestSize = 1024 * 1024 * 100)
public class DocumentServlet extends HttpServlet {
    private final GroupDao groups = new GroupDao();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        try {
            DashboardDao dashboardDao = new DashboardDao();
            req.setAttribute("documents", dashboardDao.referenceDocuments());
            if (user != null && ("LECTURER".equals(user.getRole()) || "ADMIN".equals(user.getRole()))) {
                req.setAttribute("topics", new TopicDao().findByLecturer(user.getId()));
            }
            req.getRequestDispatcher("/WEB-INF/views/student/documents.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        try {
            String fileName = req.getParameter("fileName");
            String type = req.getParameter("type");
            String fileUrl = req.getParameter("fileUrl");
            String topicIdStr = req.getParameter("topicId");

            Part filePart = null;
            try { filePart = req.getPart("fileUpload"); } catch (Exception e) {}

            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
                String uploadPath = req.getServletContext().getRealPath("/uploads");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String savedFileName = System.currentTimeMillis() + "_" + submittedFileName;
                filePart.write(uploadPath + java.io.File.separator + savedFileName);
                fileUrl = req.getContextPath() + "/uploads/" + savedFileName;
            }

            if (fileUrl == null || fileUrl.trim().isEmpty()) {
                fileUrl = "#";
            }

            long groupId = 1;
            if (topicIdStr != null && !topicIdStr.trim().isEmpty()) {
                long tId = Long.parseLong(topicIdStr.trim());
                Map<String, Object> gRow = new GroupDao().one("SELECT TOP 1 group_id FROM project_groups WHERE topic_id=?", tId);
                if (gRow != null) {
                    groupId = ((Number) gRow.get("group_id")).longValue();
                }
            } else {
                List<Map<String, Object>> myGroups = groups.groupsForUser(user.getId(), user.getRole());
                if (!myGroups.isEmpty()) groupId = ((Number) myGroups.get(0).get("id")).longValue();
            }

            new ReportDao().submit(groupId, user.getId(), fileName, fileUrl, type);
            WebUtils.flashMessage(req, "Đã đăng tài liệu tham khảo thành công");
            resp.sendRedirect(req.getContextPath() + "/documents");
        } catch (Exception ex) {
            WebUtils.flashError(req, ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/documents");
        }
    }
}
