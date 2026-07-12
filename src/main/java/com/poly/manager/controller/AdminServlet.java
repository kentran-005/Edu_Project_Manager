package com.poly.manager.controller;

import com.poly.manager.dao.*;
import com.poly.manager.model.User;
import com.poly.manager.util.PasswordUtils;
import com.poly.manager.util.RequestUtils;
import com.poly.manager.util.WebUtils;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private final UserDao users=new UserDao();
    private final AdminDao admin=new AdminDao();

    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        String path=path(req);
        try{
            if("/users".equals(path)){
                req.setAttribute("users",users.findAll());
                req.setAttribute("classes",admin.classes());
            }else if("/classes".equals(path)){
                req.setAttribute("classes",admin.classes());
                req.setAttribute("lecturers",admin.lecturers());
            }else if("/semesters".equals(path)) req.setAttribute("semesters",admin.semesters());
            else {resp.sendError(404);return;}
            req.getRequestDispatcher("/WEB-INF/views/admin"+path+".jsp").forward(req,resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }

    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        String path=path(req);
        try{
            if("/users".equals(path)){
                User u=new User();u.setUsername(req.getParameter("username"));u.setEmail(req.getParameter("email"));
                u.setPassword(PasswordUtils.hash(req.getParameter("password")));u.setFullName(req.getParameter("fullName"));
                u.setPhone(req.getParameter("phone"));u.setRole(req.getParameter("role"));
                users.create(u,req.getParameter("code"),longOrNull(req.getParameter("classId")),
                    req.getParameter("department"),req.getParameter("academicRank"));
                WebUtils.flashMessage(req,"Thêm tài khoản thành công");
            }else if("/classes".equals(path)){
                admin.createClass(req.getParameter("code"),req.getParameter("name"),req.getParameter("major"),
                    intOrNull(req.getParameter("intakeYear")),longOrNull(req.getParameter("advisorId")));
                WebUtils.flashMessage(req,"Thêm lớp thành công");
            }else if("/semesters".equals(path)){
                admin.createSemester(req.getParameter("code"),req.getParameter("name"),
                    LocalDate.parse(req.getParameter("startDate")),LocalDate.parse(req.getParameter("endDate")),
                    dateOrNull(req.getParameter("registrationDeadline")),req.getParameter("status"));
                WebUtils.flashMessage(req,"Thêm học kỳ thành công");
            }else if("/user-status".equals(path)){
                users.changeStatus(RequestUtils.longValue(req,"id","Thiếu tài khoản cần cập nhật trạng thái"),req.getParameter("status"));
                path="/users";
                WebUtils.flashMessage(req,"Cập nhật trạng thái tài khoản thành công");
            }else{resp.sendError(404);return;}
            resp.sendRedirect(req.getContextPath()+"/admin"+path);
        }catch(Exception ex){
            req.setAttribute("error",ex.getMessage());
            if("/user-status".equals(path)){
                WebUtils.flashError(req,ex.getMessage());
                resp.sendRedirect(req.getContextPath()+"/admin/users");
            }else doGet(req,resp);
        }
    }
    private String path(HttpServletRequest req){String p=req.getPathInfo();return p==null?"/":p;}
    private Long longOrNull(String v){return v==null||v.trim().isEmpty()?null:Long.valueOf(v);}
    private Integer intOrNull(String v){return v==null||v.trim().isEmpty()?null:Integer.valueOf(v);}
    private LocalDate dateOrNull(String v){return v==null||v.trim().isEmpty()?null:LocalDate.parse(v);}
}
