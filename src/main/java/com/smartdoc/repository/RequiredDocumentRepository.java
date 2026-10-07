package com.smartdoc.repository;

import com.smartdoc.entity.RequiredDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface RequiredDocumentRepository extends JpaRepository<RequiredDocument, Long> {
    @Query("SELECT r FROM RequiredDocument r WHERE " +
           "r.isMandatory = true AND " +
           "(r.course IS NULL OR r.course.id = :courseId) AND " +
           "(r.semester IS NULL OR r.semester.id = :semesterId)")
    List<RequiredDocument> findMandatoryForStudent(@Param("courseId") Long courseId, 
                                                   @Param("semesterId") Long semesterId);
    List<RequiredDocument> findByCourseId(Long courseId);
}
