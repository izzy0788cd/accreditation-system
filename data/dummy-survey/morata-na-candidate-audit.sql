SELECT
    co."complianceNumber",
    left(replace(co."complianceSummary", E'\n', ' '), 180) AS requirement
FROM "complianceAssessments" ca
JOIN compliances co ON co."complianceId" = ca."complianceId"
WHERE ca."surveyId" = 1
  AND ca."scoreId" IS NULL
  AND lower(co."complianceSummary") ~ '(operating theatre|intensive care|\yicu\y|dialysis|mortuary|blood bank|neonatal intensive|inpatient ward|maternity ward|hospital health specialist|tertiary care|level 4|level 5)'
ORDER BY co."complianceNumber";
