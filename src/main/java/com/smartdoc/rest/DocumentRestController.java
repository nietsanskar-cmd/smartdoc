package com.smartdoc.rest;

import com.smartdoc.dto.request.DocumentUploadDto;
import com.smartdoc.dto.response.ApiResponse;
import com.smartdoc.dto.response.DocumentDetailsDto;
import com.smartdoc.entity.Document;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.service.DocumentService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/documents")
@RequiredArgsConstructor
public class DocumentRestController {

    private final DocumentService documentService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Document>>> getDocuments(@RequestParam(value = "query", required = false) String query,
                                                                    @RequestParam(value = "status", required = false) DocumentStatus status,
                                                                    @RequestParam(value = "typeId", required = false) Long typeId,
                                                                    @RequestParam(value = "deptId", required = false) Long deptId) {
        return ResponseEntity.ok(ApiResponse.success(documentService.searchDocuments(query, status, typeId, deptId)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<DocumentDetailsDto>> getDocumentById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(ApiResponse.success(documentService.getDocumentDetailsDto(id)));
    }

    @PostMapping("/student/{studentId}")
    public ResponseEntity<ApiResponse<Document>> uploadDocument(@PathVariable("studentId") Long studentId,
                                                                @ModelAttribute DocumentUploadDto uploadDto,
                                                                @RequestParam("userId") Long userId,
                                                                HttpServletRequest request) {
        Document doc = documentService.uploadDocument(studentId, uploadDto, userId, request.getRemoteAddr());
        return ResponseEntity.ok(ApiResponse.success("Document uploaded successfully", doc));
    }
}
