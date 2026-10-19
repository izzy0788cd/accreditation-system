using System.Security.Claims;
using System.Text.Json;
using System.Text.Json.Nodes;
using backend.DTOs.Reports;
using backend.Models.Reports;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Reports;

public partial class SurveyReportsController
{
    private static readonly JsonSerializerOptions ReportJsonOptions = new(JsonSerializerDefaults.Web);
    private static readonly string[] ReportSections = ["summary", "standards", "findings", "evidence", "signoff"];

    [HttpGet("{id:int}/versions")]
    public async Task<IActionResult> Versions(int id, CancellationToken cancellationToken)
    {
        if (!await CanAccessSurveyAsync(id, cancellationToken)) return Forbid();
        return Ok(await context.surveyReportVersions.AsNoTracking().Where(v => v.surveyId == id)
            .OrderByDescending(v => v.versionNumber).Select(v => new ReportVersionDto {
                reportVersionId = v.reportVersionId, surveyId = v.surveyId, versionNumber = v.versionNumber,
                createdAt = v.createdAt, createdBy = v.createdBy,
            }).ToListAsync(cancellationToken));
    }

    [HttpGet("{id:int}/versions/{versionId:int}")]
    public async Task<IActionResult> Version(int id, int versionId, CancellationToken cancellationToken)
    {
        if (!await CanAccessSurveyAsync(id, cancellationToken)) return Forbid();
        var version = await context.surveyReportVersions.AsNoTracking()
            .SingleOrDefaultAsync(v => v.surveyId == id && v.reportVersionId == versionId, cancellationToken);
        return version == null ? NotFound() : Content(version.reportJson, "application/json");
    }

    [HttpPost("{id:int}/versions")]
    [RequestSizeLimit(2_000_000)]
    public async Task<IActionResult> SaveVersion(int id, ReportVersionCreateDto dto, CancellationToken cancellationToken)
    {
        if (!await CanAccessSurveyAsync(id, cancellationToken)) return Forbid();
        if (dto.standardIds == null || dto.standardIds.Count == 0 || dto.standardIds.Count > 1000
            || dto.standardIds.Distinct().Count() != dto.standardIds.Count
            || dto.included == null || dto.included.Count == 0 || dto.included.Any(s => !ReportSections.Contains(s))
            || (dto.mode != "full" && dto.mode != "findings")
            || dto.reviewerName == null || dto.reviewerName.Length > 200
            || dto.reviewNotes == null || dto.reviewNotes.Length > 10000
            || (dto.conclusion != null && new[] { dto.conclusion.overview, dto.conclusion.commendations, dto.conclusion.concerns, dto.conclusion.recommendations, dto.conclusion.limitations }.Any(value => value == null || value.Length > 10000))
            )
            return BadRequest("Select valid standards and sections, and complete the sign-off details within the allowed length.");

        // Lock the survey for numbering; a repeatable read preserves a consistent source snapshot.
        await using var transaction = await context.Database.BeginTransactionAsync(System.Data.IsolationLevel.RepeatableRead, cancellationToken);
        var survey = await context.surveys.FromSqlInterpolated($"SELECT * FROM surveys WHERE \"surveyId\"={id} FOR UPDATE")
            .SingleOrDefaultAsync(cancellationToken);
        if (survey == null) return NotFound();
        var result = await Get(id, cancellationToken) as OkObjectResult;
        if (result == null) return NotFound();
        var report = JsonSerializer.SerializeToNode(result.Value, ReportJsonOptions)!.AsObject();
        if (dto.approve)
        {
            if (string.IsNullOrEmpty(dto.sourceRevision) || dto.sourceRevision != report["sourceRevision"]?.GetValue<string>())
                return Conflict("The survey has changed since your preview. Reload the survey data and review a fresh preview before approving.");
            var issues = ReportWorkflow.ApprovalIssues(report, dto.standardIds, dto.included, dto.mode);
            if (issues.Count > 0) return BadRequest(string.Join(" ", issues));
        }
        var allItems = report["items"]!.AsArray();
        var availableIds = allItems.Select(i => i!["standardId"]!.GetValue<int>()).ToHashSet();
        if (dto.standardIds.Any(s => !availableIds.Contains(s))) return BadRequest("A selected standard has no assessments in this survey.");
        var selected = allItems.Where(i => dto.standardIds.Contains(i!["standardId"]!.GetValue<int>())).ToList();
        var complianceIds = selected.Select(i => i!["complianceId"]!.GetValue<int>()).ToHashSet();
        report["items"] = new JsonArray(selected.Select(i => i!.DeepClone()).ToArray());
        report["standardSummaries"] = new JsonArray(report["standardSummaries"]!.AsArray()
            .Where(summary => dto.standardIds.Contains(summary!["standardId"]!.GetValue<int>())).Select(summary => summary!.DeepClone()).ToArray());
        report["internalItems"] = new JsonArray(report["internalItems"]!.AsArray()
            .Where(i => complianceIds.Contains(i!["complianceId"]!.GetValue<int>())).Select(i => i!.DeepClone()).ToArray());
        report["standards"] = new JsonArray(selected.GroupBy(i => i!["standardId"]!.GetValue<int>())
            .Select(g => (JsonNode)new JsonObject {
                ["id"] = g.Key, ["number"] = g.First()!["standardNumber"]!.DeepClone(),
                ["title"] = g.First()!["standardTitle"]!.DeepClone(),
            }).ToArray());
        report["included"] = JsonSerializer.SerializeToNode(dto.included.Distinct(), ReportJsonOptions);
        report["mode"] = dto.mode;
        report["reviewerName"] = dto.reviewerName.Trim();
        report["reviewNotes"] = dto.reviewNotes.Trim();
        report["conclusion"] = JsonSerializer.SerializeToNode(dto.conclusion ?? new ReportConclusionDto(), ReportJsonOptions);
        report["summationStatus"] = new JsonArray(report["summationStatus"]!.AsArray()
            .Where(s => dto.standardIds.Contains(s!["standardId"]!.GetValue<int>())).Select(s => s!.DeepClone()).ToArray());
        report["schemaVersion"] = 2;
        var versionNumber = (await context.surveyReportVersions.Where(v => v.surveyId == id)
            .MaxAsync(v => (int?)v.versionNumber, cancellationToken) ?? 0) + 1;
        var version = new SurveyReportVersion {
            surveyId = id, versionNumber = versionNumber, createdAt = DateTime.UtcNow,
            createdBy = User.Identity?.Name ?? User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "Admin",
            reportJson = "",
        };
        report["savedVersion"] = JsonSerializer.SerializeToNode(new {
            versionNumber, version.createdAt, version.createdBy,
        }, ReportJsonOptions);
        if (dto.approve) report["approval"] = JsonSerializer.SerializeToNode(new {
            approvedAt = version.createdAt, approvedBy = version.createdBy,
            approvedByUserId = User.FindFirstValue(ClaimTypes.NameIdentifier),
            statement = "Report content reviewed and approved for issue. This is not an accreditation decision.",
        }, ReportJsonOptions);
        version.reportJson = report.ToJsonString(ReportJsonOptions);
        context.surveyReportVersions.Add(version);
        try { await context.SaveChangesAsync(cancellationToken); await transaction.CommitAsync(cancellationToken); }
        catch (Exception exception) when (exception is Npgsql.PostgresException { SqlState: "40001" }
            || exception.InnerException is Npgsql.PostgresException { SqlState: "23505" or "40001" })
        { return Conflict("Another report version was saved at the same time. Please retry."); }
        return CreatedAtAction(nameof(Version), new { id, versionId = version.reportVersionId }, report);
    }
}
