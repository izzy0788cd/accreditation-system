"""Extract the supplied questionnaire and prepare an additive, guarded SQL import."""
import argparse
import hashlib
import json
import pathlib
import re
from docx import Document

parser = argparse.ArgumentParser()
parser.add_argument('--unfinished', choices=['omit', 'keep'], required=True)
args = parser.parse_args()
source = pathlib.Path('C:/Users/ishma/Downloads/Questionnaires for Lae/STANDARD 26 Blood product PB.docx')
out = pathlib.Path(__file__).resolve().parent
doc = Document(source)
rows = [[cell.text.strip() for cell in row.cells] for row in doc.tables[0].rows]
criteria, compliances, evidence = [], [], []
criterion = compliance = None
for row in rows[6:]:
    number = row[0]
    if re.fullmatch(r'26\.\d+', number):
        criterion = number
        criteria.append([number, row[1].capitalize()])
    elif re.fullmatch(r'26\.\d+\.\d+', number):
        compliance = number
        compliances.append([criterion, number, row[1]])
    elif re.fullmatch(r'\d+\.?', row[1]) and row[2]:
        evidence.append([compliance, row[1].rstrip('.'), row[2]])
assert len(criteria) == 5 and len(compliances) == 6 and len(evidence) == 23
assert next(e for e in evidence if e[:2] == ['26.4.1', '1'])[2] == 'Evidence that.'
raw = dict(source=source.name, sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
           standardNumber='26', standardTitle='Blood products',
           standardSummary=rows[1][0] + '\n\nSource references\n' + rows[3][0],
           criteria=criteria, compliances=compliances, evidence=evidence,
           decisions=dict(unfinishedEvidence=args.unfinished, criterion26_4='Patient education (main questionnaire heading)'))
(out / 'source-extracted.json').write_text(json.dumps(raw, ensure_ascii=False, indent=2), encoding='utf-8')
if args.unfinished == 'omit':
    evidence = [e for e in evidence if e[:2] != ['26.4.1', '1']]

def quote(value):
    return "'" + value.replace("'", "''") + "'"

def values(items):
    return ',\n'.join('(' + ','.join(quote(v) for v in item) + ')' for item in items)

sql = '''BEGIN;
SET LOCAL lock_timeout = '5s';
DO $$ BEGIN
IF EXISTS (SELECT 1 FROM standards WHERE "standardNumber"='26' OR lower("standardTitle") LIKE '%blood%') THEN
 RAISE EXCEPTION 'Blood products standard already exists; stop and review'; END IF;
IF NOT EXISTS (SELECT 1 FROM functions WHERE "functionId"=4 AND "functionTitle"='Essential Clinical Care')
 OR NOT EXISTS (SELECT 1 FROM components WHERE "componentId"=6 AND "componentName"='Essential Clinical Care') THEN
 RAISE EXCEPTION 'Parent mapping changed'; END IF;
END $$;
CREATE TEMP TABLE import_c (number text PRIMARY KEY, title text NOT NULL) ON COMMIT DROP;
CREATE TEMP TABLE import_co (criterion_number text NOT NULL, number text PRIMARY KEY, summary text NOT NULL) ON COMMIT DROP;
CREATE TEMP TABLE import_e (compliance_number text NOT NULL, number text NOT NULL, summary text NOT NULL, PRIMARY KEY(compliance_number,number)) ON COMMIT DROP;
'''
sql += 'INSERT INTO import_c VALUES\n' + values(criteria) + ';\n'
sql += 'INSERT INTO import_co VALUES\n' + values(compliances) + ';\n'
sql += 'INSERT INTO import_e VALUES\n' + values(evidence) + ';\n'
sql += 'INSERT INTO standards ("standardNumber","standardTitle","standardSummary","functionId","componentId") VALUES (' + ','.join(quote(raw[k]) for k in ['standardNumber','standardTitle','standardSummary']) + ',4,6);\n'
sql += '''INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable")
 SELECT x.number,x.title,s."standardId",true FROM import_c x CROSS JOIN standards s WHERE s."standardNumber"='26';
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable")
 SELECT x.number,x.summary,c."criterionId",true FROM import_co x JOIN criteria c ON c."criterionNumber"=x.criterion_number
 JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26';
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable")
 SELECT x.number,x.summary,co."complianceId",true FROM import_e x JOIN compliances co ON co."complianceNumber"=x.compliance_number
 JOIN criteria c ON c."criterionId"=co."criterionId" JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26';
DO $$ BEGIN
IF (SELECT count(*) FROM import_c x JOIN criteria c ON c."criterionNumber"=x.number AND c."criterionTitle"=x.title
 JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26')<>5 THEN RAISE EXCEPTION 'Criterion verification failed'; END IF;
IF (SELECT count(*) FROM import_co x JOIN compliances co ON co."complianceNumber"=x.number AND co."complianceSummary"=x.summary
 JOIN criteria c ON c."criterionId"=co."criterionId" AND c."criterionNumber"=x.criterion_number
 JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26')<>6 THEN RAISE EXCEPTION 'Compliance verification failed'; END IF;
IF (SELECT count(*) FROM import_e x JOIN compliances co ON co."complianceNumber"=x.compliance_number
 JOIN criteria c ON c."criterionId"=co."criterionId" JOIN standards s ON s."standardId"=c."standardId"
 JOIN evidence e ON e."complianceId"=co."complianceId" AND e."evidenceNumber"=x.number AND e."evidenceSummary"=x.summary
 WHERE s."standardNumber"='26')<>EXPECTED_EVIDENCE THEN RAISE EXCEPTION 'Evidence verification failed'; END IF;
END $$;
COMMIT;
SELECT json_build_object('standardId',s."standardId",'standardNumber',s."standardNumber",'title',s."standardTitle",
 'criteria',count(distinct c."criterionId"),'compliances',count(distinct co."complianceId"),'evidence',count(e."evidenceId"), 'importedAt',CURRENT_TIMESTAMP)
 FROM standards s JOIN criteria c ON c."standardId"=s."standardId" JOIN compliances co ON co."criterionId"=c."criterionId"
 JOIN evidence e ON e."complianceId"=co."complianceId" WHERE s."standardNumber"='26' GROUP BY s."standardId";
'''.replace('EXPECTED_EVIDENCE', str(len(evidence)))
(out / 'import.sql').write_text(sql, encoding='utf-8')
print(f'Prepared only: 5 criteria, 6 compliances, {len(evidence)} evidence. No database changes made.')
