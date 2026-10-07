package com.smartdoc.service.impl;

import com.smartdoc.dao.CustomAnalyticsDao;
import com.smartdoc.dto.response.DashboardAnalyticsDto;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.repository.*;
import com.smartdoc.service.AnalyticsService;
import com.smartdoc.util.FileUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AnalyticsServiceImpl implements AnalyticsService {

    private final StudentRepository studentRepository;
    private final FacultyRepository facultyRepository;
    private final DocumentRepository documentRepository;
    private final CustomAnalyticsDao customAnalyticsDao;

    @Override
    public DashboardAnalyticsDto getAdminAnalytics() {
        long totalStudents = studentRepository.count();
        long totalFaculty = facultyRepository.count();
        long totalDocs = documentRepository.count();
        long pending = documentRepository.countByStatus(DocumentStatus.UNDER_REVIEW);
        long verified = documentRepository.countByStatus(DocumentStatus.VERIFIED);
        long rejected = documentRepository.countByStatus(DocumentStatus.REJECTED);
        long expired = documentRepository.countByStatus(DocumentStatus.EXPIRED);
        long expiringSoon = documentRepository.findExpiringDocuments(LocalDate.now().plusDays(30)).size();

        Long storageBytes = documentRepository.getTotalStorageUsedBytes();
        long bytes = storageBytes != null ? storageBytes : 0L;

        double verifRate = totalDocs > 0 ? ((double) verified / (double) totalDocs) * 100.0 : 0.0;
        verifRate = Math.round(verifRate * 10.0) / 10.0;

        Map<String, Long> statusBreakdown = customAnalyticsDao.getDocumentStatusCounts();
        Map<String, Long> deptStudents = customAnalyticsDao.getDepartmentStudentCounts();
        Map<String, Double> deptCompleteness = customAnalyticsDao.getDepartmentCompletenessAverages();
        Map<String, Long> monthlyTrends = customAnalyticsDao.getMonthlyUploadCounts();
        Map<String, Long> topDocTypes = customAnalyticsDao.getTopDocumentTypeCounts();

        return DashboardAnalyticsDto.builder()
                .totalStudents(totalStudents)
                .totalFaculty(totalFaculty)
                .totalDocuments(totalDocs)
                .pendingVerifications(pending)
                .verifiedDocuments(verified)
                .rejectedDocuments(rejected)
                .expiredDocuments(expired)
                .expiringSoonDocuments(expiringSoon)
                .totalStorageBytes(bytes)
                .formattedStorage(FileUtil.formatFileSize(bytes))
                .overallVerificationRate(verifRate)
                .statusBreakdown(statusBreakdown)
                .departmentStudentCounts(deptStudents)
                .departmentCompletenessAverages(deptCompleteness)
                .monthlyUploadTrends(monthlyTrends)
                .topDocumentTypes(topDocTypes)
                .build();
    }
}
