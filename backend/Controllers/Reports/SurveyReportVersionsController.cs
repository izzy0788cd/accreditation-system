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
    private static readonly string[] ReportSections = ["summary", "standards", "findings", "evidence", "actions"];

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
            || (dto.mode != "full" && dto.mode != "findings") || dto.actions == null
            || dto.reviewerName == null || dto.reviewerName.Length > 200
            || dto.reviewNotes == null || dto.reviewNotes.Length > 10000
            || dto.actions.Count > 2000 || dto.actions.Any(a => a == null) || dto.actions.Select(a => a.complianceId).Distinct().Count() != dto.actions.Count
            || dto.actions.Any(a => string.IsNullOrWhiteSpace(a.recommendation) || a.recommendation.Length > 10000
                || a.owner == null || a.owner.Length > 200))
            return BadRequest("Select valid standards and sections, and complete each recommendation (maximum 10,000 characters).");

        // Lock the survey for numbering; a repeatable read preserves a consistent source snapshot.
        await using var transaction = await context.Database.BeginTransactionAsync(System.Data.IsolationLevel.RepeatableRead, cancellationToken);
        var survey = await context.surveys.FromSqlInterpolated($"SELECT * FROM surveys WHERE \"surveyId\"={id} FOR UPDATE")
            .SingleOrDefaultAsync(cancellationToken);
        if (survey == null) return NotFound();
        var result = await Get(id, cancellationToken) as OkObjectResult;
        if (result == null) return NotFound();
        var report = JsonSerializer.SerializeToNode(result.Value, ReportJsonOptions)!.AsObject();
        var allItems = report["items"]!.AsArray();
        var availableIds = allItems.Select(i => i!["standardId"]!.GetValue<int>()).ToHashSet();
        if (dto.standardIds.Any(s => !availableIds.Contains(s))) return BadRequest("A selected standard has no assessments in this survey.");
        var selected = allItems.Where(i => dto.standardIds.Contains(i!["standardId"]!.GetValue<int>())).ToList();
        var complianceIds = selected.Select(i => i!["complianceId"]!.GetValue<int>()).ToHashSet();
        if (dto.actions.Any(a => !complianceIds.Contains(a.complianceId))) return BadRequest("Recommendations must belong to selected standards.");
        report["items"] = new JsonArray(selected.Select(i => i!.DeepClone()).ToArray());
        report["internalItems"] = new JsonArray(report["internalItems"]!.AsArray()
            .Where(i => complianceIds.Contains(i!["complianceId"]!.GetValue<int>())).Select(i => i!.DeepClone()).ToArray());
        report["standards"] = new JsonArray(selected.GroupBy(i => i!["standardId"]!.GetValue<int>())
            .Select(g => (JsonNode)new JsonObject {
                ["id"] = g.Key, ["number"] = g.First()!["standardNumber"]!.DeepClone(),
                ["title"] = g.First()!["standardTitle"]!.DeepClone(),
            }).ToArray());
        report["included"] = JsonSerializer.SerializeToNode(dto.included.Distinct(), ReportJsonOptions);
        report["mode"] = dto.mode;
        report["actions"] = JsonSerializer.SerializeToNode(dto.actions, ReportJsonOptions);
        report["reviewerName"] = dto.reviewerName.Trim();
        report["reviewNotes"] = dto.reviewNotes.Trim();
        report["schemaVersion"] = 1;
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
        version.reportJson = report.ToJsonString(ReportJsonOptions);
        context.surveyReportVersions.Add(version);
        try { await context.SaveChangesAsync(cancellationToken); await transaction.CommitAsync(cancellationToken); }
        catch (Exception exception) when (exception is Npgsql.PostgresException { SqlState: "40001" }
            || exception.InnerException is Npgsql.PostgresException { SqlState: "23505" or "40001" })
        { return Conflict("Another report version was saved at the same time. Please retry."); }
        return CreatedAtAction(nameof(Version), new { id, versionId = version.reportVersionId }, report);
    }
}
