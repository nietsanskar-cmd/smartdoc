package com.smartdoc.dao.impl;

import com.smartdoc.dao.CustomAnalyticsDao;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Repository
public class CustomAnalyticsDaoImpl implements CustomAnalyticsDao {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public Map<String, Long> getDocumentStatusCounts() {
        String sql = "SELECT status, COUNT(*) FROM documents GROUP BY status";
        Query query = entityManager.createNativeQuery(sql);
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put(String.valueOf(row[0]), ((Number) row[1]).longValue());
        }
        return map;
    }

    @Override
    public Map<String, Long> getDepartmentStudentCounts() {
        String sql = "SELECT d.dept_name, COUNT(s.id) FROM departments d LEFT JOIN students s ON d.id = s.department_id GROUP BY d.dept_name";
        Query query = entityManager.createNativeQuery(sql);
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put(String.valueOf(row[0]), ((Number) row[1]).longValue());
        }
        return map;
    }

    @Override
    public Map<String, Double> getDepartmentCompletenessAverages() {
        String sql = "SELECT d.dept_name, COALESCE(AVG(s.completeness_score), 0.0) FROM departments d LEFT JOIN students s ON d.id = s.department_id GROUP BY d.dept_name";
        Query query = entityManager.createNativeQuery(sql);
        List<Object[]> results = query.getResultList();
        Map<String, Double> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put(String.valueOf(row[0]), Math.round(((Number) row[1]).doubleValue() * 100.0) / 100.0);
        }
        return map;
    }

    @Override
    public Map<String, Long> getMonthlyUploadCounts() {
        String sql = "SELECT DATE_FORMAT(created_at, '%b %Y') as m, COUNT(*) FROM documents GROUP BY DATE_FORMAT(created_at, '%b %Y') ORDER BY MIN(created_at) DESC LIMIT 6";
        Query query = entityManager.createNativeQuery(sql);
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put(String.valueOf(row[0]), ((Number) row[1]).longValue());
        }
        return map;
    }

    @Override
    public Map<String, Long> getTopDocumentTypeCounts() {
        String sql = "SELECT dt.type_name, COUNT(d.id) as cnt FROM document_types dt LEFT JOIN documents d ON dt.id = d.document_type_id GROUP BY dt.type_name ORDER BY cnt DESC LIMIT 5";
        Query query = entityManager.createNativeQuery(sql);
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put(String.valueOf(row[0]), ((Number) row[1]).longValue());
        }
        return map;
    }
}
