package com.smartdoc.service.impl;

import com.smartdoc.entity.DocumentCategory;
import com.smartdoc.entity.DocumentType;
import com.smartdoc.entity.RequiredDocument;
import com.smartdoc.exception.ResourceNotFoundException;
import com.smartdoc.repository.DocumentCategoryRepository;
import com.smartdoc.repository.DocumentTypeRepository;
import com.smartdoc.repository.RequiredDocumentRepository;
import com.smartdoc.service.DocumentTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DocumentTypeServiceImpl implements DocumentTypeService {

    private final DocumentCategoryRepository categoryRepository;
    private final DocumentTypeRepository typeRepository;
    private final RequiredDocumentRepository requiredDocumentRepository;

    @Override
    public List<DocumentCategory> findAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    public List<DocumentType> findAllActiveTypes() {
        return typeRepository.findByIsActiveTrue();
    }

    @Override
    public List<DocumentType> findAllTypes() {
        return typeRepository.findAll();
    }

    @Override
    public List<DocumentType> findTypesByCategory(Long categoryId) {
        return typeRepository.findByCategoryId(categoryId);
    }

    @Override
    public DocumentType findTypeById(Long id) {
        return typeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Document type not found with id: " + id));
    }

    @Override
    @Transactional
    public DocumentType createType(DocumentType documentType) {
        if (typeRepository.existsByTypeCode(documentType.getTypeCode())) {
            throw new IllegalArgumentException("Document type code already exists: " + documentType.getTypeCode());
        }
        return typeRepository.save(documentType);
    }

    @Override
    @Transactional
    public DocumentType updateType(Long id, DocumentType documentType) {
        DocumentType existing = findTypeById(id);
        existing.setTypeName(documentType.getTypeName());
        existing.setDescription(documentType.getDescription());
        existing.setCategory(documentType.getCategory());
        existing.setIsExpiryApplicable(documentType.getIsExpiryApplicable());
        existing.setDefaultValidityMonths(documentType.getDefaultValidityMonths());
        return typeRepository.save(existing);
    }

    @Override
    @Transactional
    public void toggleTypeStatus(Long id) {
        DocumentType type = findTypeById(id);
        type.setIsActive(!Boolean.TRUE.equals(type.getIsActive()));
        typeRepository.save(type);
    }

    @Override
    public List<RequiredDocument> findMandatoryRulesForStudent(Long courseId, Long semesterId) {
        return requiredDocumentRepository.findMandatoryForStudent(courseId, semesterId);
    }

    @Override
    public List<RequiredDocument> findAllRequiredRules() {
        return requiredDocumentRepository.findAll();
    }

    @Override
    @Transactional
    public RequiredDocument saveRequiredRule(RequiredDocument requiredDocument) {
        return requiredDocumentRepository.save(requiredDocument);
    }

    @Override
    @Transactional
    public void deleteRequiredRule(Long id) {
        requiredDocumentRepository.deleteById(id);
    }
}
