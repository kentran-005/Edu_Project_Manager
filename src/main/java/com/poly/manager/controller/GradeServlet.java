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

@WebServlet("/grades")
public class GradeServlet extends HttpServlet {
    private final com.poly.manager.service.EmailService emailService=new com.poly.manager.service.EmailService();
    private final GroupDao groups=new GroupDao();
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        try{
            String action = req.getParameter("action");
            if ("getMembers".equals(action)) {
                long groupId = RequestUtils.longValue(req, "groupId", "Thiếu id nhóm");
                List<Map<String, Object>> members = groups.members(groupId);
                resp.setContentType("application/json;charset=UTF-8");
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < members.size(); i++) {
                    Map<String, Object> m = members.get(i);
                    json.append("{")
                        .append("\"student_id\":").append(m.get("student_id")).append(",")
                        .append("\"student_code\":\"").append(m.get("student_code") != null ? m.get("student_code") : "").append("\",")
                        .append("\"full_name\":\"").append(m.get("full_name") != null ? m.get("full_name") : "").append("\",")
                        .append("\"role\":\"").append(m.get("role") != null ? m.get("role") : "").append("\"")
                        .append("}");
                    if (i < members.size() - 1) json.append(",");
                }
                json.append("]");
                resp.getWriter().write(json.toString());
                return;
            }
            boolean isLecturer = "LECTURER".equals(user.getRole());
            if (isLecturer) {
                req.setAttribute("groups", groups.groupsForUser(user.getId(), user.getRole()));
                req.setAttribute("grades", new GradeDao().gradesForLecturer(user.getId()));
                req.setAttribute("stats", new GradeDao().getLecturerGradeStats(user.getId()));
            } else {
                req.setAttribute("grades",new GradeDao().publishedForStudent(user.getId()));
            }
            req.getRequestDispatcher("/WEB-INF/views/" + (isLecturer ? "lecturer" : "student") + "/grades.jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        User user=(User)req.getSession().getAttribute("currentUser");
        if(!"LECTURER".equals(user.getRole())){resp.sendError(403);return;}
        long groupId=0;
        try{
            groupId=RequestUtils.longValue(req,"groupId","Thiếu nhóm cần chấm điểm");
            if(!groups.isSupervisor(groupId,user.getId())){resp.sendError(403);return;}
            Long lecturerId=new TopicDao().lecturerIdByUser(user.getId());
            if(lecturerId==null) throw new IllegalArgumentException("Tài khoản chưa được gắn hồ sơ giảng viên");
            long studentId=RequestUtils.longValue(req,"studentId","Vui lòng chọn sinh viên cần chấm");
            double s=score(req);
            String comment=RequestUtils.text(req,"comment");
            String status=RequestUtils.text(req,"status");
            new GradeDao().save(groupId,studentId,lecturerId,s,comment,status);
            emailService.notifyStudentOnGradeUpdate(studentId,s,comment,status);
            WebUtils.flashMessage(req,"Đã lưu điểm thành công");
            resp.sendRedirect(req.getContextPath()+(req.getParameter("redirectUrl")!=null?req.getParameter("redirectUrl"):"/groups/"+groupId));
        }catch(Exception ex){
            WebUtils.flashError(req,ex.getMessage());
            resp.sendRedirect(req.getContextPath()+(groupId>0?"/groups/"+groupId:"/grades"));
        }
    }
    private double score(HttpServletRequest req){
        try{return Double.parseDouble(RequestUtils.text(req,"score"));}
        catch(NumberFormatException ex){throw new IllegalArgumentException("Điểm phải là một số từ 0 đến 10");}
    }
}
