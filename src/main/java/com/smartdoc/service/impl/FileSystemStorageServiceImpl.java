package com.smartdoc.service.impl;

import com.smartdoc.exception.StorageException;
import com.smartdoc.service.StorageService;
import com.smartdoc.util.FileUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
public class FileSystemStorageServiceImpl implements StorageService {

    private final Path rootLocation;

    public FileSystemStorageServiceImpl(@Value("${smartdoc.storage.location:storage/documents}") String storageLocation) {
        this.rootLocation = Paths.get(storageLocation).toAbsolutePath().normalize();
        try {
            Files.createDirectories(this.rootLocation);
        } catch (Exception e) {
            throw new StorageException("Could not initialize storage folder", e);
        }
    }

    @Override
    public String storeFile(MultipartFile file, String subDirectory) {
        if (file.isEmpty()) {
            throw new StorageException("Failed to store empty file.");
        }
        try {
            String sanitizedFilename = FileUtil.sanitizeFilename(file.getOriginalFilename());
            Path targetDir = this.rootLocation.resolve(subDirectory).normalize();
            Files.createDirectories(targetDir);

            Path targetLocation = targetDir.resolve(sanitizedFilename);
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, targetLocation, StandardCopyOption.REPLACE_EXISTING);
            }

            return this.rootLocation.relativize(targetLocation).toString().replace("\\", "/");
        } catch (Exception e) {
            throw new StorageException("Failed to store file: " + file.getOriginalFilename(), e);
        }
    }

    @Override
    public Resource loadAsResource(String relativeFilePath) {
        try {
            Path file = this.rootLocation.resolve(relativeFilePath).normalize();
            Resource resource = new UrlResource(file.toUri());
            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new StorageException("Could not read file: " + relativeFilePath);
            }
        } catch (MalformedURLException e) {
            throw new StorageException("Could not read file: " + relativeFilePath, e);
        }
    }

    @Override
    public Path load(String relativeFilePath) {
        return this.rootLocation.resolve(relativeFilePath);
    }

    @Override
    public void delete(String relativeFilePath) {
        try {
            Path file = this.rootLocation.resolve(relativeFilePath).normalize();
            Files.deleteIfExists(file);
        } catch (Exception e) {
            // ignore
        }
    }
}
