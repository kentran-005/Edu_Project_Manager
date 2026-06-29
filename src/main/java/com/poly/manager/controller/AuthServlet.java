package com.poly.manager.controller;

import com.poly.manager.model.User;
import com.poly.manager.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns={"/","/login","/logout"})
public class AuthServlet extends HttpServlet {
    private final AuthService auth=new AuthService();
    protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        String path=req.getServletPath();
        if("/logout".equals(path)){
            HttpSession session=req.getSession(false); if(session!=null)session.invalidate();
            resp.sendRedirect(req.getContextPath()+"/login"); return;
        }
        if(req.getSession(false)!=null && req.getSession(false).getAttribute("currentUser")!=null){
            resp.sendRedirect(req.getContextPath()+"/dashboard");return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req,resp);
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        try{
            User user=auth.authenticate(req.getParameter("username"),req.getParameter("password"));
            if(user==null){req.setAttribute("error","Tên đăng nhập hoặc mật khẩu không đúng");doGet(req,resp);return;}
            HttpSession session=req.getSession(true);
            session.setMaxInactiveInterval(30*60);
            session.setAttribute("currentUser",user);
            resp.sendRedirect(req.getContextPath()+"/dashboard");
        }catch(Exception ex){throw new ServletException(ex);}
    }
}
