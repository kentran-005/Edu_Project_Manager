package com.poly.manager.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(value="/*", dispatcherTypes=DispatcherType.REQUEST)
public class FlashFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object error = session.getAttribute("flashError");
            Object message = session.getAttribute("flashMessage");
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("flashError");
            }
            if (message != null) {
                request.setAttribute("message", message);
                session.removeAttribute("flashMessage");
            }
        }
        chain.doFilter(req, res);
    }
}

