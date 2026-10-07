package com.smartdoc.dao;

import java.util.Map;
import java.util.List;

public interface CustomAnalyticsDao {
    Map<String, Long> getDocumentStatusCounts();
    Map<String, Long> getDepartmentStudentCounts();
    Map<String, Double> getDepartmentCompletenessAverages();
    Map<String, Long> getMonthlyUploadCounts();
    Map<String, Long> getTopDocumentTypeCounts();
}
