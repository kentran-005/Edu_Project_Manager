package com.poly.manager.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter(value="/*", dispatcherTypes={DispatcherType.REQUEST, DispatcherType.FORWARD})
public class EncodingFilter implements Filter {
    public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)
            throws IOException,ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String path=((HttpServletRequest)request).getRequestURI();
        if(!path.contains("/assets/")) response.setContentType("text/html;charset=UTF-8");
        chain.doFilter(request,response);
    }
}
