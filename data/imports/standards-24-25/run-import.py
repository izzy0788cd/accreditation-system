import pathlib,os,subprocess,json
P=pathlib.Path('data/imports/standards-24-25')
v={}
for line in pathlib.Path('.env').read_text().splitlines():
 if '=' in line and not line.lstrip().startswith('#'):
  k,val=line.split('=',1);v[k.strip()]=val.strip().strip('\"').strip("'")
env=os.environ.copy();env['ConnectionStrings__AppDbContext']='Host=localhost;Port=5432;Database='+v['POSTGRES_DB']+';Username='+v['POSTGRES_USER']+';Password='+v['POSTGRES_PASSWORD']
def run(file):
 r=subprocess.run(['dotnet','data/dummy-survey/loader/bin/Debug/net10.0/loader.dll',str(P/file)],env=env,capture_output=True,text=True,timeout=60)
 if r.returncode:raise RuntimeError(r.stderr[:1500])
 return r.stdout
before=run('check-unchanged.sql');(P/'unchanged-before.json').write_text(before,encoding='utf-8')
receipt=run('import.sql');(P/'import-receipt.jsonl').write_text(receipt,encoding='utf-8');print(receipt)
after=run('check-unchanged.sql');assert json.loads(before)==json.loads(after),'Existing data changed';(P/'unchanged-after.json').write_text(after,encoding='utf-8')
print('Verified: existing standards, surveys, assessments and evidence checks unchanged.')
