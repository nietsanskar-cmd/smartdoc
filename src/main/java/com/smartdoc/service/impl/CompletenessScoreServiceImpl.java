package com.smartdoc.service.impl;

import com.smartdoc.dto.response.CompletenessScoreDto;
import com.smartdoc.entity.Document;
import com.smartdoc.entity.RequiredDocument;
import com.smartdoc.entity.Student;
import com.smartdoc.entity.enums.CompletenessTier;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.exception.StudentNotFoundException;
import com.smartdoc.repository.DocumentRepository;
import com.smartdoc.repository.RequiredDocumentRepository;
import com.smartdoc.repository.StudentRepository;
import com.smartdoc.service.CompletenessScoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class CompletenessScoreServiceImpl implements CompletenessScoreService {

    private final StudentRepository studentRepository;
    private final RequiredDocumentRepository requiredDocumentRepository;
    private final DocumentRepository documentRepository;

    @Override
    @Transactional
    public CompletenessScoreDto calculateScore(Long studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new StudentNotFoundException("Student not found with id: " + studentId));

        Long courseId = student.getCourse() != null ? student.getCourse().getId() : null;
        Long semId = student.getCurrentSemester() != null ? student.getCurrentSemester().getId() : null;

        List<RequiredDocument> requiredList = requiredDocumentRepository.findMandatoryForStudent(courseId, semId);
        List<Document> studentDocs = documentRepository.findByStudentId(studentId);

        int totalRequired = requiredList.size();
        int totalVerified = 0;
        int totalPending = 0;
        int totalRejected = 0;
        int totalExpiring = 0;

        List<String> missingDocNames = new ArrayList<>();
        List<String> expiringDocNames = new ArrayList<>();
        LocalDate now = LocalDate.now();

        Map<Long, Document> activeVerifiedDocs = new HashMap<>();
        for (Document doc : studentDocs) {
            if (DocumentStatus.VERIFIED.equals(doc.getStatus()) || DocumentStatus.ACTIVE.equals(doc.getStatus())) {
                if (doc.getExpiryDate() == null || doc.getExpiryDate().isAfter(now)) {
                    activeVerifiedDocs.put(doc.getDocumentType().getId(), doc);
                }
            }
            if (DocumentStatus.UNDER_REVIEW.equals(doc.getStatus()) || DocumentStatus.UPLOADED.equals(doc.getStatus())) {
                totalPending++;
            } else if (DocumentStatus.REJECTED.equals(doc.getStatus())) {
                totalRejected++;
            } else if (DocumentStatus.EXPIRING.equals(doc.getStatus())) {
                totalExpiring++;
                expiringDocNames.add(doc.getTitle());
            }
        }

        for (RequiredDocument req : requiredList) {
            Long typeId = req.getDocumentType().getId();
            if (activeVerifiedDocs.containsKey(typeId)) {
                totalVerified++;
            } else {
                missingDocNames.add(req.getDocumentType().getTypeName());
            }
        }

        BigDecimal score = BigDecimal.ZERO;
        if (totalRequired > 0) {
            double percentage = ((double) totalVerified / (double) totalRequired) * 100.0;
            score = BigDecimal.valueOf(percentage).setScale(2, RoundingMode.HALF_UP);
        } else {
            score = BigDecimal.valueOf(100.00).setScale(2, RoundingMode.HALF_UP);
        }

        CompletenessTier tier;
        double val = score.doubleValue();
        if (val >= 90.0) {
            tier = CompletenessTier.EXCELLENT;
        } else if (val >= 75.0) {
            tier = CompletenessTier.GOOD;
        } else if (val >= 50.0) {
            tier = CompletenessTier.INCOMPLETE;
        } else {
            tier = CompletenessTier.CRITICAL;
        }

        student.setCompletenessScore(score);
        student.setCompletenessTier(tier);
        studentRepository.save(student);

        return CompletenessScoreDto.builder()
                .score(score)
                .tier(tier)
                .totalRequired(totalRequired)
                .totalVerified(totalVerified)
                .totalPending(totalPending)
                .totalRejected(totalRejected)
                .totalExpiring(totalExpiring)
                .missingDocumentTypeNames(missingDocNames)
                .expiringDocumentNames(expiringDocNames)
                .build();
    }

    @Override
    @Transactional
    public void recalculateAllStudents() {
        List<Student> students = studentRepository.findAll();
        for (Student s : students) {
            try {
                calculateScore(s.getId());
            } catch (Exception e) {
                // Continue
            }
        }
    }
}
