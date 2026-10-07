package com.smartdoc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * SMARTDOC: Intelligent Digital Student Document Management and Verification System.
 * Main Spring Boot Bootstrap Application.
 */
@SpringBootApplication
@EnableScheduling
public class SmartDocApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(SmartDocApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(SmartDocApplication.class, args);
    }
}
