SELECT
    co."complianceId",
    co."complianceNumber",
    co."complianceSummary",
    encode(convert_to(co."complianceSummary", 'UTF8'), 'hex') AS compliance_summary_hex,
    e."evidenceId",
    e."evidenceNumber",
    e."evidenceSummary"
FROM compliances co
LEFT JOIN evidence e ON e."complianceId" = co."complianceId"
WHERE co."complianceNumber" = '1.1.6'
ORDER BY e."evidenceNumber", e."evidenceId";
