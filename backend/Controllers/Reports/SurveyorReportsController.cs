using System.Security.Claims;
using System.Text.Json;
using backend.Data;
using backend.DTOs.Reports;
using backend.Models.Reports;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Reports;

[ApiController]
[Route("api/surveyor-reports")]
[Authorize(Roles = "Admin,Surveyor,Team Lead")]
public class SurveyorReportsController(AppDbContext context) : ControllerBase
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);
    private async Task<int?> CurrentSurveyorIdAsync()
    {
        var account = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(account, out var accountId)
            ? await context.surveyors.Where(item => item.user!.userAccountId == accountId).Select(item => (int?)item.surveyorId).FirstOrDefaultAsync()
            : null;
    }

    private IQueryable<SurveyorReportDTO> Project(IQueryable<SurveyorReport> query) => query.Select(report => new SurveyorReportDTO
    {
        surveyorReportId = report.surveyorReportId, surveyId = report.surveyId, surveyorId = report.surveyorId,
        surveyorName = report.surveyor!.user!.firstName + " " + report.surveyor.user.lastName,
        summary = report.summary, priorityFindings = report.priorityFindings, recommendations = report.recommendations,
        goodPractices = report.goodPractices, notApplicableNotes = report.notApplicableNotes, isSubmitted = report.isSubmitted,
        submittedAt = report.submittedAt, updatedAt = report.updatedAt,
        assignedRequirements = context.complianceAssessments.Count(assessment => assessment.surveyId == report.surveyId && assessment.surveyorId == report.surveyorId),
        scoredRequirements = context.complianceAssessments.Count(assessment => assessment.surveyId == report.surveyId && assessment.surveyorId == report.surveyorId && assessment.scoreId != null),
    });

    [HttpGet("survey/{surveyId:int}")]
    public async Task<ActionResult<IEnumerable<SurveyorReportDTO>>> Get(int surveyId)
    {
        var currentSurveyorId = await CurrentSurveyorIdAsync();
        if (!User.IsInRole("Admin"))
        {
            var isLead = User.IsInRole("Team Lead") && currentSurveyorId.HasValue && await context.surveys.AnyAsync(survey => survey.surveyId == surveyId && survey.surveyorId == currentSurveyorId.Value);
            if (!isLead && !currentSurveyorId.HasValue) return Forbid();
            var reports = Project(context.surveyorReports.AsNoTracking().Where(report => report.surveyId == surveyId && (isLead ? report.isSubmitted : report.surveyorId == currentSurveyorId))).ToListAsync();
            return Ok(await reports);
        }
        return Ok(await Project(context.surveyorReports.AsNoTracking().Where(report => report.surveyId == surveyId)).ToListAsync());
    }

    [HttpPut("survey/{surveyId:int}/mine")]
    public async Task<ActionResult<SurveyorReportDTO>> Save(int surveyId, SurveyorReportSaveDTO dto)
    {
        var surveyorId = await CurrentSurveyorIdAsync();
        if (!surveyorId.HasValue) return Forbid();
        if (!await context.complianceAssessments.AnyAsync(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value)) return Forbid();
        var report = await context.surveyorReports.SingleOrDefaultAsync(item => item.surveyId == surveyId && item.surveyorId == surveyorId.Value);
        if (report?.isSubmitted == true) return BadRequest("This surveyor report has already been submitted.");
        if (dto.submit && await context.complianceAssessments.AnyAsync(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value && assessment.scoreId == null)) return BadRequest("Score every assigned requirement before submitting your report.");
        if (dto.submit && string.IsNullOrWhiteSpace(dto.summary)) return BadRequest("Provide an overall summary before submitting your report.");
        if (new[] { dto.summary, dto.priorityFindings, dto.recommendations, dto.goodPractices, dto.notApplicableNotes }.Any(value => value?.Length > 10000)) return BadRequest("Each report section must be 10,000 characters or fewer.");
        var priorityIds = await context.complianceAssessments.Where(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value && assessment.score!.scoreValue != null && assessment.score.scoreValue <= 2 && assessment.riskRating!.severityOrder >= 3).Select(assessment => assessment.complianceAssessmentId).ToListAsync();
        var actions = dto.findingActions ?? [];
        if (actions.Any(action => !priorityIds.Contains(action.complianceAssessmentId) || action.recommendation?.Length > 10000 || action.correctiveAction?.Length > 10000)) return BadRequest("Recommendations and corrective actions must belong to a current priority finding.");
        report ??= new SurveyorReport { surveyId = surveyId, surveyorId = surveyorId.Value };
        report.summary = dto.summary?.Trim(); report.priorityFindings = null; report.recommendations = JsonSerializer.Serialize(actions.Select(action => new { action.complianceAssessmentId, recommendation = action.recommendation?.Trim(), correctiveAction = action.correctiveAction?.Trim() }), JsonOptions); report.goodPractices = dto.goodPractices?.Trim(); report.notApplicableNotes = dto.notApplicableNotes?.Trim(); report.updatedAt = DateTime.UtcNow;
        if (dto.submit) { report.isSubmitted = true; report.submittedAt = DateTime.UtcNow; }
        if (report.surveyorReportId == 0) context.surveyorReports.Add(report);
        await context.SaveChangesAsync();
        return Ok(await Project(context.surveyorReports.AsNoTracking().Where(item => item.surveyorReportId == report.surveyorReportId)).SingleAsync());
    }

    [HttpPost("{surveyorReportId:int}/reopen")]
    [Authorize(Roles = "Admin,Team Lead")]
    public async Task<IActionResult> Reopen(int surveyorReportId, SurveyorReportReopenDTO dto)
    {
        if (string.IsNullOrWhiteSpace(dto.reason))
            return BadRequest("Provide a reason for reopening this submitted report.");
        if (dto.reason.Trim().Length > 2000)
            return BadRequest("The reopening reason must be 2,000 characters or fewer.");

        var report = await context.surveyorReports.FirstOrDefaultAsync(item => item.surveyorReportId == surveyorReportId);
        if (report == null)
            return NotFound();
        if (!report.isSubmitted)
            return BadRequest("Only a submitted surveyor report can be reopened.");

        if (!User.IsInRole("Admin"))
        {
            var currentSurveyorId = await CurrentSurveyorIdAsync();
            var isTeamLead = currentSurveyorId.HasValue && await context.surveys.AnyAsync(survey =>
                survey.surveyId == report.surveyId && survey.surveyorId == currentSurveyorId.Value);
            if (!isTeamLead)
                return Forbid();
        }

        context.surveyorReportReopens.Add(new SurveyorReportReopen
        {
            surveyorReportId = report.surveyorReportId,
            reason = dto.reason.Trim(),
            reopenedByUsername = User.Identity?.Name ?? "Unknown",
            reopenedAt = DateTime.UtcNow,
            previousSubmittedAt = report.submittedAt,
        });
        report.isSubmitted = false;
        report.updatedAt = DateTime.UtcNow;
        await context.SaveChangesAsync();
        return NoContent();
    }

    [HttpGet("survey/{surveyId:int}/mine/workspace")]
    public async Task<IActionResult> Workspace(int surveyId)
    {
        var surveyorId = await CurrentSurveyorIdAsync();
        if (!surveyorId.HasValue) return Forbid();
        var report = await context.surveyorReports.AsNoTracking().SingleOrDefaultAsync(item => item.surveyId == surveyId && item.surveyorId == surveyorId.Value);
        var actions = new Dictionary<int, JsonElement>();
        if (!string.IsNullOrWhiteSpace(report?.recommendations))
        {
            try { actions = JsonSerializer.Deserialize<List<JsonElement>>(report.recommendations, JsonOptions)?.Where(item => item.TryGetProperty("complianceAssessmentId", out _)).ToDictionary(item => item.GetProperty("complianceAssessmentId").GetInt32()) ?? []; } catch (JsonException) { }
        }
        var findings = await context.complianceAssessments.AsNoTracking().Where(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value && assessment.score!.scoreValue != null && assessment.score.scoreValue <= 2 && assessment.riskRating!.severityOrder >= 3).OrderBy(assessment => assessment.compliance!.complianceNumber).Select(assessment => new SurveyorReportFindingDTO { complianceAssessmentId = assessment.complianceAssessmentId, complianceNumber = assessment.compliance!.complianceNumber, complianceSummary = assessment.compliance.complianceSummary, scoreLabel = assessment.score!.scoreLabel, riskLabel = assessment.riskRating!.riskLabel, comments = assessment.complianceComments }).ToListAsync();
        foreach (var finding in findings) if (actions.TryGetValue(finding.complianceAssessmentId, out var action)) { if (action.TryGetProperty("recommendation", out var recommendation)) finding.recommendation = recommendation.GetString(); if (action.TryGetProperty("correctiveAction", out var correctiveAction)) finding.correctiveAction = correctiveAction.GetString(); }
        var counts = await context.complianceAssessments.Where(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value).GroupBy(_ => 1).Select(group => new { assigned = group.Count(), scored = group.Count(item => item.scoreId != null) }).FirstOrDefaultAsync();
        return Ok(new { report = report == null ? null : new { report.summary, report.goodPractices, report.notApplicableNotes, report.isSubmitted, report.submittedAt }, findings, assignedRequirements = counts?.assigned ?? 0, scoredRequirements = counts?.scored ?? 0 });
    }

}
