package com.smartdoc.service;

import com.smartdoc.entity.enums.OtpPurpose;

public interface OtpService {
    String sendRegistrationOtp(String email);
    String sendPasswordResetOtp(String email);
    void verifyOtp(String email, String otp, OtpPurpose purpose);
    boolean isOtpVerified(String email, OtpPurpose purpose);
    void invalidateOtp(String email, OtpPurpose purpose);
    void validateNietDomain(String email);
}