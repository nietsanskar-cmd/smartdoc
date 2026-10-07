package com.smartdoc.rest;

import com.smartdoc.dto.request.*;
import com.smartdoc.dto.response.ApiResponse;
import com.smartdoc.entity.User;
import com.smartdoc.entity.enums.OtpPurpose;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.OtpService;
import com.smartdoc.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthRestController {

    private final UserService userService;
    private final OtpService otpService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<UserSession>> login(@Valid @RequestBody LoginRequestDto dto,
                                                          HttpServletRequest request,
                                                          HttpSession httpSession) {
        UserSession session = userService.authenticate(dto, request.getRemoteAddr(), request.getHeader("User-Agent"));
        httpSession.setAttribute("CURRENT_USER", session);
        return ResponseEntity.ok(ApiResponse.success("Authentication successful", session));
    }

    // REGISTRATION FLOW REST ENDPOINTS

    @PostMapping("/register/request-otp")
    public ResponseEntity<ApiResponse<String>> requestRegistrationOtp(@Valid @RequestBody OtpRequestDto dto) {
        otpService.sendRegistrationOtp(dto.getEmail());
        return ResponseEntity.ok(ApiResponse.success("Verification OTP sent successfully to " + dto.getEmail(), "OTP_SENT"));
    }

    @PostMapping("/register/verify-otp")
    public ResponseEntity<ApiResponse<String>> verifyRegistrationOtp(@Valid @RequestBody OtpVerificationDto dto) {
        otpService.verifyOtp(dto.getEmail(), dto.getOtp(), OtpPurpose.REGISTRATION);
        return ResponseEntity.ok(ApiResponse.success("College email verified successfully.", "OTP_VERIFIED"));
    }

    @PostMapping("/register/create-password")
    public ResponseEntity<ApiResponse<Map<String, String>>> createPassword(@Valid @RequestBody CreatePasswordDto dto,
                                                                          HttpServletRequest request,
                                                                          HttpSession httpSession) {
        User user = userService.registerStudentWithVerifiedEmail(dto);
        try {
            UserSession session = userService.authenticate(
                    LoginRequestDto.builder().username(user.getEmail()).password(dto.getPassword()).build(),
                    request.getRemoteAddr(),
                    request.getHeader("User-Agent")
            );
            httpSession.setAttribute("CURRENT_USER", session);
        } catch (Exception ignored) {
        }
        return ResponseEntity.ok(ApiResponse.success("Account created successfully", Map.of(
                "username", user.getUsername(),
                "email", user.getEmail(),
                "redirectUrl", "/student/dashboard",
                "message", "Your NIET SDMS account has been created."
        )));
    }

    // FORGOT / RESET PASSWORD FLOW REST ENDPOINTS

    @PostMapping("/forgot-password/request-otp")
    public ResponseEntity<ApiResponse<String>> requestForgotPasswordOtp(@Valid @RequestBody OtpRequestDto dto) {
        otpService.sendPasswordResetOtp(dto.getEmail());
        return ResponseEntity.ok(ApiResponse.success("Password reset code sent to " + dto.getEmail(), "RESET_OTP_SENT"));
    }

    @PostMapping("/forgot-password/verify-otp")
    public ResponseEntity<ApiResponse<String>> verifyForgotPasswordOtp(@Valid @RequestBody OtpVerificationDto dto) {
        otpService.verifyOtp(dto.getEmail(), dto.getOtp(), OtpPurpose.PASSWORD_RESET);
        return ResponseEntity.ok(ApiResponse.success("Reset code verified successfully.", "RESET_OTP_VERIFIED"));
    }

    @PostMapping("/forgot-password/reset")
    public ResponseEntity<ApiResponse<String>> resetPassword(@Valid @RequestBody ResetPasswordDto dto) {
        userService.resetPasswordWithVerifiedEmail(dto);
        return ResponseEntity.ok(ApiResponse.success("Password reset successfully. You can now login.", "PASSWORD_RESET_SUCCESS"));
    }
}