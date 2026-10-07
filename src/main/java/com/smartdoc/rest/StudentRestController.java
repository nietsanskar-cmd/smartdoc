package com.smartdoc.rest;

import com.smartdoc.dto.response.ApiResponse;
import com.smartdoc.dto.response.CompletenessScoreDto;
import com.smartdoc.dto.response.StudentProfileDto;
import com.smartdoc.entity.Student;
import com.smartdoc.service.CompletenessScoreService;
import com.smartdoc.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
public class StudentRestController {

    private final StudentService studentService;
    private final CompletenessScoreService completenessScoreService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Student>>> getAllStudents(@RequestParam(value = "query", required = false) String query,
                                                                    @RequestParam(value = "deptId", required = false) Long deptId,
                                                                    @RequestParam(value = "courseId", required = false) Long courseId) {
        List<Student> list = studentService.searchStudents(query, deptId, courseId);
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<StudentProfileDto>> getStudentProfile(@PathVariable("id") Long id) {
        return ResponseEntity.ok(ApiResponse.success(studentService.getProfileDto(id)));
    }

    @GetMapping("/{id}/completeness")
    public ResponseEntity<ApiResponse<CompletenessScoreDto>> getCompletenessScore(@PathVariable("id") Long id) {
        return ResponseEntity.ok(ApiResponse.success(completenessScoreService.calculateScore(id)));
    }
}
