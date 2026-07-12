package com.poly.manager.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(value="/*", dispatcherTypes=DispatcherType.REQUEST)
public class AuthenticationFilter implements Filter {
    public void doFilter(ServletRequest req,ServletResponse res,FilterChain chain)
            throws IOException,ServletException {
        HttpServletRequest request=(HttpServletRequest)req;
        HttpServletResponse response=(HttpServletResponse)res;
        String path=request.getRequestURI().substring(request.getContextPath().length());
        boolean publicPath=path.equals("/") || path.equals("/login") || path.equals("/register")
            || path.startsWith("/assets/") || path.equals("/favicon.ico");
        HttpSession session=request.getSession(false);
        if(publicPath || (session!=null && session.getAttribute("currentUser")!=null)){
            chain.doFilter(req,res); return;
        }
        response.sendRedirect(request.getContextPath()+"/login");
    }
}
