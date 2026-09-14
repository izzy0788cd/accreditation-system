WITH framework_text AS (
    SELECT 'functions' AS source, concat_ws(' ', "functionNumber", "functionTitle", "functionSummary") AS content FROM functions
    UNION ALL SELECT 'components', concat_ws(' ', "componentNumber", "componentName", "componentSummary") FROM components
    UNION ALL SELECT 'standards', concat_ws(' ', "standardNumber", "standardTitle", "standardSummary") FROM standards
    UNION ALL SELECT 'criteria', concat_ws(' ', "criterionNumber", "criterionTitle") FROM criteria
    UNION ALL SELECT 'compliances', concat_ws(' ', "complianceNumber", "complianceSummary") FROM compliances
    UNION ALL SELECT 'evidence', concat_ws(' ', "evidenceNumber", "evidenceSummary") FROM evidence
)
SELECT
    source,
    count(*) FILTER (
        WHERE strpos(content, U&'\0393\00C7\00D6') > 0
           OR strpos(content, U&'\0393\00C7\00F6') > 0
           OR strpos(content, U&'\0393\00C7\00A3') > 0
           OR strpos(content, U&'\0393\00C7\00A5') > 0
           OR strpos(content, U&'\0393\00C7\00FF') > 0
           OR strpos(content, U&'\0393\00C7\00F3') > 0
           OR strpos(content, U&'\0393\00C7\00F4') > 0
    ) AS legacy_mojibake_rows,
    count(*) FILTER (WHERE strpos(content, chr(65533)) > 0) AS replacement_character_rows
FROM framework_text
GROUP BY source
ORDER BY source;
