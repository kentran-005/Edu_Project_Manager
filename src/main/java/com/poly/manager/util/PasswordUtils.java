package com.poly.manager.util;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtils {
    private PasswordUtils() {}
    public static String hash(String raw) { return BCrypt.hashpw(raw, BCrypt.gensalt(12)); }
    public static boolean matches(String raw, String hash) {
        try { return hash != null && BCrypt.checkpw(raw, hash); }
        catch (IllegalArgumentException ex) { return false; }
    }
}
