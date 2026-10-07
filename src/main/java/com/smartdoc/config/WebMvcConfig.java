package com.smartdoc.config;

import com.smartdoc.interceptor.AuthenticationInterceptor;
import com.smartdoc.interceptor.RoleAuthorizationInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private AuthenticationInterceptor authenticationInterceptor;

    @Autowired
    private RoleAuthorizationInterceptor roleAuthorizationInterceptor;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Map static assets
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/", "classpath:/static/");
        
        // Map generated QR codes for display
        registry.addResourceHandler("/storage/qrcodes/**")
                .addResourceLocations("file:storage/qrcodes/");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authenticationInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/static/**", "/storage/qrcodes/**", "/error", "/login", "/register", "/verify/document/**", "/shared/**");

        registry.addInterceptor(roleAuthorizationInterceptor)
                .addPathPatterns("/admin/**", "/faculty/**", "/student/**", "/api/admin/**", "/api/faculty/**", "/api/student/**");
    }
}
