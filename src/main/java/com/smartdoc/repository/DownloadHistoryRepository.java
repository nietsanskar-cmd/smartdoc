package com.smartdoc.repository;

import com.smartdoc.entity.DownloadHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DownloadHistoryRepository extends JpaRepository<DownloadHistory, Long> {
    List<DownloadHistory> findByDocumentIdOrderByDownloadedAtDesc(Long documentId);
    List<DownloadHistory> findTop50ByOrderByDownloadedAtDesc();
}
