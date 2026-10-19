using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Nodes;
using backend.Controllers.Reports;

static JsonObject Complete() => JsonNode.Parse("""
{"survey":{},"items":[{"standardId":1,"isApplicable":true,"scoreId":4}],"summationStatus":[{"standardId":1,"surveyorId":1,"saved":true,"submitted":true}]}
""")!.AsObject();
string[] sections = ["summary", "standards", "findings", "signoff"];
List<string> Issues(JsonObject report) => ReportWorkflow.ApprovalIssues(report, [1], sections, "full");
void Check(bool condition, string label) { if (!condition) throw new Exception(label); Console.WriteLine("PASS " + label); }
var report = Complete();
Check(Issues(report).Count == 0, "Complete survey without consolidated narrative can be approved");
report["items"]![0]!["scoreId"] = null;
Check(Issues(report).Any(s => s.Contains("scores")), "Unassessed requirements block approval");
report["items"]![0]!["isApplicable"] = false;
Check(Issues(report).Count == 0, "Not-applicable requirements do not require a score");
report = Complete();
report["summationStatus"]!.AsArray().Add(JsonNode.Parse("""{"standardId":1,"surveyorId":2,"saved":false,"submitted":false}"""));
Check(Issues(report).Count == 2, "Every standard-owner pair must be ready");
report["summationStatus"]![1]!["saved"] = true;
Check(Issues(report).Count == 1, "Saved summations require submit-all handover");
report["summationStatus"]![1]!["submitted"] = true;
Check(Issues(report).Count == 0, "Submitted summations need no overall narrative");
Check(ReportWorkflow.ApprovalIssues(Complete(), [], sections, "full").Count == 1, "Partial scope blocks approval");
Check(ReportWorkflow.ApprovalIssues(Complete(), [1], [], "findings").Count == 2, "Extracts and missing sections block approval");
report = Complete(); report["survey"]!["isCancelled"] = true;
Check(Issues(report).Single().Contains("cancelled"), "Cancelled surveys block approval");
report = Complete(); report.Remove("summationStatus");
Check(Issues(report).Single().Contains("unavailable"), "Missing readiness data fails closed");
report = Complete(); var revision = ReportWorkflow.Revision(report);
Check(revision == ReportWorkflow.Revision(report.DeepClone().AsObject()), "Unchanged source has stable revision");
report["items"]![0]!["scoreId"] = 3;
Check(revision != ReportWorkflow.Revision(report), "Changed source invalidates approval preview");
Console.WriteLine("All report approval checks passed. No database was accessed.");
