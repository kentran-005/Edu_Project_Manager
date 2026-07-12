package com.poly.manager.util;

import com.poly.manager.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class WebUtils {
    private WebUtils() {}

    public static User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("currentUser");
    }

    public static void flashError(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute("flashError", clean(message, "Có lỗi xảy ra, vui lòng thử lại"));
    }

    public static void flashMessage(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute("flashMessage", clean(message, "Thao tác thành công"));
    }

    public static String clean(String value, String fallback) {
        if (value == null || value.trim().isEmpty()) return fallback;
        return value.trim();
    }
}

