package com.smartdoc.service;

import com.smartdoc.entity.DocumentCategory;
import com.smartdoc.entity.DocumentType;
import com.smartdoc.entity.RequiredDocument;
import java.util.List;

public interface DocumentTypeService {
    List<DocumentCategory> findAllCategories();
    List<DocumentType> findAllActiveTypes();
    List<DocumentType> findAllTypes();
    List<DocumentType> findTypesByCategory(Long categoryId);
    DocumentType findTypeById(Long id);
    DocumentType createType(DocumentType documentType);
    DocumentType updateType(Long id, DocumentType documentType);
    void toggleTypeStatus(Long id);
    
    List<RequiredDocument> findMandatoryRulesForStudent(Long courseId, Long semesterId);
    List<RequiredDocument> findAllRequiredRules();
    RequiredDocument saveRequiredRule(RequiredDocument requiredDocument);
    void deleteRequiredRule(Long id);
}
