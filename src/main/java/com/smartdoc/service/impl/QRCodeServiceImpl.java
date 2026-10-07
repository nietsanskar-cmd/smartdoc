package com.smartdoc.service.impl;

import com.smartdoc.service.QRCodeService;
import com.smartdoc.util.QRCodeUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.nio.file.Paths;

@Service
public class QRCodeServiceImpl implements QRCodeService {

    @Value("${smartdoc.app.base-url:http://localhost:8080}")
    private String appBaseUrl;

    @Value("${smartdoc.storage.qrcode-location:storage/qrcodes}")
    private String qrCodeLocation;

    @Override
    public String generateVerificationQRCode(String verificationToken) {
        String verificationUrl = appBaseUrl + "/verify/document/" + verificationToken;
        String outputPath = Paths.get(qrCodeLocation, verificationToken + ".png").toString();
        QRCodeUtil.generateQRCodeImage(verificationUrl, 250, 250, outputPath);
        return outputPath.replace("\\", "/");
    }

    @Override
    public String getQRCodeBase64(String verificationToken) {
        String verificationUrl = appBaseUrl + "/verify/document/" + verificationToken;
        return QRCodeUtil.generateQRCodeBase64(verificationUrl, 250, 250);
    }
}
