package com.smartdoc.service;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Path;

public interface StorageService {
    String storeFile(MultipartFile file, String subDirectory);
    Resource loadAsResource(String relativeFilePath);
    Path load(String relativeFilePath);
    void delete(String relativeFilePath);
}
