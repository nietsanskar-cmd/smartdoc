package com.smartdoc.dto.response;

import lombok.*;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DashboardAnalyticsDto {
    private long totalStudents;
    private long totalFaculty;
    private long totalDocuments;
    private long pendingVerifications;
    private long verifiedDocuments;
    private long rejectedDocuments;
    private long expiredDocuments;
    private long expiringSoonDocuments;
    private long totalStorageBytes;
    private String formattedStorage;
    private double overallVerificationRate;
    private Map<String, Long> statusBreakdown;
    private Map<String, Long> departmentStudentCounts;
    private Map<String, Double> departmentCompletenessAverages;
    private Map<String, Long> monthlyUploadTrends;
    private Map<String, Long> topDocumentTypes;
}
