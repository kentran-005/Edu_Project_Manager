package com.poly.manager.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class AppConfig {
    private static final Properties VALUES = new Properties();

    static {
        try (InputStream input = AppConfig.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input == null) throw new IllegalStateException("Không tìm thấy application.properties");
            VALUES.load(input);
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private AppConfig() {}

    public static String get(String key) {
        String envName = key.toUpperCase().replace('.', '_');
        String env = System.getenv(envName);
        return env == null || env.trim().isEmpty() ? VALUES.getProperty(key, "") : env;
    }

    public static int getInt(String key, int fallback) {
        try { return Integer.parseInt(get(key)); }
        catch (Exception ignored) { return fallback; }
    }

    public static long getLong(String key, long fallback) {
        try { return Long.parseLong(get(key)); }
        catch (Exception ignored) { return fallback; }
    }
}
