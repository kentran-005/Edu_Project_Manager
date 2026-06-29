package com.poly.manager.filter;

import com.poly.manager.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns={"/lecturer/*","/feedbacks/*"})
public class LecturerFilter implements Filter {
    public void doFilter(ServletRequest req,ServletResponse res,FilterChain chain)
            throws IOException,ServletException {
        HttpServletRequest request=(HttpServletRequest)req;
        User user=(User)request.getSession().getAttribute("currentUser");
        if(user!=null && ("LECTURER".equals(user.getRole()) || "ADMIN".equals(user.getRole()))) chain.doFilter(req,res);
        else ((HttpServletResponse)res).sendError(403);
    }
}
