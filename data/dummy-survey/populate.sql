BEGIN;
DO $$ BEGIN
IF NOT EXISTS(SELECT 1 FROM surveys WHERE "surveyId"=1 AND "facilityId"=1 AND "surveyTypeId"=1 AND NOT "isCancelled") THEN RAISE EXCEPTION 'Survey changed'; END IF;
IF EXISTS(SELECT 1 FROM "complianceAssessments" WHERE "surveyId"=1 AND ("scoreId" IS NOT NULL OR "riskRatingId" IS NOT NULL OR coalesce("complianceComments",'')<>'')) THEN RAISE EXCEPTION 'Existing results detected'; END IF;
IF EXISTS(SELECT 1 FROM "complianceEvidenceChecks" e JOIN "complianceAssessments" a ON a."complianceAssessmentId"=e."complianceAssessmentId" WHERE a."surveyId"=1 AND e."isChecked") THEN RAISE EXCEPTION 'Existing checks detected'; END IF;
END $$;
UPDATE "complianceAssessments" a SET
"scoreId"=CASE WHEN NOT (c."isApplicable" AND co."isApplicable") THEN 7 WHEN a."complianceAssessmentId"%10=0 THEN 1 WHEN a."complianceAssessmentId"%10 IN (1,2) THEN 2 ELSE 3 END,
"riskRatingId"=CASE WHEN NOT (c."isApplicable" AND co."isApplicable") THEN NULL WHEN a."complianceAssessmentId"%10=0 THEN 3 WHEN a."complianceAssessmentId"%10 IN (1,2) THEN 2 ELSE 1 END,
"complianceComments"='DUMMY SURVEY — not actual findings. Synthetic data for testing only. ' || CASE WHEN NOT (c."isApplicable" AND co."isApplicable") THEN 'Not applicable according to framework settings.' WHEN a."complianceAssessmentId"%10=0 THEN 'Simulated non-compliance: required evidence unavailable. Test action: establish the process and arrange follow-up review.' WHEN a."complianceAssessmentId"%10 IN (1,2) THEN 'Simulated partial compliance: some evidence available; documentation incomplete. Test action: complete records and review staff training.' ELSE 'Simulated compliance: required evidence marked available for demonstration.' END
FROM compliances co JOIN criteria c ON c."criterionId"=co."criterionId" WHERE a."surveyId"=1 AND a."complianceId"=co."complianceId";
WITH ranked AS (SELECT ec."complianceEvidenceCheckId",a."scoreId",e."isApplicable",row_number() OVER(PARTITION BY a."complianceAssessmentId" ORDER BY e."evidenceId") rn FROM "complianceEvidenceChecks" ec JOIN "complianceAssessments" a ON a."complianceAssessmentId"=ec."complianceAssessmentId" JOIN evidence e ON e."evidenceId"=ec."evidenceId" WHERE a."surveyId"=1)
UPDATE "complianceEvidenceChecks" ec SET "isChecked"=r."isApplicable" AND (r."scoreId"=3 OR (r."scoreId"=2 AND r.rn%2=0)) FROM ranked r WHERE ec."complianceEvidenceCheckId"=r."complianceEvidenceCheckId";
COMMIT;
SELECT json_build_object('surveyId',1,'assessments',count(*),'scored',count("scoreId"),'dummyLabelled',count(*) FILTER(WHERE "complianceComments" LIKE 'DUMMY SURVEY%')) FROM "complianceAssessments" WHERE "surveyId"=1;
SELECT json_build_object('score',s.description,'count',count(*)) FROM "complianceAssessments" a JOIN scores s ON s."scoreId"=a."scoreId" WHERE a."surveyId"=1 GROUP BY s.description;
SELECT json_build_object('evidenceChecks',count(*),'checked',count(*) FILTER(WHERE e."isChecked")) FROM "complianceEvidenceChecks" e JOIN "complianceAssessments" a ON a."complianceAssessmentId"=e."complianceAssessmentId" WHERE a."surveyId"=1;
