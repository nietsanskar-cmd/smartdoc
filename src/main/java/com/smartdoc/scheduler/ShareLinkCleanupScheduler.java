package com.smartdoc.scheduler;

import com.smartdoc.entity.DocumentShare;
import com.smartdoc.repository.DocumentShareRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Component
@Slf4j
@RequiredArgsConstructor
public class ShareLinkCleanupScheduler {

    private final DocumentShareRepository shareRepository;

    /**
     * Runs every hour to clean up and revoke expired sharing links.
     */
    @Scheduled(cron = "0 0 * * * ?")
    @Transactional
    public void cleanupExpiredShares() {
        log.info("Running scheduled cleanup for expired secure document shares...");
        List<DocumentShare> expiredShares = shareRepository.findExpiredActiveShares(LocalDateTime.now());
        for (DocumentShare share : expiredShares) {
            share.setIsRevoked(true);
        }
        shareRepository.saveAll(expiredShares);
        log.info("Revoked {} expired share links.", expiredShares.size());
    }
}
