package com.smartdoc.config;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@Configuration
public class StorageConfig {

    @Value("${smartdoc.storage.location:storage/documents}")
    private String storageLocation;

    @Value("${smartdoc.storage.qrcode-location:storage/qrcodes}")
    private String qrCodeLocation;

    @PostConstruct
    public void init() {
        try {
            Files.createDirectories(Paths.get(storageLocation));
            Files.createDirectories(Paths.get(qrCodeLocation));
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize storage directory", e);
        }
    }
}
