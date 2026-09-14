SELECT
    s."surveyId",
    f."facilityName",
    l."levelName",
    c."categoryName",
    st."surveyTypeName",
    s."startDate",
    s."endDate",
    s."isCancelled",
    count(DISTINCT ca."complianceAssessmentId") AS requirements,
    count(DISTINCT ca."complianceAssessmentId") FILTER (WHERE ca."scoreId" IS NOT NULL) AS scored_requirements,
    count(DISTINCT ca."complianceAssessmentId") FILTER (WHERE ca."riskRatingId" IS NOT NULL) AS risk_ratings,
    count(DISTINCT cec."complianceEvidenceCheckId") FILTER (WHERE cec."isChecked") AS evidence_checked,
    count(DISTINCT cec."complianceEvidenceCheckId") AS evidence_total
FROM surveys s
JOIN facilities f ON f."facilityId" = s."facilityId"
LEFT JOIN levels l ON l."levelId" = f."levelId"
LEFT JOIN organizations o ON o."organizationId" = f."organizationId"
LEFT JOIN categories c ON c."categoryId" = o."categoryId"
LEFT JOIN "surveyTypes" st ON st."surveyTypeId" = s."surveyTypeId"
LEFT JOIN "complianceAssessments" ca ON ca."surveyId" = s."surveyId"
LEFT JOIN "complianceEvidenceChecks" cec ON cec."complianceAssessmentId" = ca."complianceAssessmentId"
WHERE lower(f."facilityName") LIKE '%morata%'
GROUP BY s."surveyId", f."facilityName", l."levelName", c."categoryName", st."surveyTypeName", s."startDate", s."endDate", s."isCancelled"
ORDER BY s."surveyId" DESC;
