using backend.Controllers.FacilitySurvey;
using backend.DTOs.FacilitySurvey;
using backend.Models.Reports;
using Microsoft.AspNetCore.Authorization;

void Check(bool condition, string label) { if (!condition) throw new Exception(label); Console.WriteLine("PASS " + label); }
Check(!StandardRemovalWorkflow.IsConfirmed(new() { reason = "remove", confirmed = false }), "Explicit confirmation is required");
Check(!StandardRemovalWorkflow.IsConfirmed(new() { reason = "  ", confirmed = true }), "Blank reasons are rejected");
Check(!StandardRemovalWorkflow.IsConfirmed(new() { reason = new string('x', 2001), confirmed = true }), "Overlong reasons are rejected");
Check(StandardRemovalWorkflow.IsConfirmed(new() { reason = "Training standard removed", confirmed = true }), "Confirmed reason is accepted");
var before = new DateTime(2026, 10, 1, 0, 0, 0, DateTimeKind.Utc);
var now = before.AddDays(1);
var affected = new SurveyorReport { surveyorReportId = 1, surveyId = 10, surveyorId = 20, isSubmitted = true, submittedAt = before, summary = "Keep overall narrative", goodPractices = "Keep commendations", updatedAt = before };
var unrelated = new SurveyorReport { surveyorReportId = 2, surveyId = 10, surveyorId = 21, isSubmitted = true, updatedAt = before };
var otherSurvey = new SurveyorReport { surveyorReportId = 3, surveyId = 11, surveyorId = 20, isSubmitted = true, updatedAt = before };
var draft = new SurveyorReport { surveyorReportId = 4, surveyId = 10, surveyorId = 22, isSubmitted = false, updatedAt = before };
var audits = StandardRemovalWorkflow.ReopenAffected([affected, unrelated, otherSurvey, draft], 10, [20, 22], "7", "Incorrect scope", "Test Admin", now);
Check(audits.Count == 1 && !affected.isSubmitted, "Only affected submitted handover is reopened");
Check(unrelated.isSubmitted && unrelated.updatedAt == before && otherSurvey.isSubmitted && otherSurvey.updatedAt == before, "Other owners and surveys remain untouched");
Check(!draft.isSubmitted && draft.updatedAt == before, "Existing draft handover remains untouched");
Check(affected.summary == "Keep overall narrative" && affected.goodPractices == "Keep commendations", "Overall handover narrative is preserved");
Check(audits[0].previousSubmittedAt == before && audits[0].reopenedAt == now && audits[0].reopenedByUsername == "Test Admin" && audits[0].reason.Contains("Standard 7") && audits[0].reason.Contains("Incorrect scope"), "Reopen audit records standard, reason, actor and original submission date");
Check(StandardRemovalWorkflow.ReopenAffected([affected], 10, [20], "7", "Again", "Test Admin", now).Count == 0, "Already reopened handovers are not audited twice");
var method = typeof(SurveyController).GetMethod(nameof(SurveyController.ResetAndRemoveStandard))!;
Check(method.GetCustomAttributes(typeof(AuthorizeAttribute), true).Cast<AuthorizeAttribute>().Any(a => a.Policy == "Survey.Administer"), "Destructive endpoint requires administration policy");
Console.WriteLine("All checks passed. No database accessed or live survey changed.");
