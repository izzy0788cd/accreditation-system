SELECT json_build_object(
 'standards',(SELECT md5(jsonb_agg(to_jsonb(s) ORDER BY s."standardId")::text) FROM standards s WHERE s."standardNumber"<>'26'),
 'criteria',(SELECT md5(jsonb_agg(to_jsonb(c) ORDER BY c."criterionId")::text) FROM criteria c JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"<>'26'),
 'compliances',(SELECT md5(jsonb_agg(to_jsonb(co) ORDER BY co."complianceId")::text) FROM compliances co JOIN criteria c ON c."criterionId"=co."criterionId" JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"<>'26'),
 'evidence',(SELECT md5(jsonb_agg(to_jsonb(e) ORDER BY e."evidenceId")::text) FROM evidence e JOIN compliances co ON co."complianceId"=e."complianceId" JOIN criteria c ON c."criterionId"=co."criterionId" JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"<>'26'),
 'surveys',(SELECT md5(jsonb_agg(to_jsonb(s) ORDER BY s."surveyId")::text) FROM surveys s),
 'assessments',(SELECT md5(jsonb_agg(to_jsonb(a) ORDER BY a."complianceAssessmentId")::text) FROM "complianceAssessments" a),
 'checks',(SELECT md5(jsonb_agg(to_jsonb(e) ORDER BY e."complianceEvidenceCheckId")::text) FROM "complianceEvidenceChecks" e));
