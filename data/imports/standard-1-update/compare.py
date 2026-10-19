import json, re
from pathlib import Path
from difflib import SequenceMatcher
from docx import Document

root = Path(__file__).parent
doc = Document(r'C:/Users/ishma/Downloads/Questionnaires for Lae/Leadership  and Governance/Leadership Governance & Management.docx')
criteria, compliances, evidence = [], [], []
criterion = compliance = None
for row in doc.tables[1].rows:
    cells = list(dict.fromkeys(c.text.strip() for c in row.cells if c.text.strip()))
    if not cells:
        continue
    number = cells[0]
    if re.fullmatch(r'1\.\d+', number):
        criterion = number
        criteria.append([number, cells[1]])
    elif re.fullmatch(r'1\.\d+\.\d+', number):
        compliance = number
        assert number.rsplit('.', 1)[0] == criterion
        compliances.append([number, cells[1]])
    elif re.fullmatch(r'\d+\.?', number):
        evidence.append([compliance, number.rstrip('.'), cells[1]])
assert len({x[0] for x in compliances}) == len(compliances)
assert len({tuple(x[:2]) for x in evidence}) == len(evidence)
data = dict(criteria=criteria, compliances=compliances, evidence=evidence)
(root/'extracted.json').write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding='utf-8')
old = json.loads((root/'database-before.json').read_text(encoding='utf-8-sig'))
def norm(s):
    return re.sub(r'[^a-z0-9]', '', s.lower())
print('COUNTS old/new', [(k,len(old[k]),len(data[k])) for k in data])
print('ASSESSMENTS',sum(x['assessments'] for x in old['work']), 'RECORDED',sum(x['recorded'] for x in old['work']))
for number, text in compliances:
    match=max(old['compliances'], key=lambda x:SequenceMatcher(None,norm(text),norm(x['complianceSummary'])).ratio())
    ratio=SequenceMatcher(None,norm(text),norm(match['complianceSummary'])).ratio()
    print(number, '<-',match['complianceNumber'], round(ratio,3),text[:85])
print('SOURCE ISSUES',[(c,n,t) for c,n,t in evidence if len(t)<30])
