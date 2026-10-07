package com.smartdoc.controller;

import com.smartdoc.dto.response.PublicVerificationDto;
import com.smartdoc.entity.Document;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.service.DocumentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
@RequiredArgsConstructor
public class PublicVerificationController {

    private final DocumentService documentService;

    @GetMapping("/verify/document/{token}")
    public String verifyPublicDocument(@PathVariable("token") String token, Model model) {
        try {
            Document doc = documentService.findByVerificationToken(token);

            boolean isVerified = DocumentStatus.VERIFIED.equals(doc.getStatus()) || DocumentStatus.ACTIVE.equals(doc.getStatus());

            // Mask Student Name for privacy compliance (e.g. Aarav Sharma -> A**** S*****)
            String rawName = doc.getStudent().getFullName();
            String maskedName = maskName(rawName);
            String maskedEnrollment = maskEnrollment(doc.getStudent().getEnrollmentNo());

            PublicVerificationDto verificationDto = PublicVerificationDto.builder()
                    .isValid(isVerified)
                    .verificationToken(doc.getVerificationToken())
                    .documentCode(doc.getDocumentCode())
                    .documentTypeName(doc.getDocumentType().getTypeName())
                    .categoryName(doc.getDocumentType().getCategory().getCategoryName())
                    .studentMaskedName(maskedName)
                    .enrollmentNoMasked(maskedEnrollment)
                    .departmentName(doc.getStudent().getDepartment().getDeptName())
                    .institutionName("National Institute of Engineering & Technology")
                    .status(doc.getStatus().name())
                    .verifiedAt(doc.getVerifiedAt())
                    .verifiedByDesignation(doc.getVerifiedByUser() != null ? "Authorized Faculty Reviewer" : "Institutional Office")
                    .issueDate(doc.getIssueDate())
                    .expiryDate(doc.getExpiryDate())
                    .sha256Fingerprint(doc.getSha256Hash())
                    .build();

            model.addAttribute("verif", verificationDto);
            return "public/verify-document";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Invalid Verification Token: No institutional document matches this QR fingerprint.");
            return "public/verify-invalid";
        }
    }

    private String maskName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) return "***";
        String[] parts = fullName.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p.length() > 1) {
                sb.append(p.charAt(0)).append("**** ");
            } else {
                sb.append(p).append(" ");
            }
        }
        return sb.toString().trim();
    }

    private String maskEnrollment(String enroll) {
        if (enroll == null || enroll.length() <= 4) return "****";
        return enroll.substring(0, 3) + "******" + enroll.substring(enroll.length() - 2);
    }
}
