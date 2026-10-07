package com.smartdoc.service;

import com.smartdoc.dto.response.CompletenessScoreDto;
import com.smartdoc.entity.*;
import com.smartdoc.entity.enums.CompletenessTier;
import com.smartdoc.entity.enums.DocumentStatus;
import com.smartdoc.repository.DocumentRepository;
import com.smartdoc.repository.RequiredDocumentRepository;
import com.smartdoc.repository.StudentRepository;
import com.smartdoc.service.impl.CompletenessScoreServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CompletenessScoreServiceTest {

    @Mock
    private StudentRepository studentRepository;
    @Mock
    private RequiredDocumentRepository requiredDocumentRepository;
    @Mock
    private DocumentRepository documentRepository;

    @InjectMocks
    private CompletenessScoreServiceImpl completenessScoreService;

    @Test
    void testCalculateScore_FiftyPercentIncomplete() {
        Student student = Student.builder().id(1L).completenessScore(BigDecimal.ZERO).build();
        when(studentRepository.findById(1L)).thenReturn(Optional.of(student));

        DocumentType dt1 = DocumentType.builder().id(101L).typeName("10th Marksheet").build();
        DocumentType dt2 = DocumentType.builder().id(102L).typeName("12th Marksheet").build();

        RequiredDocument req1 = RequiredDocument.builder().id(1L).documentType(dt1).isMandatory(true).build();
        RequiredDocument req2 = RequiredDocument.builder().id(2L).documentType(dt2).isMandatory(true).build();
        when(requiredDocumentRepository.findMandatoryForStudent(null, null)).thenReturn(List.of(req1, req2));

        Document doc1 = Document.builder().id(1L).documentType(dt1).status(DocumentStatus.VERIFIED).build();
        when(documentRepository.findByStudentId(1L)).thenReturn(List.of(doc1));

        CompletenessScoreDto scoreDto = completenessScoreService.calculateScore(1L);

        assertEquals(BigDecimal.valueOf(50.0).setScale(2), scoreDto.getScore());
        assertEquals(CompletenessTier.INCOMPLETE, scoreDto.getTier());
        assertEquals(2, scoreDto.getTotalRequired());
        assertEquals(1, scoreDto.getTotalVerified());
    }
}
