package com.smartdoc.service;

public interface QRCodeService {
    String generateVerificationQRCode(String verificationToken);
    String getQRCodeBase64(String verificationToken);
}
