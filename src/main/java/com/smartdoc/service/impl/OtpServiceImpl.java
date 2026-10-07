package com.smartdoc.service.impl;

import com.smartdoc.entity.OtpVerification;
import com.smartdoc.entity.enums.OtpPurpose;
import com.smartdoc.repository.OtpVerificationRepository;
import com.smartdoc.repository.UserRepository;
import com.smartdoc.security.PasswordEncoderUtil;
import com.smartdoc.service.EmailService;
import com.smartdoc.service.OtpService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class OtpServiceImpl implements OtpService {

    public static final String NIET_DOMAIN = "@niet.co.in";
    private static final int OTP_EXPIRY_MINUTES = 5;
    private static final int MAX_ATTEMPTS = 5;
    private static final int RESEND_COOLDOWN_SECONDS = 45;
    private static final int MAX_HOURLY_REQUESTS = 5;

    private final OtpVerificationRepository otpRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final PasswordEncoderUtil passwordEncoder;
    private final SecureRandom secureRandom = new SecureRandom();

    @Override
    public void validateNietDomain(String email) {
        if (email == null || email.trim().isEmpty() || !email.trim().toLowerCase().endsWith(NIET_DOMAIN)) {
            throw new IllegalArgumentException("Please use your official NIET college email ID ending with @niet.co.in.");
        }
    }

    @Override
    @Transactional
    public void sendRegistrationOtp(String rawEmail) {
        String email = normalizeEmail(rawEmail);
        validateNietDomain(email);

        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("This college ID is already registered. Please login instead.");
        }

        checkCooldownAndRateLimits(email, OtpPurpose.REGISTRATION);

        String otp = generateSecure6DigitOtp();
        log.debug("[SDMS-OTP] Generated OTP for {}: {}", email, otp);
        String otpHash = passwordEncoder.encode(otp);

        OtpVerification record = OtpVerification.builder()
                .email(email)
                .otpHash(otpHash)
                .purpose(OtpPurpose.REGISTRATION)
                .expiresAt(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES))
                .verified(false)
                .attemptCount(0)
                .build();

        otpRepository.save(record);
        emailService.sendOtpEmail(email, otp, OtpPurpose.REGISTRATION);
    }

    @Override
    @Transactional
    public void sendPasswordResetOtp(String rawEmail) {
        String email = normalizeEmail(rawEmail);
        validateNietDomain(email);

        if (!userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("No registered account found with this NIET college ID.");
        }

        checkCooldownAndRateLimits(email, OtpPurpose.PASSWORD_RESET);

        String otp = generateSecure6DigitOtp();
        String otpHash = passwordEncoder.encode(otp);

        OtpVerification record = OtpVerification.builder()
                .email(email)
                .otpHash(otpHash)
                .purpose(OtpPurpose.PASSWORD_RESET)
                .expiresAt(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES))
                .verified(false)
                .attemptCount(0)
                .build();

        otpRepository.save(record);
        emailService.sendOtpEmail(email, otp, OtpPurpose.PASSWORD_RESET);
    }

    @Override
    @Transactional
    public void verifyOtp(String rawEmail, String otp, OtpPurpose purpose) {
        String email = normalizeEmail(rawEmail);
        validateNietDomain(email);

        if (otp == null || !otp.trim().matches("^\\d{6}$")) {
            throw new IllegalArgumentException("Invalid verification code. Please enter a 6-digit code.");
        }

        OtpVerification record = otpRepository.findTopByEmailAndPurposeOrderByIdDesc(email, purpose)
                .orElseThrow(() -> new IllegalArgumentException("No verification code was requested for this email."));

        if (Boolean.TRUE.equals(record.getVerified())) {
            throw new IllegalArgumentException("This verification code has already been used. Please request a new OTP.");
        }

        if (record.isExpired()) {
            throw new IllegalArgumentException("This verification code has expired. Please request a new OTP.");
        }

        if (record.getAttemptCount() != null && record.getAttemptCount() >= MAX_ATTEMPTS) {
            throw new IllegalArgumentException("Too many incorrect attempts. Please request a new OTP.");
        }

        if (!passwordEncoder.matches(otp.trim(), record.getOtpHash())) {
            record.setAttemptCount(record.getAttemptCount() == null ? 1 : record.getAttemptCount() + 1);
            otpRepository.save(record);
            int remaining = MAX_ATTEMPTS - record.getAttemptCount();
            if (remaining <= 0) {
                throw new IllegalArgumentException("Too many incorrect attempts. Please request a new OTP.");
            } else {
                throw new IllegalArgumentException("Invalid verification code. Please try again. (" + remaining + " attempts remaining)");
            }
        }

        record.setVerified(true);
        otpRepository.save(record);
    }

    @Override
    public boolean isOtpVerified(String rawEmail, OtpPurpose purpose) {
        String email = normalizeEmail(rawEmail);
        return otpRepository.findTopByEmailAndPurposeAndVerifiedTrueOrderByIdDesc(email, purpose)
                .map(record -> record.getCreatedAt() != null && record.getCreatedAt().isAfter(LocalDateTime.now().minusMinutes(15)))
                .orElse(false);
    }

    @Override
    @Transactional
    public void invalidateOtp(String rawEmail, OtpPurpose purpose) {
        String email = normalizeEmail(rawEmail);
        List<OtpVerification> otps = otpRepository.findByEmailAndPurpose(email, purpose);
        for (OtpVerification otp : otps) {
            otp.setVerified(true);
            otp.setExpiresAt(LocalDateTime.now().minusDays(1));
        }
        otpRepository.saveAll(otps);
    }

    private void checkCooldownAndRateLimits(String email, OtpPurpose purpose) {
        otpRepository.findTopByEmailAndPurposeOrderByIdDesc(email, purpose).ifPresent(last -> {
            if (last.getCreatedAt() != null) {
                long secondsSince = java.time.Duration.between(last.getCreatedAt(), LocalDateTime.now()).getSeconds();
                if (secondsSince < RESEND_COOLDOWN_SECONDS) {
                    long waitSeconds = RESEND_COOLDOWN_SECONDS - secondsSince;
                    throw new IllegalArgumentException("Please wait " + waitSeconds + " seconds before requesting another verification code.");
                }
            }
        });

        long recentCount = otpRepository.countByEmailAndPurposeAndCreatedAtAfter(
                email, purpose, LocalDateTime.now().minusHours(1));
        if (recentCount >= MAX_HOURLY_REQUESTS) {
            throw new IllegalArgumentException("Maximum OTP requests exceeded for this hour. Please try again later.");
        }
    }

    private String generateSecure6DigitOtp() {
        int number = 100000 + secureRandom.nextInt(900000);
        return String.valueOf(number);
    }

    private String normalizeEmail(String email) {
        return email != null ? email.trim().toLowerCase() : "";
    }
}