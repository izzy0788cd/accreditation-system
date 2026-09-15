from pathlib import Path
from zipfile import ZipFile
import xml.etree.ElementTree as E,json,re,hashlib,sys
sys.stdout.reconfigure(encoding='utf-8')
OUT=Path('data/imports/standards-23m-q');NS={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'};W='{'+NS['w']+'}'
def roman(n):
 s=''
 for v,c in [(1000,'m'),(900,'cm'),(500,'d'),(400,'cd'),(100,'c'),(90,'xc'),(50,'l'),(40,'xl'),(10,'x'),(9,'ix'),(5,'v'),(4,'iv'),(1,'i')]:
  while n>=v:s+=c;n-=v
 return s
def fmt(n,f):
 if f=='decimal':return str(n)
 if f in ['lowerRoman','upperRoman']:return roman(n).upper() if f=='upperRoman' else roman(n)
 if f in ['lowerLetter','upperLetter']:
  s=''
  while n:n,q=divmod(n-1,26);s=chr(97+q)+s
  return s.upper() if f=='upperLetter' else s
 raise ValueError(f)
all_data=[]
for L in 'MNPQ':
 raw=json.loads((OUT/f'23{L}.raw.json').read_text(encoding='utf-8'));p=Path(raw['source'])
 with ZipFile(p) as z:doc=E.fromstring(z.read('word/document.xml'));nums=E.fromstring(z.read('word/numbering.xml'))
 counters={}
 def lvl(nid,level):
  num=nums.find(f'w:num[@w:numId="{nid}"]',NS);aid=num.find('w:abstractNumId',NS).get(W+'val')
  override=num.find(f'w:lvlOverride[@w:ilvl="{level}"]',NS)
  base=nums.find(f'w:abstractNum[@w:abstractNumId="{aid}"]/w:lvl[@w:ilvl="{level}"]',NS)
  if override is not None and override.find('w:lvl',NS) is not None:base=override.find('w:lvl',NS)
  start=int(base.find('w:start',NS).get(W+'val'))
  if override is not None and override.find('w:startOverride',NS) is not None:start=int(override.find('w:startOverride',NS).get(W+'val'))
  return base,start
 def para(p):
  txt=''.join(t.text or '' if t.tag==W+'t' else '\t' if t.tag==W+'tab' else '\n' for t in p.iter() if t.tag in [W+'t',W+'tab',W+'br',W+'cr'])
  pr=p.find('w:pPr/w:numPr',NS)
  if pr is not None:
   nid=pr.find('w:numId',NS).get(W+'val');el=pr.find('w:ilvl',NS);level=int(el.get(W+'val')) if el is not None else 0
   base,start=lvl(nid,level);key=(nid,level);counters[key]=counters.get(key,start-1)+1
   for k in list(counters):
    if k[0]==nid and k[1]>level:del counters[k]
   f=base.find('w:numFmt',NS).get(W+'val');label=base.find('w:lvlText',NS).get(W+'val')
   if f=='bullet':label='•'
   else:
    for lev in range(level+1):
     bl,bs=lvl(nid,lev);label=label.replace('%'+str(lev+1),fmt(counters.get((nid,lev),bs),bl.find('w:numFmt',NS).get(W+'val')))
   txt='  '*level+label+' '+txt
  return txt.rstrip()
 tables=[[[ '\n'.join(para(p) for p in cell.findall('w:p',NS)).strip() for cell in row.findall('w:tc',NS)] for row in table.findall('w:tr',NS)] for table in doc.findall('w:body/w:tbl',NS)]
 number='23'+L.lower();title=tables[1][0][0].split(':',1)[1].strip().capitalize()
 data={'sourceFile':str(p),'sourceSha256':hashlib.sha256(p.read_bytes()).hexdigest(),'functionNumber':'4','componentNumber':'6','standardNumber':number,'standardTitle':title,'standardSummary':tables[0][0][0].capitalize()+'\n'+re.sub(r'^STANDARD:\s*','',tables[0][1][0]),'sourceReferences':tables[0][3][0],'criteria':[],'notes':[]}
 criterion=None;co=None;consumed=[]
 for rn,row in enumerate(tables[1][6:],6):
  if len(row)==2 and re.fullmatch(r'23[a-z]\.\d+',row[0]):
   assert row[0].startswith(number+'.'),row
   criterion={'criterionNumber':row[0],'criterionTitle':row[1].capitalize(),'guidance':'','compliances':[]};data['criteria'].append(criterion);co=None
  elif len(row)==1:
   assert criterion is not None and co is None,(rn,row)
   criterion['guidance']+='\n'+row[0]
  elif len(row)>=7 and re.fullmatch(r'23[a-z]\.\d+\.\d+',row[0]):
   fixes={('M',208):'23m.5.3',('N',136):'23n.4.4',('Q',135):'23q.4.11'}
   if (L,rn) in fixes:
    original=row[0];row[0]=fixes[L,rn];data['notes'].append(f'Corrected source numbering {original} to {row[0]} under its printed criterion heading (table row {rn+1}).')
   assert row[0].startswith(criterion['criterionNumber']+'.'),(rn,row)
   assert not any(row[2:]),(rn,row)
   co={'complianceNumber':row[0],'complianceSummary':row[1],'evidence':[]};criterion['compliances'].append(co)
  elif len(row)==2 and row[1]=='Evidence of Compliance':pass
  elif len(row)>=9 and row[0]=='' and re.fullmatch(r'\d+\.',row[1]):
   assert co is not None and row[2] and not any(row[3:]),(rn,row)
   co['evidence'].append({'evidenceNumber':row[1].rstrip('.'),'evidenceSummary':row[2]})
  elif not any(row):pass
  else:raise ValueError((L,rn,row))
  consumed.append(rn)
 assert len(data['criteria'])==5
 for c in data['criteria']:
  c['guidance']=c['guidance'].strip();seen=set()
  for co in c['compliances']:
   assert co['complianceNumber'] not in seen,co['complianceNumber'];seen.add(co['complianceNumber']);seen_ev=set()
   for e in co['evidence']:
    assert e['evidenceNumber'] not in seen_ev,(co['complianceNumber'],e);seen_ev.add(e['evidenceNumber'])
   assert co['evidence'],co['complianceNumber']
  nums_co=[int(x['complianceNumber'].split('.')[-1]) for x in c['compliances']]
  missing=sorted(set(range(1,max(nums_co)+1))-set(nums_co))
  if missing:data['notes'].append(f"Source numbering gaps under {c['criterionNumber']}: {missing}; retained as printed.")
 if tables[1][1][0].strip():data['standardSummary']+='\n\nService scope\n'+tables[1][1][0].strip()
 if tables[1][3][0].strip():data['sourceReferences']+='\n'+tables[1][3][0].strip()
 titles={'M':'Dental services','N':'Cancer services (oncology)','P':'Pathology','Q':'Mortuary services'}
 data['standardTitle']=titles[L]
 data['standardSummary']+='\n\nSource references\n'+data['sourceReferences']+'\n\nCriterion guidance\n'+'\n\n'.join(c['criterionNumber']+' '+c['criterionTitle']+'\n'+c['guidance'] for c in data['criteria'])
 all_data.append(data)
 print(number,len(data['criteria']),sum(len(c['compliances']) for c in data['criteria']),sum(len(co['evidence']) for c in data['criteria'] for co in c['compliances']),data['notes'])
 (OUT/f'{number}.extracted.json').write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
(OUT/'batch.json').write_text(json.dumps(all_data,ensure_ascii=False,indent=2),encoding='utf-8')