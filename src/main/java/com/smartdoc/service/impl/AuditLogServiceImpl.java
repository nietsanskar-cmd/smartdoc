package com.smartdoc.service.impl;

import com.smartdoc.entity.AuditLog;
import com.smartdoc.entity.User;
import com.smartdoc.entity.enums.AuditAction;
import com.smartdoc.repository.AuditLogRepository;
import com.smartdoc.service.AuditLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AuditLogServiceImpl implements AuditLogService {

    private final AuditLogRepository auditLogRepository;

    @Override
    @Transactional
    public void logAction(User user, AuditAction action, String entityType, Long entityId, String ipAddress, String details) {
        try {
            AuditLog log = AuditLog.builder()
                    .user(user)
                    .action(action)
                    .entityType(entityType != null ? entityType : "SYSTEM")
                    .entityId(entityId)
                    .ipAddress(ipAddress != null ? ipAddress : "127.0.0.1")
                    .details(details)
                    .build();
            auditLogRepository.save(log);
        } catch (Exception e) {
            // Never break main transaction on audit log write
        }
    }

    @Override
    public List<AuditLog> getRecentAuditLogs() {
        return auditLogRepository.findTop100ByOrderByCreatedAtDesc();
    }

    @Override
    public List<AuditLog> getUserAuditLogs(Long userId) {
        return auditLogRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }
}
