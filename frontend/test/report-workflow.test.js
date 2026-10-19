import test from "node:test";
import assert from "node:assert/strict";
import { reportCommentLabel, reportReadiness } from "../src/utils/surveyReports.js";
const complete = () => ({ workflowVersion: 2, survey: {}, items: [{standardId:1,isApplicable:true,scoreId:1,scoreValue:4}], summationStatus: [{standardId:1,surveyorId:7,saved:true,submitted:true}] });
const sections = ["summary","standards","findings","signoff"];
const issues = report => reportReadiness(report,[1],sections,"full");
test("report headings use scores, not score IDs, and respect N/A", () => {
  assert.deepEqual([1,2,3,4].map(scoreValue=>reportCommentLabel({isApplicable:true,scoreId:99,scoreValue})),["Recommendations","Recommendations","Comments","Commendations"]);
  assert.equal(reportCommentLabel({isApplicable:false,scoreId:99,scoreValue:4}),"Comments");
  assert.equal(reportCommentLabel({isApplicable:true,scoreId:null,scoreValue:4}),"Comments");
});
test("complete survey without consolidated narrative is ready; unassessed is blocked and N/A is allowed", () => {
  const report=complete(); assert.deepEqual(issues(report),[]);
  report.items[0].scoreId=null; assert.match(issues(report).join(" "),/scores/);
  report.items[0].isApplicable=false; assert.deepEqual(issues(report),[]);
  report.items[0].isApplicable=true; report.items[0].scoreId=9; report.items[0].scoreValue=null; assert.deepEqual(issues(report),[]);
});
test("readiness requires every standard-owner summation and submit-all handover", () => {
  const report=complete(); report.summationStatus.push({standardId:1,surveyorId:8,saved:false,submitted:false});
  assert.equal(issues(report).length,2);
  report.summationStatus[1].saved=true; assert.equal(issues(report).length,1);
  report.summationStatus[1].submitted=true; assert.deepEqual(issues(report),[]);
});
test("partial scope, extracts, missing sections, legacy backend cannot approve", () => {
  const report=complete();
  assert.ok(reportReadiness(report,[],sections,"full").length);
  assert.ok(reportReadiness(report,[1],[],"findings").length>=2);
  delete report.workflowVersion; assert.match(issues(report).join(" "),/backend/);
  delete report.summationStatus; assert.match(issues(report).join(" "),/unavailable/);
});
