package com.poly.manager.util;

import java.security.SecureRandom;

public final class InviteCodeUtils {
    private static final char[] CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789".toCharArray();
    private static final SecureRandom RANDOM = new SecureRandom();
    private InviteCodeUtils() {}
    public static String generate() {
        StringBuilder value = new StringBuilder();
        for (int i=0; i<8; i++) value.append(CHARS[RANDOM.nextInt(CHARS.length)]);
        return value.toString();
    }
}
