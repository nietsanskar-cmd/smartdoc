package com.smartdoc.rest;

import com.smartdoc.dto.response.ApiResponse;
import com.smartdoc.entity.Faculty;
import com.smartdoc.service.FacultyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/faculty")
@RequiredArgsConstructor
public class FacultyRestController {

    private final FacultyService facultyService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Faculty>>> getAllFaculty() {
        return ResponseEntity.ok(ApiResponse.success(facultyService.findAll()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Faculty>> getFacultyById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(ApiResponse.success(facultyService.findById(id)));
    }
}
