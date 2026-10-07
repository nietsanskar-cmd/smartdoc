package com.smartdoc.scheduler;

import com.smartdoc.entity.Document;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.entity.enums.NotificationType;
import com.smartdoc.repository.DocumentRepository;
import com.smartdoc.service.CompletenessScoreService;
import com.smartdoc.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Component
@Slf4j
@RequiredArgsConstructor
public class DocumentExpiryScheduler {

    private final DocumentRepository documentRepository;
    private final CompletenessScoreService completenessScoreService;
    private final NotificationService notificationService;

    /**
     * Runs daily at midnight to scan for expiring and expired documents.
     */
    @Scheduled(cron = "0 0 0 * * ?")
    @Transactional
    public void checkDocumentExpirations() {
        log.info("Running scheduled document expiration and renewal maintenance...");
        LocalDate today = LocalDate.now();
        LocalDate warningDate = today.plusDays(30);

        // 1. Mark expiring documents (within 30 days)
        List<Document> expiringList = documentRepository.findExpiringDocuments(warningDate);
        for (Document doc : expiringList) {
            if (DocumentStatus.ACTIVE.equals(doc.getStatus()) || DocumentStatus.VERIFIED.equals(doc.getStatus())) {
                doc.setStatus(DocumentStatus.EXPIRING);
                documentRepository.save(doc);

                notificationService.createNotification(doc.getStudent().getUser(), "Document Expiring Soon",
                        "Your document '" + doc.getTitle() + "' will expire on " + doc.getExpiryDate() + ". Please prepare a renewal.",
                        NotificationType.EXPIRY, "/student/vault");
            }
        }

        // 2. Mark past-due expired documents
        List<Document> expiredList = documentRepository.findExpiredDocuments(today);
        for (Document doc : expiredList) {
            doc.setStatus(DocumentStatus.EXPIRED);
            documentRepository.save(doc);

            notificationService.createNotification(doc.getStudent().getUser(), "Document Expired",
                    "Your document '" + doc.getTitle() + "' expired on " + doc.getExpiryDate() + ". Your completeness score has been updated.",
                    NotificationType.EXPIRY, "/student/upload");

            completenessScoreService.calculateScore(doc.getStudent().getId());
        }

        log.info("Completed document expiration checks. Processed {} expiring, {} expired.", expiringList.size(), expiredList.size());
    }
}
