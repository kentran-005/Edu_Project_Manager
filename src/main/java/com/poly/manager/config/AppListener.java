package com.poly.manager.config;

import com.poly.manager.util.Database;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {
    public void contextInitialized(ServletContextEvent event) {
        event.getServletContext().setAttribute("appName",AppConfig.get("app.name"));
    }
    public void contextDestroyed(ServletContextEvent event) { Database.close(); }
}
