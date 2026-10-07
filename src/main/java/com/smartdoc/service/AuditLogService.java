package com.smartdoc.service;

import com.smartdoc.entity.AuditLog;
import com.smartdoc.entity.User;
import com.smartdoc.entity.enums.AuditAction;
import java.util.List;

public interface AuditLogService {
    void logAction(User user, AuditAction action, String entityType, Long entityId, String ipAddress, String details);
    List<AuditLog> getRecentAuditLogs();
    List<AuditLog> getUserAuditLogs(Long userId);
}
