import json,pathlib
p=pathlib.Path(__file__).parent
d=json.loads((p/'extracted.json').read_text(encoding='utf-8'))
def q(x): return "'"+x.replace("'","''")+"'"
def values(rows): return ',\n'.join('('+','.join(q(x) for x in row)+')' for row in rows)
sql='''BEGIN;
SET LOCAL lock_timeout='5s';
LOCK TABLE standards,criteria,compliances,evidence,"complianceAssessments","complianceEvidenceChecks","surveyorReports","surveyorStandardSummaries","surveyToolkitSnapshotCompliances","surveyToolkitTemplateCompliances" IN SHARE ROW EXCLUSIVE MODE;
CREATE TABLE standard7_backup_20260924 (table_name text NOT NULL, row_data jsonb NOT NULL);
CREATE TEMP TABLE old_c AS SELECT * FROM criteria WHERE "standardId"=6;
CREATE TEMP TABLE old_co AS SELECT co.* FROM compliances co JOIN old_c c USING ("criterionId");
CREATE TEMP TABLE old_a AS SELECT a.* FROM "complianceAssessments" a JOIN old_co c USING ("complianceId");
CREATE TEMP TABLE affected AS SELECT DISTINCT "surveyId","surveyorId" FROM old_a;
DO $$ BEGIN
 IF NOT EXISTS (SELECT 1 FROM standards WHERE "standardId"=6 AND "standardNumber"='7') THEN RAISE EXCEPTION 'Standard identity changed'; END IF;
 IF EXISTS (SELECT "surveyId" FROM affected GROUP BY "surveyId" HAVING count(*)>1) THEN RAISE EXCEPTION 'Multiple owners require manual mapping'; END IF;
END $$;
CREATE TEMP TABLE unchanged AS SELECT md5(coalesce(string_agg(row_to_json(a)::text,'|' ORDER BY a."complianceAssessmentId"),'')) checksum FROM "complianceAssessments" a WHERE a."complianceId" NOT IN (SELECT "complianceId" FROM old_co);
'''
backups={
'standards':'"standardId"=6', 'criteria':'"standardId"=6',
'compliances':'"complianceId" IN (SELECT "complianceId" FROM old_co)',
'evidence':'"complianceId" IN (SELECT "complianceId" FROM old_co)',
'complianceAssessments':'"complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a)',
'complianceEvidenceChecks':'"complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a)',
'surveyorStandardSummaries':'"standardId"=6',
'surveyorReports':'("surveyId","surveyorId") IN (SELECT * FROM affected)',
'surveyToolkitSnapshotCompliances':'"complianceId" IN (SELECT "complianceId" FROM old_co)',
'surveyToolkitTemplateCompliances':'"complianceId" IN (SELECT "complianceId" FROM old_co)'}
for table,where in backups.items(): sql+=f'INSERT INTO standard7_backup_20260924 SELECT {q(table)},to_jsonb(t) FROM "{table}" t WHERE {where};\n'
sql+='''CREATE TEMP TABLE snapshots AS SELECT DISTINCT "surveyToolkitSnapshotId" FROM "surveyToolkitSnapshotCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
CREATE TEMP TABLE templates AS SELECT DISTINCT "surveyToolkitTemplateId" FROM "surveyToolkitTemplateCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
INSERT INTO "surveyorReportReopens" ("surveyorReportId",reason,"reopenedByUsername","reopenedAt","previousSubmittedAt") SELECT "surveyorReportId",'Standard 7 replaced by user request; repeat assessment and summation required.','Standard 7 import',now(),"submittedAt" FROM "surveyorReports" WHERE "isSubmitted" AND ("surveyId","surveyorId") IN (SELECT * FROM affected);
UPDATE "surveyorReports" SET "isSubmitted"=false,"updatedAt"=now() WHERE "isSubmitted" AND ("surveyId","surveyorId") IN (SELECT * FROM affected);
DELETE FROM "surveyorStandardSummaries" WHERE "standardId"=6;
DELETE FROM "complianceEvidenceChecks" WHERE "complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a);
DELETE FROM "complianceAssessments" WHERE "complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a);
DELETE FROM "surveyToolkitSnapshotCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM "surveyToolkitTemplateCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM evidence WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM compliances WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM criteria WHERE "standardId"=6;
CREATE TEMP TABLE new_c (number text PRIMARY KEY,title text);
CREATE TEMP TABLE new_co (parent text,number text PRIMARY KEY,summary text);
CREATE TEMP TABLE new_e (parent text,number text,summary text,PRIMARY KEY(parent,number));
'''
sql+='INSERT INTO new_c VALUES '+values(d['criteria'])+';\nINSERT INTO new_co VALUES '+values(d['compliances'])+';\nINSERT INTO new_e VALUES '+values(d['evidence'])+';\n'
header=d['header']; title,summary=header.split('\n',1)
sql+='UPDATE standards SET "standardTitle"='+q(title.replace('STANDARD 7: ','').strip())+',"standardSummary"='+q(summary)+' WHERE "standardId"=6;\n'
sql+='''INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable") SELECT number,title,6,true FROM new_c;
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT n.number,n.summary,c."criterionId",true FROM new_co n JOIN criteria c ON c."criterionNumber"=n.parent AND c."standardId"=6;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT n.number,n.summary,co."complianceId",true FROM new_e n JOIN compliances co ON co."complianceNumber"=n.parent JOIN criteria c ON c."criterionId"=co."criterionId" AND c."standardId"=6;
CREATE TEMP TABLE replacement AS SELECT co.* FROM compliances co JOIN criteria c USING ("criterionId") WHERE c."standardId"=6;
INSERT INTO "complianceAssessments" ("surveyId","surveyorId","complianceId") SELECT a."surveyId",a."surveyorId",c."complianceId" FROM affected a CROSS JOIN replacement c;
INSERT INTO "complianceEvidenceChecks" ("complianceAssessmentId","evidenceId","isChecked") SELECT a."complianceAssessmentId",e."evidenceId",false FROM "complianceAssessments" a JOIN replacement c USING ("complianceId") JOIN evidence e USING ("complianceId");
INSERT INTO "surveyToolkitSnapshotCompliances" ("surveyToolkitSnapshotId","complianceId") SELECT s."surveyToolkitSnapshotId",c."complianceId" FROM snapshots s CROSS JOIN replacement c;
INSERT INTO "surveyToolkitTemplateCompliances" ("surveyToolkitTemplateId","complianceId") SELECT s."surveyToolkitTemplateId",c."complianceId" FROM templates s CROSS JOIN replacement c;
DO $$ BEGIN
 IF (SELECT count(*) FROM criteria WHERE "standardId"=6)<>14 OR (SELECT count(*) FROM replacement)<>56 OR (SELECT count(*) FROM evidence e JOIN replacement c USING ("complianceId"))<>187 THEN RAISE EXCEPTION 'Framework counts failed'; END IF;
 IF (SELECT count(*) FROM "complianceAssessments" a JOIN replacement c USING ("complianceId")) <> 56*(SELECT count(*) FROM affected) THEN RAISE EXCEPTION 'Checklist counts failed'; END IF;
 IF (SELECT checksum FROM unchanged) IS DISTINCT FROM (SELECT md5(coalesce(string_agg(row_to_json(a)::text,'|' ORDER BY a."complianceAssessmentId"),'')) FROM "complianceAssessments" a WHERE a."complianceId" NOT IN (SELECT "complianceId" FROM replacement)) THEN RAISE EXCEPTION 'Other assessments changed'; END IF;
END $$;
SELECT json_build_object('standardId',6,'criteria',14,'compliances',56,'evidence',187,'affectedSurveys',(SELECT json_agg("surveyId") FROM affected),'resetAssessments',(SELECT count(*) FROM old_a),'newAssessments',56*(SELECT count(*) FROM affected),'backupRows',(SELECT count(*) FROM standard7_backup_20260924));
COMMIT;
'''
(p/'import.sql').write_text(sql,encoding='utf-8')
