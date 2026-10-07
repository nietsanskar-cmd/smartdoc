package com.smartdoc.service;

import com.smartdoc.entity.enums.OtpPurpose;

public interface OtpService {
    void sendRegistrationOtp(String email);
    void sendPasswordResetOtp(String email);
    void verifyOtp(String email, String otp, OtpPurpose purpose);
    boolean isOtpVerified(String email, OtpPurpose purpose);
    void invalidateOtp(String email, OtpPurpose purpose);
    void validateNietDomain(String email);
}