from pathlib import Path
import json
P=Path('data/imports/standards-23g-l');data=json.loads((P/'batch.json').read_text(encoding='utf-8'))
def q(s):return "'"+s.replace("'","''")+"'"
sql=['BEGIN;','SET LOCAL lock_timeout = \'5s\';',"DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM functions WHERE \"functionId\"=4 AND \"functionNumber\"='4') OR NOT EXISTS(SELECT 1 FROM components WHERE \"componentId\"=6 AND \"componentNumber\"='6') THEN RAISE EXCEPTION 'Parent mapping changed'; END IF; IF EXISTS(SELECT 1 FROM standards WHERE lower(\"standardNumber\") IN ('23g','23h','23j','23k','23l')) THEN RAISE EXCEPTION 'Target standard already exists; review before importing'; END IF; END $$;"]
tables={'s':('standard_number,title,summary',[]),'c':('standard_number,number,title',[]),'co':('standard_number,criterion_number,number,summary',[]),'e':('standard_number,criterion_number,compliance_number,number,summary',[])}
for d in data:
 n=d['standardNumber'];tables['s'][1].append((n,d['standardTitle'],d['standardSummary']))
 for c in d['criteria']:
  tables['c'][1].append((n,c['criterionNumber'],c['criterionTitle']))
  for co in c['compliances']:
   tables['co'][1].append((n,c['criterionNumber'],co['complianceNumber'],co['complianceSummary']))
   for e in co['evidence']:tables['e'][1].append((n,c['criterionNumber'],co['complianceNumber'],e['evidenceNumber'],e['evidenceSummary']))
for t,(cols,rows) in tables.items():
 sql.append('CREATE TEMP TABLE import_'+t+' ('+', '.join(c+' text NOT NULL' for c in cols.split(','))+') ON COMMIT DROP;')
 sql.append('INSERT INTO import_'+t+' VALUES\n'+',\n'.join('('+','.join(map(q,row))+')' for row in rows)+';')
sql.extend(['''INSERT INTO standards ("standardNumber","standardTitle","standardSummary","functionId","componentId") SELECT standard_number,title,summary,4,6 FROM import_s;
INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable") SELECT x.number,x.title,s."standardId",true FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number;
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT x.number,x.summary,c."criterionId",true FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT x.number,x.summary,co."complianceId",true FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number;
DO $$ BEGIN
IF (SELECT count(*) FROM import_s x JOIN standards s ON s."standardNumber"=x.standard_number AND s."standardTitle"=x.title AND s."standardSummary"=x.summary AND s."functionId"=4 AND s."componentId"=6)<>5 THEN RAISE EXCEPTION 'Standard verification failed'; END IF;
IF (SELECT count(*) FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.number AND c."criterionTitle"=x.title AND c."isApplicable")<>25 THEN RAISE EXCEPTION 'Criterion verification failed'; END IF;
IF (SELECT count(*) FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.number AND co."complianceSummary"=x.summary AND co."isApplicable")<>187 THEN RAISE EXCEPTION 'Compliance verification failed'; END IF;
IF (SELECT count(*) FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number JOIN evidence e ON e."complianceId"=co."complianceId" AND e."evidenceNumber"=x.number AND e."evidenceSummary"=x.summary AND e."isApplicable")<>525 THEN RAISE EXCEPTION 'Evidence verification failed'; END IF;
END $$;
COMMIT;
SELECT json_build_object('standardNumber',s."standardNumber",'standardId',s."standardId",'criteria',count(distinct c."criterionId"),'compliances',count(distinct co."complianceId"),'evidence',count(e."evidenceId"),'importedAt',CURRENT_TIMESTAMP) FROM standards s JOIN criteria c ON c."standardId"=s."standardId" JOIN compliances co ON co."criterionId"=c."criterionId" JOIN evidence e ON e."complianceId"=co."complianceId" WHERE s."standardNumber" IN ('23g','23h','23j','23k','23l') GROUP BY s."standardId" ORDER BY s."standardNumber";'''])
(P/'import.sql').write_text('\n'.join(sql),encoding='utf-8')
notes=['# Standards 23g–23l import review','Function 4; Component 6. Source documents unmodified.','Criterion guidance and source references retained in standard summaries. Automatic Word list labels rendered as text; bullet glyphs normalized. Assessment columns and repeated summary sheets excluded.']
for d in data:
 notes+=['\n## '+d['standardNumber']+' '+d['standardTitle'],*d['notes']]
(P/'review.md').write_text('\n\n'.join(notes),encoding='utf-8')
print('Prepared',sum(len(v[1]) for v in tables.values()),'records for transaction; duplicate checks and exact text verification included.')
