package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.service.CloudinaryService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/submissions")
@MultipartConfig(maxFileSize=20971520,maxRequestSize=22020096)
public class SubmissionServlet extends HttpServlet {
    private final ReportDao reports=new ReportDao();
    private final GroupDao groups=new GroupDao();
    private final CloudinaryService cloudinary=new CloudinaryService();
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            long groupId=Long.parseLong(req.getParameter("groupId"));
            Map<String,Object> member=groups.membership(groupId,user.getId());
            if(member==null){resp.sendError(403);return;}
            CloudinaryService.UploadResult upload=cloudinary.upload(req.getPart("file"),groupId);
            reports.saveSubmission(groupId,longOrNull(req.getParameter("reportId")),req.getParameter("type"),
                upload.fileName,upload.url,upload.publicId,upload.resourceType,upload.bytes,
                ((Number)member.get("student_id")).longValue());
            resp.sendRedirect(req.getContextPath()+"/groups/"+groupId);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    protected void doDelete(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        try{
            User user=(User)req.getSession().getAttribute("currentUser");
            long id=Long.parseLong(req.getParameter("id"));
            Map<String,Object> file=reports.submission(id);
            if(file==null){resp.sendError(404);return;}
            Map<String,Object> member=groups.membership(((Number)file.get("group_id")).longValue(),user.getId());
            if(member==null || (!"LEADER".equals(member.get("role"))
                    && ((Number)file.get("submitted_by_id")).longValue()!=((Number)member.get("student_id")).longValue())){
                resp.sendError(403);return;
            }
            cloudinary.delete((String)file.get("public_id"),(String)file.get("resource_type"));
            reports.deleteSubmission(id);resp.setStatus(204);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    private Long longOrNull(String v){return v==null||v.trim().isEmpty()?null:Long.valueOf(v);}
}
