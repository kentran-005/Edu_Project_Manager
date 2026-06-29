package com.poly.manager.util;

import org.junit.Test;

import static org.junit.Assert.*;

public class UtilityTest {
    @Test
    public void passwordCanBeHashedAndVerified() {
        String hash=PasswordUtils.hash("Admin@123");
        assertTrue(PasswordUtils.matches("Admin@123",hash));
        assertFalse(PasswordUtils.matches("wrong",hash));
    }

    @Test
    public void seededAdminPasswordIsCorrect() {
        assertTrue(PasswordUtils.matches("Admin@123",
            "$2a$12$INf873dRCfLMZ6eunnOxTeAaosV.SfewmO9.FUbcGXwGNEIEbXeca"));
    }

    @Test
    public void inviteCodeHasExpectedFormat() {
        assertTrue(InviteCodeUtils.generate().matches("[A-Z2-9]{8}"));
    }
}
