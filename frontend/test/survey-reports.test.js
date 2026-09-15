import test from 'node:test';
import assert from 'node:assert/strict';
import { assessmentStatus, summariseReport, canGenerateReports } from '../src/utils/surveyReports.js';
test('report access remains Admin-only until Preceptor is enabled', () => {
  assert.equal(canGenerateReports('Admin'), true);
  for (const role of ['Preceptor','Surveyor','Team Lead','Viewer',null]) assert.equal(canGenerateReports(role), false);
});
test('unassessed, N/A and four-point ratings stay distinct', () => {
  const rows = [{isApplicable:true,scoreId:null,scoreValue:null},{isApplicable:true,scoreId:7,scoreValue:null},{isApplicable:true,scoreId:1,scoreValue:1},{isApplicable:true,scoreId:3,scoreValue:4},{isApplicable:false,scoreId:3,scoreValue:4}];
  assert.deepEqual(rows.map(assessmentStatus), ['Unassessed','Not applicable','Poor achievement','Full achievement','Not applicable']);
  assert.deepEqual(summariseReport(rows), {total:5,unassessed:1,notApplicable:2,scored:2,score:63,dummy:false});
});
test('empty and unscored reports have no percentage; dummy data is labelled', () => {
  assert.equal(summariseReport([]).score, null);
  assert.equal(summariseReport([{isApplicable:true,scoreId:null}]).score, null);
  assert.equal(summariseReport([{isApplicable:true,complianceComments:'DUMMY SURVEY — not actual findings'}]).dummy, true);
});

import { isPriorityFinding, detailItems, compareAssessment, compareScope } from '../src/utils/surveyReports.js';
const assessed = (id, score, extra = {}) => ({ complianceId: id, isApplicable: true, scoreId: score + 1, scoreValue: score, ...extra });
test('findings-only keeps gaps and high risks without mutating summary scope', () => {
  const items = [assessed(1,4), assessed(2,2), assessed(3,1), assessed(4,4,{riskSeverity:3}), assessed(5,4,{riskSeverity:4,isApplicable:false}), assessed(6,1,{scoreId:null,scoreValue:null})];
  assert.deepEqual(detailItems({items,mode:'findings'}).map(i=>i.complianceId),[2,3,4]);
  assert.equal(items.length,6);
  assert.equal(detailItems({items,mode:'full'}),items);
  assert.equal(isPriorityFinding(assessed(7,4,{riskLabel:'Extreme'})),true);
});
test('comparison uses matching IDs and excludes missing, unassessed and N/A pairs', () => {
  assert.equal(compareAssessment(assessed(1,1),assessed(1,4)).delta,-3);
  assert.equal(compareAssessment(assessed(1,4),undefined).delta,null);
  assert.equal(compareAssessment(assessed(1,4),assessed(1,1,{scoreId:null,scoreValue:null})).delta,null);
  assert.equal(compareAssessment(assessed(1,4),assessed(1,1,{scoreId:7,scoreValue:null})).label,'Applicability differs');
  const result=compareScope([assessed(1,1),assessed(2,4),assessed(3,2)], [assessed(2,4),assessed(1,4),assessed(99,1)]);
  assert.deepEqual(result,{compared:2,differing:1,delta:-37});
  assert.deepEqual(compareScope([],[]),{compared:0,differing:0,delta:null});
});
