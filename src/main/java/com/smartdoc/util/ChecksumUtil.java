package com.smartdoc.util;

import com.smartdoc.exception.StorageException;
import java.io.InputStream;
import java.security.MessageDigest;

public final class ChecksumUtil {

    private ChecksumUtil() {}

    public static String calculateSHA256(InputStream inputStream) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                digest.update(buffer, 0, bytesRead);
            }
            byte[] hashBytes = digest.digest();
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new StorageException("Failed to calculate SHA-256 cryptographic checksum", e);
        }
    }
}
