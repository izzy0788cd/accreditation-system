WITH framework_text AS (
    SELECT 'functions' AS source, "functionId" AS id, "functionSummary" AS content FROM functions
    UNION ALL SELECT 'components', "componentId", "componentSummary" FROM components
    UNION ALL SELECT 'standards', "standardId", "standardSummary" FROM standards
    UNION ALL SELECT 'compliances', "complianceId", "complianceSummary" FROM compliances
    UNION ALL SELECT 'evidence', "evidenceId", "evidenceSummary" FROM evidence
)
SELECT source, id, content
FROM framework_text
WHERE strpos(content, '???') > 0
ORDER BY source, id;
