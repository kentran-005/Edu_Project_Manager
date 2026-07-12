package com.poly.manager.controller;

import com.poly.manager.model.User;
import com.poly.manager.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns={"/login","/register","/logout"})
public class AuthServlet extends HttpServlet {
    private final AuthService auth=new AuthService();
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        String path=req.getServletPath();
        if("/logout".equals(path)){
            HttpSession session=req.getSession(false); if(session!=null)session.invalidate();
            req.getSession(true).setAttribute("flashMessage", "Đăng xuất thành công. Hẹn gặp lại!");
            resp.sendRedirect(req.getContextPath()+"/login"); return;
        }
        if(req.getSession(false)!=null && req.getSession(false).getAttribute("currentUser")!=null){
            resp.sendRedirect(req.getContextPath()+"/dashboard");return;
        }
        if("/register".equals(path)){
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req,resp);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req,resp);
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        try{
            if ("/register".equals(req.getServletPath())) {
                auth.registerStudent(req.getParameter("username"), req.getParameter("email"),
                    req.getParameter("password"), req.getParameter("confirmPassword"),
                    req.getParameter("fullName"), req.getParameter("phone"),
                    req.getParameter("studentCode"));
                req.setAttribute("message", "Đăng ký thành công. Anh/chị có thể đăng nhập ngay.");
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }
            User user=auth.authenticate(req.getParameter("username"),req.getParameter("password"));
            if(user==null){req.setAttribute("error","Tên đăng nhập hoặc mật khẩu không đúng");doGet(req,resp);return;}
            HttpSession session=req.getSession(true);
            session.setMaxInactiveInterval(30*60);
            session.setAttribute("currentUser",user);
            resp.sendRedirect(req.getContextPath()+"/dashboard");
        }catch(IllegalArgumentException ex){
            req.setAttribute("error", ex.getMessage());
            doGet(req, resp);
        }catch(Exception ex){throw new ServletException(ex);}
    }
}
