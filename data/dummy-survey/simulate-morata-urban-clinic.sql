BEGIN;

CREATE TEMP TABLE morata_simulation_targets ON COMMIT DROP AS
SELECT
    ca."complianceAssessmentId",
    CASE
        WHEN lower(co."complianceSummary") ~ '(operating theatre|intensive care|\yicu\y|dialysis|mortuary|blood bank|neonatal intensive|inpatient ward|maternity ward|hospital health specialist|tertiary care|level 4|level 5)'
            THEN 7
        WHEN mod(ca."complianceAssessmentId", 10) = 0 THEN 1
        WHEN mod(ca."complianceAssessmentId", 10) IN (1, 2) THEN 2
        ELSE 3
    END AS "scoreId",
    CASE
        WHEN lower(co."complianceSummary") ~ '(operating theatre|intensive care|\yicu\y|dialysis|mortuary|blood bank|neonatal intensive|inpatient ward|maternity ward|hospital health specialist|tertiary care|level 4|level 5)'
            THEN NULL
        WHEN mod(ca."complianceAssessmentId", 10) = 0 THEN 3
        WHEN mod(ca."complianceAssessmentId", 10) IN (1, 2) THEN 2
        ELSE 1
    END AS "riskRatingId",
    CASE
        WHEN lower(co."complianceSummary") ~ '(operating theatre|intensive care|\yicu\y|dialysis|mortuary|blood bank|neonatal intensive|inpatient ward|maternity ward|hospital health specialist|tertiary care|level 4|level 5)'
            THEN 'SIMULATED N/A — this requirement relates to services not routinely provided by a Level 3 urban clinic. Confirm the service scope with Morata Urban Clinic management during the on-site visit.'
        WHEN mod(ca."complianceAssessmentId", 10) = 0
            THEN 'SIMULATED FINDING — the requirement was not demonstrated in this scenario. Corrective action should assign responsibility, establish the required process, and set a review date.'
        WHEN mod(ca."complianceAssessmentId", 10) IN (1, 2)
            THEN 'SIMULATED FINDING — the process is partly in place, but evidence or routine review is incomplete. Strengthen documentation, staff briefing, and periodic monitoring.'
        ELSE 'SIMULATED FINDING — routine evidence was available and staff described the process as implemented. Confirm supporting documents and staff practice during the on-site visit.'
    END AS "complianceComments"
FROM "complianceAssessments" ca
JOIN compliances co ON co."complianceId" = ca."complianceId"
WHERE ca."surveyId" = 1
  AND ca."scoreId" IS NULL;

UPDATE "complianceAssessments" ca
SET "scoreId" = target."scoreId",
    "riskRatingId" = target."riskRatingId",
    "complianceComments" = target."complianceComments"
FROM morata_simulation_targets target
WHERE ca."complianceAssessmentId" = target."complianceAssessmentId";

UPDATE "complianceEvidenceChecks" check_record
SET "isChecked" = CASE
    WHEN target."scoreId" = 3 THEN true
    WHEN target."scoreId" = 2 THEN mod(check_record."complianceEvidenceCheckId", 2) = 1
    ELSE false
END
FROM "complianceAssessments" ca
JOIN morata_simulation_targets target ON target."complianceAssessmentId" = ca."complianceAssessmentId"
WHERE check_record."complianceAssessmentId" = ca."complianceAssessmentId";

COMMIT;

SELECT
    sc."scoreLabel",
    count(*) AS requirements,
    count(*) FILTER (WHERE ca."complianceComments" LIKE 'SIMULATED%') AS simulated_requirements
FROM "complianceAssessments" ca
LEFT JOIN scores sc ON sc."scoreId" = ca."scoreId"
WHERE ca."surveyId" = 1
GROUP BY sc."scoreLabel", sc."scoreValue"
ORDER BY sc."scoreValue" NULLS LAST;
