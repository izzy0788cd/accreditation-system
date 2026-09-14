SELECT
    sc."scoreLabel",
    sc."scoreValue",
    count(*) AS assessments,
    count(*) FILTER (WHERE ca."complianceComments" IS NOT NULL AND btrim(ca."complianceComments") <> '') AS with_comments
FROM "complianceAssessments" ca
LEFT JOIN scores sc ON sc."scoreId" = ca."scoreId"
WHERE ca."surveyId" = 1
GROUP BY sc."scoreLabel", sc."scoreValue"
ORDER BY sc."scoreValue" NULLS LAST;

SELECT
    ca."complianceAssessmentId",
    co."complianceNumber",
    sc."scoreLabel",
    ca."complianceComments"
FROM "complianceAssessments" ca
JOIN compliances co ON co."complianceId" = ca."complianceId"
LEFT JOIN scores sc ON sc."scoreId" = ca."scoreId"
WHERE ca."surveyId" = 1
  AND ca."scoreId" IS NOT NULL
ORDER BY ca."complianceAssessmentId"
LIMIT 12;
