package com.smartdoc.service.impl;

import com.smartdoc.entity.enums.OtpPurpose;
import com.smartdoc.service.EmailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;

@Service
@Slf4j
public class EmailServiceImpl implements EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:sdmsniet@gmail.com}")
    private String senderEmail;

    @Override
    public void sendOtpEmail(String recipientEmail, String otp, OtpPurpose purpose) {
        log.info("Preparing OTP email dispatch for recipient domain: {}", getMaskedEmail(recipientEmail));

        String subject = (purpose == OtpPurpose.PASSWORD_RESET)
                ? "NIET SDMS - Password Reset OTP"
                : "NIET SDMS - Email Verification OTP";

        String purposeText = (purpose == OtpPurpose.PASSWORD_RESET)
                ? "resetting your password for"
                : "registering with";

        String htmlContent = buildHtmlTemplate(otp, purposeText);
        String textContent = buildPlainTextTemplate(otp, purposeText);

        if (mailSender == null) {
            log.warn("[NIET SDMS DEV MODE] JavaMailSender is not initialized. Please set MAIL_PASSWORD in your environment. Generated OTP for {}: {}", recipientEmail, otp);
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());

            helper.setFrom(senderEmail, "NIET SDMS Portal");
            helper.setTo(recipientEmail);
            helper.setSubject(subject);
            helper.setText(textContent, htmlContent);

            mailSender.send(message);
            log.info("OTP verification email successfully dispatched to {}", getMaskedEmail(recipientEmail));
        } catch (MessagingException e) {
            log.error("MessagingException while sending OTP to {}: {}", getMaskedEmail(recipientEmail), e.getMessage());
            log.warn("[NIET SDMS DEV FALLBACK] Generated OTP for {}: {}", recipientEmail, otp);
        } catch (Exception e) {
            log.error("Failed to send email to {}: {}", getMaskedEmail(recipientEmail), e.getMessage());
            log.warn("[NIET SDMS DEV FALLBACK] Generated OTP for {}: {}", recipientEmail, otp);
        }
    }

    private String buildPlainTextTemplate(String otp, String purposeText) {
        return "--------------------------------------\n" +
               "NIET Student Document Management System\n" +
               "Email Verification\n\n" +
               "Hello,\n\n" +
               "Your OTP for " + purposeText + " NIET SDMS is:\n\n" +
               "[" + otp + "]\n\n" +
               "This OTP is valid for 5 minutes.\n" +
               "Please do not share this OTP with anyone.\n\n" +
               "If you did not request this verification, you can safely ignore this email.\n\n" +
               "Regards,\n" +
               "NIET Student Document Management System\n" +
               "Noida Institute of Engineering and Technology\n" +
               "Greater Noida\n" +
               "--------------------------------------";
    }

    private String buildHtmlTemplate(String otp, String purposeText) {
        return "<!DOCTYPE html>" +
               "<html><head><meta charset='UTF-8'>" +
               "<style>" +
               "body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #F8FAFC; margin: 0; padding: 24px; color: #111827; }" +
               ".container { max-width: 560px; margin: 0 auto; background: #FFFFFF; border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }" +
               ".header { background: linear-gradient(135deg, #111827 0%, #1E293B 100%); padding: 28px; text-align: center; border-bottom: 3px solid #D71920; }" +
               ".header h2 { color: #FFFFFF; margin: 0 0 6px 0; font-size: 20px; font-weight: 800; letter-spacing: -0.5px; }" +
               ".header p { color: #94A3B8; margin: 0; font-size: 13px; }" +
               ".content { padding: 32px 28px; text-align: center; }" +
               ".content p { font-size: 15px; line-height: 1.6; color: #334155; margin: 0 0 20px 0; text-align: left; }" +
               ".otp-box { background: #F8FAFC; border: 2px dashed #D71920; border-radius: 12px; padding: 20px; margin: 24px 0; text-align: center; }" +
               ".otp-code { font-size: 36px; font-weight: 800; letter-spacing: 8px; color: #D71920; font-family: Consolas, monospace; }" +
               ".badge { display: inline-block; background: rgba(215, 25, 32, 0.1); color: #D71920; font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 20px; margin-top: 8px; }" +
               ".footer { background: #F1F5F9; padding: 20px 28px; font-size: 12px; color: #64748B; text-align: center; border-top: 1px solid #E2E8F0; line-height: 1.5; }" +
               "</style></head><body>" +
               "<div class='container'>" +
               "<div class='header'>" +
               "<h2>NIET Student Document Management System</h2>" +
               "<p>Noida Institute of Engineering and Technology, Greater Noida (Autonomous)</p>" +
               "</div>" +
               "<div class='content'>" +
               "<p>Hello,</p>" +
               "<p>Your One-Time Password (OTP) for " + purposeText + " NIET SDMS is:</p>" +
               "<div class='otp-box'>" +
               "<div class='otp-code'>" + otp + "</div>" +
               "<div class='badge'>Valid for 5 Minutes</div>" +
               "</div>" +
               "<p style='color: #64748B; font-size: 13px;'>Please do not share this code with anyone. NIET administration will never ask for your verification code.</p>" +
               "<p style='color: #94A3B8; font-size: 12px;'>If you did not initiate this request, please disregard this message.</p>" +
               "</div>" +
               "<div class='footer'>" +
               "<strong>NIET SDMS &bull; Noida Institute of Engineering and Technology</strong><br/>" +
               "Plot No. 19, Knowledge Park II, Institutional Area, Greater Noida, UP - 201306" +
               "</div>" +
               "</div>" +
               "</body></html>";
    }

    private String getMaskedEmail(String email) {
        if (email == null || !email.contains("@")) return "***";
        String[] parts = email.split("@");
        String name = parts[0];
        if (name.length() <= 2) return name.charAt(0) + "***@" + parts[1];
        return name.substring(0, 2) + "***@" + parts[1];
    }
}