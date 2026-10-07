package com.smartdoc.rest;

import com.smartdoc.dto.request.DocumentVerificationDto;
import com.smartdoc.dto.response.ApiResponse;
import com.smartdoc.dto.response.VerificationQueueDto;
import com.smartdoc.entity.Document;
import com.smartdoc.service.VerificationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/verification")
@RequiredArgsConstructor
public class VerificationRestController {

    private final VerificationService verificationService;

    @GetMapping("/queue")
    public ResponseEntity<ApiResponse<List<VerificationQueueDto>>> getPendingQueue() {
        return ResponseEntity.ok(ApiResponse.success(verificationService.getAllPendingQueue()));
    }

    @PostMapping("/{id}/verify")
    public ResponseEntity<ApiResponse<Document>> verifyDocument(@PathVariable("id") Long id,
                                                                @RequestParam("facultyUserId") Long facultyUserId,
                                                                @Valid @RequestBody DocumentVerificationDto dto,
                                                                HttpServletRequest request) {
        Document doc = verificationService.processVerification(id, facultyUserId, dto, request.getRemoteAddr());
        return ResponseEntity.ok(ApiResponse.success("Verification processed successfully", doc));
    }
}
