package com.poly.manager.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;

public final class JsonUtils {
    private static final Gson GSON = new GsonBuilder().serializeNulls().create();
    private JsonUtils() {}

    public static <T> T read(HttpServletRequest request, Class<T> type) throws IOException {
        return GSON.fromJson(request.getReader(), type);
    }

    public static void write(HttpServletResponse response, int status, Object body) throws IOException {
        response.setStatus(status);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(GSON.toJson(body));
    }

    public static void ok(HttpServletResponse response, Object data) throws IOException {
        Map<String,Object> body = new LinkedHashMap<String,Object>();
        body.put("success", true);
        body.put("data", data);
        write(response, HttpServletResponse.SC_OK, body);
    }

    public static void error(HttpServletResponse response, int status, String message) throws IOException {
        Map<String,Object> body = new LinkedHashMap<String,Object>();
        body.put("success", false);
        body.put("message", message);
        write(response, status, body);
    }
}
