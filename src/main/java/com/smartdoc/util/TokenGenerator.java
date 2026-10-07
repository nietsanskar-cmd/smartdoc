package com.smartdoc.util;

import java.security.SecureRandom;

public final class TokenGenerator {

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final SecureRandom RANDOM = new SecureRandom();

    private TokenGenerator() {}

    public static String generateVerificationToken(String prefix) {
        StringBuilder sb = new StringBuilder("VT-");
        if (prefix != null && !prefix.trim().isEmpty()) {
            sb.append(prefix.trim().toUpperCase()).append("-");
        }
        for (int i = 0; i < 6; i++) {
            sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }

    public static String generateShareToken() {
        StringBuilder sb = new StringBuilder("SH-");
        for (int i = 0; i < 16; i++) {
            sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }

    public static String generateRequestNo() {
        StringBuilder sb = new StringBuilder("REQ-2026-");
        for (int i = 0; i < 5; i++) {
            sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }

    public static String generateDocumentCode(String deptCode) {
        StringBuilder sb = new StringBuilder("DOC-2026-");
        if (deptCode != null) {
            sb.append(deptCode.toUpperCase()).append("-");
        }
        for (int i = 0; i < 4; i++) {
            sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }
}
