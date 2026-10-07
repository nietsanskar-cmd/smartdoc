package com.smartdoc.service;

import com.smartdoc.entity.Notification;
import com.smartdoc.entity.User;
import com.smartdoc.entity.enums.NotificationType;
import java.util.List;

public interface NotificationService {
    Notification createNotification(User user, String title, String message, NotificationType type, String linkUrl);
    List<Notification> getUserNotifications(Long userId);
    List<Notification> getUnreadNotifications(Long userId);
    long getUnreadCount(Long userId);
    void markAsRead(Long notificationId);
    void markAllAsRead(Long userId);
}
