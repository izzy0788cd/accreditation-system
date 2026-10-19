import json, re
from pathlib import Path

p = Path(__file__).parent
old = json.loads((p/'database-before.json').read_text(encoding='utf-8-sig'))
new = json.loads((p/'extracted.json').read_text(encoding='utf-8'))
# Explicit semantic mapping: retain compliance IDs, not their old numbers.
mapping = {f'1.1.{i}': f'1.1.{i}' for i in range(1,12)}
mapping.update({f'1.2.{i}': f'1.2.{i}' for i in range(1,4)})
mapping.update({f'1.2.{i+3}': f'1.3.{i}' for i in range(1,7)})
mapping.update({f'1.3.{i}': f'1.3.{i+6}' for i in range(1,8)})
mapping.update({f'1.3.{i+7}': f'1.4.{i}' for i in range(1,9)})
for target, source, count in [(4,5,4),(5,6,2),(6,7,4),(7,8,2),(8,9,1),(9,10,1)]:
    mapping.update({f'1.{target}.{i}': f'1.{source}.{i}' for i in range(1,count+1)})
assert set(mapping.values()) == {x['complianceNumber'] for x in old['compliances']}
assert len(mapping)==49
old_co = {x['complianceNumber']:x for x in old['compliances']}
old_e = {(x['complianceId'],x['evidenceNumber']):x for x in old['evidence']}
def norm(s):
    return re.sub(r'[^a-z0-9]', '', s.lower())
for parent, number, text in new['evidence']:
    if parent in mapping:
        e = old_e.get((old_co[mapping[parent]]['complianceId'],number))
        if e is None or norm(e['evidenceSummary']) != norm(text):
            print('EVIDENCE DIFFERENCE',parent,number,'OLD',e and e['evidenceSummary'],'NEW',text)
print('Removed evidence', [(mapping[n],e['evidenceNumber']) for n in mapping for e in old['evidence'] if e['complianceId']==old_co[mapping[n]]['complianceId'] and not any(a==n and b==e['evidenceNumber'] for a,b,_ in new['evidence'])])

def q(x):
    return "'"+str(x).replace("'","''")+"'"
def values(rows):
    return ',\n'.join('('+','.join(q(x) for x in row)+')' for row in rows)
# Keep criterion IDs for equivalent sections; merge former Leadership and Management.
criterion_map = {'1.1':'1.1','1.2':'1.2','1.3':'1.3','1.4':'1.5',
                 '1.5':'1.6','1.6':'1.7','1.7':'1.8','1.8':'1.9','1.9':'1.10'}
criterion_ids = {x['criterionNumber']:x['criterionId'] for x in old['criteria']}
e_rows=[]
for parent, number, text in new['evidence']:
    old_number = {'1':'2','2':'1'}.get(number,number) if parent=='1.1.1' else number
    previous = old_e.get((old_co[mapping[parent]]['complianceId'],old_number)) if parent in mapping else None
    e_rows.append((parent,number,text,previous['evidenceId'] if previous else 0))
assert len([e for e in e_rows if e[3]])==112
sql='''BEGIN;
SET LOCAL lock_timeout='5s';
LOCK TABLE standards,criteria,compliances,evidence,"complianceAssessments","complianceEvidenceChecks","surveyorReports","surveyorReportReopens","surveyorStandardSummaries","surveyStandardAssignments","surveyToolkitSnapshotCompliances","surveyToolkitTemplateCompliances" IN SHARE ROW EXCLUSIVE MODE;
CREATE TABLE standard1_backup_20260925 (table_name text NOT NULL, row_data jsonb NOT NULL);
CREATE TEMP TABLE old_c AS SELECT * FROM criteria WHERE "standardId"=1;
CREATE TEMP TABLE old_co AS SELECT co.* FROM compliances co JOIN old_c USING("criterionId");
CREATE TEMP TABLE old_a AS SELECT a.* FROM "complianceAssessments" a JOIN old_co USING("complianceId");
CREATE TEMP TABLE affected AS SELECT DISTINCT "surveyId","surveyorId" FROM old_a;
CREATE TEMP TABLE full_surveys AS SELECT "surveyId",min("surveyorId") AS "surveyorId" FROM old_a GROUP BY "surveyId" HAVING count(DISTINCT "complianceId")=49 AND count(DISTINCT "surveyorId")=1;
CREATE TEMP TABLE full_snapshots AS SELECT "surveyToolkitSnapshotId" FROM "surveyToolkitSnapshotCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co) GROUP BY "surveyToolkitSnapshotId" HAVING count(DISTINCT "complianceId")=49;
CREATE TEMP TABLE full_templates AS SELECT "surveyToolkitTemplateId" FROM "surveyToolkitTemplateCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co) GROUP BY "surveyToolkitTemplateId" HAVING count(DISTINCT "complianceId")=49;
CREATE TEMP TABLE other_work AS SELECT * FROM "complianceAssessments" WHERE "complianceId" NOT IN (SELECT "complianceId" FROM old_co);
'''
backups={
    'standards':'"standardId"=1','criteria':'"standardId"=1',
    'compliances':'"complianceId" IN (SELECT "complianceId" FROM old_co)',
    'evidence':'"complianceId" IN (SELECT "complianceId" FROM old_co)',
    'complianceAssessments':'"complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a)',
    'complianceEvidenceChecks':'"complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a)',
    'surveyorStandardSummaries':'"standardId"=1',
    'surveyorReports':'("surveyId","surveyorId") IN (SELECT * FROM affected)',
    'surveyToolkitSnapshotCompliances':'"complianceId" IN (SELECT "complianceId" FROM old_co)',
    'surveyToolkitTemplateCompliances':'"complianceId" IN (SELECT "complianceId" FROM old_co)'}
for table,where in backups.items():
    sql+=f'INSERT INTO standard1_backup_20260925 SELECT {q(table)},to_jsonb(t) FROM "{table}" t WHERE {where};\n'
# Abort if the framework changed after the comparison; no overwrite of concurrent edits.
for table in ['criteria','compliances','evidence']:
    expected=json.dumps(old[table],ensure_ascii=False)
    sql+=f'''DO $$ BEGIN IF EXISTS ((SELECT row_data FROM standard1_backup_20260925 WHERE table_name={q(table)} EXCEPT SELECT value FROM jsonb_array_elements({q(expected)}::jsonb)) UNION ALL (SELECT value FROM jsonb_array_elements({q(expected)}::jsonb) EXCEPT SELECT row_data FROM standard1_backup_20260925 WHERE table_name={q(table)})) THEN RAISE EXCEPTION 'Framework changed since comparison'; END IF; END $$;\n'''
sql+='CREATE TEMP TABLE new_c(number text,title text,id integer);\nINSERT INTO new_c VALUES '+values([(n,t,criterion_ids[criterion_map[n]]) for n,t in new['criteria']])+';\n'
sql+='CREATE TEMP TABLE new_co(number text,summary text,id integer);\nINSERT INTO new_co VALUES '+values([(n,t,old_co[mapping[n]]['complianceId'] if n in mapping else 0) for n,t in new['compliances']])+';\n'
sql+='CREATE TEMP TABLE new_e(parent text,number text,summary text,id integer);\nINSERT INTO new_e VALUES '+values(e_rows)+';\n'
sql+='''UPDATE criteria SET "criterionNumber"='import-std1-'||"criterionId" WHERE "standardId"=1;
UPDATE compliances SET "complianceNumber"='import-std1-'||"complianceId" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
UPDATE evidence SET "evidenceNumber"='import-std1-'||"evidenceId" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
UPDATE criteria c SET "criterionNumber"=n.number,"criterionTitle"=n.title FROM new_c n WHERE c."criterionId"=n.id;
UPDATE compliances co SET "complianceNumber"=n.number,"complianceSummary"=n.summary,"criterionId"=c.id FROM new_co n JOIN new_c c ON c.number=split_part(n.number,'.',1)||'.'||split_part(n.number,'.',2) WHERE co."complianceId"=n.id;
DELETE FROM criteria WHERE "standardId"=1 AND "criterionId" NOT IN (SELECT id FROM new_c);
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT n.number,n.summary,c.id,true FROM new_co n JOIN new_c c ON c.number=split_part(n.number,'.',1)||'.'||split_part(n.number,'.',2) WHERE n.id=0;
UPDATE new_co n SET id=co."complianceId" FROM compliances co JOIN criteria c USING("criterionId") WHERE c."standardId"=1 AND co."complianceNumber"=n.number;
UPDATE evidence e SET "evidenceNumber"=n.number,"evidenceSummary"=n.summary FROM new_e n WHERE e."evidenceId"=n.id;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT n.number,n.summary,c.id,true FROM new_e n JOIN new_co c ON c.number=n.parent WHERE n.id=0;
UPDATE standards SET "standardTitle"='Governance, Leadership and Management',"standardSummary"='The Health Service Organisation has formal governance structures; strategic and operational plans, is committed to improving health services delivery performance, the management of corporate and clinical public health risk and managing a skilled and competent workforce.' WHERE "standardId"=1;
-- Preserve narrative, risk and evidence checks; require reconfirmation of the changed requirement.
UPDATE "complianceAssessments" SET "scoreId"=NULL WHERE "complianceId"=(SELECT id FROM new_co WHERE number='1.1.10');
INSERT INTO "complianceAssessments" ("surveyId","surveyorId","complianceId") SELECT f."surveyId",f."surveyorId",n.id FROM full_surveys f CROSS JOIN new_co n WHERE n.number IN ('1.4.5','1.4.6');
INSERT INTO "complianceEvidenceChecks" ("complianceAssessmentId","evidenceId","isChecked") SELECT a."complianceAssessmentId",e."evidenceId",false FROM "complianceAssessments" a JOIN new_co n ON n.id=a."complianceId" JOIN evidence e ON e."complianceId"=n.id WHERE n.number IN ('1.4.5','1.4.6');
INSERT INTO "surveyToolkitSnapshotCompliances" ("surveyToolkitSnapshotId","complianceId") SELECT s."surveyToolkitSnapshotId",n.id FROM full_snapshots s CROSS JOIN new_co n WHERE n.number IN ('1.4.5','1.4.6');
INSERT INTO "surveyToolkitTemplateCompliances" ("surveyToolkitTemplateId","complianceId") SELECT t."surveyToolkitTemplateId",n.id FROM full_templates t CROSS JOIN new_co n WHERE n.number IN ('1.4.5','1.4.6');
CREATE TEMP TABLE reopen AS SELECT r."surveyorReportId" FROM "surveyorReports" r WHERE r."isSubmitted" AND (EXISTS (SELECT 1 FROM full_surveys f WHERE f."surveyId"=r."surveyId" AND f."surveyorId"=r."surveyorId") OR EXISTS (SELECT 1 FROM old_a a JOIN new_co n ON n.id=a."complianceId" WHERE n.number='1.1.10' AND a."surveyId"=r."surveyId" AND a."surveyorId"=r."surveyorId"));
INSERT INTO "surveyorReportReopens" ("surveyorReportId",reason,"reopenedByUsername","reopenedAt","previousSubmittedAt") SELECT r."surveyorReportId",'Standard 1 updated: review 1.1.10 and complete new 1.4.5 and 1.4.6 where included. Previous narrative retained.','Standard 1 import',now(),r."submittedAt" FROM "surveyorReports" r JOIN reopen USING("surveyorReportId");
UPDATE "surveyorReports" SET "isSubmitted"=false,"updatedAt"=now() WHERE "surveyorReportId" IN (SELECT * FROM reopen);
DO $$ BEGIN
 IF (SELECT count(*) FROM criteria WHERE "standardId"=1)<>9 OR (SELECT count(*) FROM new_co)<>51 OR (SELECT count(*) FROM evidence WHERE "complianceId" IN (SELECT id FROM new_co))<>115 THEN RAISE EXCEPTION 'Counts failed'; END IF;
 IF EXISTS (SELECT 1 FROM new_co n LEFT JOIN compliances c ON c."complianceId"=n.id AND c."complianceNumber"=n.number AND c."complianceSummary"=n.summary WHERE c."complianceId" IS NULL) THEN RAISE EXCEPTION 'Compliance content mismatch'; END IF;
 IF EXISTS (SELECT 1 FROM new_e n JOIN new_co c ON c.number=n.parent LEFT JOIN evidence e ON e."complianceId"=c.id AND e."evidenceNumber"=n.number AND e."evidenceSummary"=n.summary WHERE e."evidenceId" IS NULL) THEN RAISE EXCEPTION 'Evidence content mismatch'; END IF;
 IF (SELECT count(*) FROM "complianceAssessments" WHERE "complianceId" IN (SELECT id FROM new_co))<>(SELECT count(*) FROM old_a)+2*(SELECT count(*) FROM full_surveys) THEN RAISE EXCEPTION 'Assessment count mismatch'; END IF;
 IF EXISTS (SELECT 1 FROM "complianceAssessments" a JOIN new_co n ON n.id=a."complianceId" WHERE n.number IN ('1.4.5','1.4.6') AND (a."scoreId" IS NOT NULL OR a."riskRatingId" IS NOT NULL OR a."complianceComments" IS NOT NULL)) THEN RAISE EXCEPTION 'New requirements must be blank'; END IF;
 IF EXISTS (SELECT 1 FROM old_a o LEFT JOIN "complianceAssessments" a USING("complianceAssessmentId") WHERE a."complianceAssessmentId" IS NULL OR (to_jsonb(o)-'scoreId') IS DISTINCT FROM (to_jsonb(a)-'scoreId') OR (o."complianceId"<>(SELECT id FROM new_co WHERE number='1.1.10') AND o."scoreId" IS DISTINCT FROM a."scoreId")) THEN RAISE EXCEPTION 'Existing work changed unexpectedly'; END IF;
 IF EXISTS (SELECT 1 FROM standard1_backup_20260925 b LEFT JOIN "complianceEvidenceChecks" e ON to_jsonb(e)=b.row_data WHERE b.table_name='complianceEvidenceChecks' AND e."complianceEvidenceCheckId" IS NULL) THEN RAISE EXCEPTION 'Evidence checks changed'; END IF;
 IF EXISTS ((SELECT * FROM other_work EXCEPT SELECT a.* FROM "complianceAssessments" a WHERE a."complianceId" NOT IN (SELECT id FROM new_co)) UNION ALL (SELECT a.* FROM "complianceAssessments" a WHERE a."complianceId" NOT IN (SELECT id FROM new_co) EXCEPT SELECT * FROM other_work)) THEN RAISE EXCEPTION 'Other standards changed'; END IF;
 IF EXISTS (SELECT 1 FROM standard1_backup_20260925 b LEFT JOIN "surveyorStandardSummaries" s ON to_jsonb(s)=b.row_data WHERE b.table_name='surveyorStandardSummaries' AND s."standardId" IS NULL) THEN RAISE EXCEPTION 'Summation changed'; END IF;
END $$;
SELECT json_build_object('criteria',9,'compliances',51,'evidence',115,'preservedAssessments',(SELECT count(*) FROM old_a),'scoresRequiringReview',(SELECT count(*) FROM old_a WHERE "scoreId" IS NOT NULL AND "complianceId"=(SELECT id FROM new_co WHERE number='1.1.10')),'newAssessments',2*(SELECT count(*) FROM full_surveys),'expandedSurveys',(SELECT json_agg("surveyId") FROM full_surveys),'reopenedReports',(SELECT count(*) FROM reopen),'backupRows',(SELECT count(*) FROM standard1_backup_20260925));
COMMIT;
'''
(p/'import.sql').write_text(sql,encoding='utf-8')
(p/'dry-run.sql').write_text(sql.replace('COMMIT;','ROLLBACK;'),encoding='utf-8')
