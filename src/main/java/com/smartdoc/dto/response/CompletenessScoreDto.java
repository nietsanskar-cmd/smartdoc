package com.smartdoc.dto.response;

import com.smartdoc.entity.enums.CompletenessTier;
import lombok.*;
import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CompletenessScoreDto {
    private BigDecimal score;
    private CompletenessTier tier;
    private int totalRequired;
    private int totalVerified;
    private int totalPending;
    private int totalRejected;
    private int totalExpiring;
    private List<String> missingDocumentTypeNames;
    private List<String> expiringDocumentNames;
}
