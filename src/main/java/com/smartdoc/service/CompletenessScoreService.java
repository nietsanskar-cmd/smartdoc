package com.smartdoc.service;

import com.smartdoc.dto.response.CompletenessScoreDto;

public interface CompletenessScoreService {
    CompletenessScoreDto calculateScore(Long studentId);
    void recalculateAllStudents();
}
