package com.poly.manager.util;

import jakarta.servlet.http.HttpServletRequest;

public final class RequestUtils {
    private RequestUtils() {}
    public static long longValue(HttpServletRequest req, String name) {
        return longValue(req, name, name + " là bắt buộc");
    }
    public static long longValue(HttpServletRequest req, String name, String message) {
        String value = req.getParameter(name);
        if (value == null || value.trim().isEmpty()) throw new IllegalArgumentException(message);
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException(message);
        }
    }
    public static Long nullableLong(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        return value == null || value.trim().isEmpty() ? null : Long.valueOf(value);
    }
    public static int intValue(HttpServletRequest req, String name, int fallback) {
        try { return Integer.parseInt(req.getParameter(name)); }
        catch (Exception ignored) { return fallback; }
    }
    public static String text(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        return value == null ? "" : value.trim();
    }
}
