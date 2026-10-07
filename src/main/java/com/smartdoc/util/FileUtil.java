package com.smartdoc.util;

import org.apache.commons.io.FilenameUtils;
import org.springframework.web.multipart.MultipartFile;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

public final class FileUtil {

    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList(
            "application/pdf",
            "image/jpeg",
            "image/jpg",
            "image/png"
    );

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(
            "pdf", "jpg", "jpeg", "png"
    );

    private FileUtil() {}

    public static boolean isValidFileType(MultipartFile file) {
        if (file == null || file.isEmpty()) return false;
        String mime = file.getContentType();
        String ext = FilenameUtils.getExtension(file.getOriginalFilename());
        return (mime != null && ALLOWED_MIME_TYPES.contains(mime.toLowerCase())) ||
               (ext != null && ALLOWED_EXTENSIONS.contains(ext.toLowerCase()));
    }

    public static String sanitizeFilename(String originalFilename) {
        if (originalFilename == null) {
            return "document_" + UUID.randomUUID().toString();
        }
        String cleanName = FilenameUtils.getName(originalFilename);
        String ext = FilenameUtils.getExtension(cleanName);
        String baseName = FilenameUtils.getBaseName(cleanName).replaceAll("[^a-zA-Z0-9_-]", "_");
        return baseName + "_" + System.currentTimeMillis() + (ext.isEmpty() ? "" : "." + ext);
    }

    public static String formatFileSize(long bytes) {
        if (bytes < 1024) return bytes + " B";
        int exp = (int) (Math.log(bytes) / Math.log(1024));
        char pre = "KMGTPE".charAt(exp - 1);
        return String.format("%.2f %sB", bytes / Math.pow(1024, exp), pre);
    }
}
