import json,base64,hmac,hashlib,time,urllib.request,urllib.error
from pathlib import Path
root=Path.cwd(); cfg=json.loads((root/'backend/appsettings.json').read_text(encoding='utf-8-sig'))['Jwt']
def enc(x):return base64.urlsafe_b64encode(json.dumps(x).encode()).rstrip(b'=')
def token(role):
 p=enc({'alg':'HS256'})+b'.'+enc({'iss':cfg['Issuer'],'aud':cfg['Audience'],'exp':int(time.time())+300,'role':role,'unique_name':'report-version-verification'})
 return (p+b'.'+base64.urlsafe_b64encode(hmac.new(cfg['Key'].encode(),p,hashlib.sha256).digest()).rstrip(b'=')).decode()
def request(path,method='GET',body=None,role='Admin'):
 req=urllib.request.Request('http://localhost:5159/api/reports/surveys'+path,method=method,data=json.dumps(body).encode() if body is not None else None,headers={'Content-Type':'application/json',**({'Authorization':'Bearer '+token(role)} if role else {})})
 try:
  with urllib.request.urlopen(req,timeout=30) as r:
   raw=r.read();return r.status,json.loads(raw) if raw else None,r.headers
 except urllib.error.HTTPError as e:return e.code,e.read().decode(),e.headers
for role,code in [(None,401),('Viewer',403),('Surveyor',403),('Team Lead',403),('Preceptor',403)]:
 assert request('/1/versions',role=role)[0]==code
 assert request('/1/versions',method='POST',body={},role=role)[0]==code
print('Version endpoints enforce Admin-only access.')
for sid,label in [(1,'internal'),(2,'external')]:
 code,report,_=request('/'+str(sid));assert code==200
 (root/f'data/report-validation/{label}.json').write_text(json.dumps(report),encoding='utf-8')
assert request('/1/versions/2147483647')[0]==404
report=json.loads((root/'data/report-validation/internal.json').read_text())
item=report['items'][0]
body={'standardIds':[item['standardId']],'included':['summary','standards','findings','evidence','actions'],'mode':'findings','actions':[{'complianceId':item['complianceId'],'recommendation':'TEST ONLY: verification action.','owner':'Test owner','dueDate':'2026-12-01'}],'reviewerName':'TEST ONLY','reviewNotes':'Automated report verification; not an approval.'}
assert request('/1/versions','POST',{**body,'standardIds':[2147483647]})[0]==400
assert request('/1/versions','POST',{**body,'actions':[None]})[0]==400
created=[]
try:
 code,saved,headers=request('/1/versions','POST',body)
 assert code==201,(code,saved)
 location=headers['Location'];vid=int(location.rsplit('/',1)[1]);created.append(vid)
 assert all(i['standardId']==item['standardId'] for i in saved['items'])
 assert saved['actions']==body['actions']
 assert saved['items'][0]['complianceSummary']==item['complianceSummary']
 code,reopened,_=request('/1/versions/'+str(vid));assert code==200 and reopened==saved
 code,saved2,headers=request('/1/versions','POST',{**body,'reviewNotes':'Different second version'})
 assert code==201,(code,saved2)
 created.append(int(headers['Location'].rsplit('/',1)[1]))
 assert saved2['savedVersion']['versionNumber']==saved['savedVersion']['versionNumber']+1
 assert request('/1/versions/'+str(vid))[1]==saved
 assert request('/1/versions/'+str(vid),'PUT',body)[0]==405
 print('Saved/reopened versions, immutable first version, validation and sequential numbering passed.')
finally:
 (root/'data/report-validation/cleanup.sql').write_text('DELETE FROM "surveyReportVersions" WHERE "reportVersionId" IN ('+','.join(map(str,created or [-1]))+') AND "createdBy"=\'report-version-verification\';',encoding='utf-8')
