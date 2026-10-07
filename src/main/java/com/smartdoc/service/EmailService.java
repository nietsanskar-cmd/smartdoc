package com.smartdoc.service;

import com.smartdoc.entity.enums.OtpPurpose;

public interface EmailService {
    void sendOtpEmail(String recipientEmail, String otp, OtpPurpose purpose);
}