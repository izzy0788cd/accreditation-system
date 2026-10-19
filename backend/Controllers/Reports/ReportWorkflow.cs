using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json.Nodes;

namespace backend.Controllers.Reports;

public static class ReportWorkflow
{
    public static string Revision(JsonObject source) => Convert.ToHexString(
        SHA256.HashData(Encoding.UTF8.GetBytes(source.ToJsonString())));

    public static List<string> ApprovalIssues(JsonObject report, IEnumerable<int> selectedIds,
        IEnumerable<string> sections, string mode)
    {
        var issues = new List<string>();
        var items = report["items"]!.AsArray();
        var allIds = items.Select(i => i!["standardId"]!.GetValue<int>()).ToHashSet();
        if (items.Count == 0) issues.Add("The survey has no assessment requirements.");
        if (!allIds.SetEquals(selectedIds)) issues.Add("Select every surveyed standard for approval.");
        if (mode != "full") issues.Add("Approval requires a full report, not a findings-only extract.");
        if (new[] { "summary", "standards", "findings", "signoff" }.Except(sections).Any())
            issues.Add("Include summary, standards, findings and sign-off.");
        if (report["survey"]?["isCancelled"]?.GetValue<bool>() == true) issues.Add("A cancelled survey cannot be approved.");
        if (items.Any(i => i!["isApplicable"]?.GetValue<bool>() != false && i["scoreId"] == null))
            issues.Add("Complete all applicable requirement scores.");
        var statuses = report["summationStatus"]?.AsArray();
        if (statuses == null || statuses.Count == 0) issues.Add("Summation readiness information is unavailable.");
        else
        {
            if (statuses.Any(s => s!["submitted"]?.GetValue<bool>() != true)) issues.Add("Submit all surveyors’ standard summations to the Team Lead.");
            if (statuses.Any(s => s!["saved"]?.GetValue<bool>() != true)) issues.Add("Save all assigned standard summations.");
        }
        return issues;
    }
}
