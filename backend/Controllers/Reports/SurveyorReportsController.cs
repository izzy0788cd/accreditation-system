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
[Authorize(Policy = "Survey.Work")]
public class SurveyorReportsController(AppDbContext context) : ControllerBase
{
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
        surveyorName = report.surveyor != null && report.surveyor.user != null
            ? report.surveyor.user.firstName + " " + report.surveyor.user.lastName
            : "Unknown surveyor",
        facilityName = report.survey != null && report.survey.facility != null
            ? report.survey.facility.facilityName
            : "Unknown facility",
        surveyType = report.survey != null && report.survey.surveyType != null
            ? report.survey.surveyType.surveyTypeName
            : "Not recorded",
        summary = report.summary, priorityFindings = report.priorityFindings,
        goodPractices = report.goodPractices, notApplicableNotes = report.notApplicableNotes, isSubmitted = report.isSubmitted,
        submittedAt = report.submittedAt, updatedAt = report.updatedAt,
        assignedRequirements = context.complianceAssessments.Count(assessment => assessment.surveyId == report.surveyId && assessment.surveyorId == report.surveyorId),
        scoredRequirements = context.complianceAssessments.Count(assessment => assessment.surveyId == report.surveyId && assessment.surveyorId == report.surveyorId && assessment.scoreId != null),
    });

    private IQueryable<int> AssignedStandardIds(int surveyId, int surveyorId) => context.complianceAssessments
        .Where(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId)
        .Select(assessment => assessment.compliance!.criterion!.standardId)
        .Distinct();

    internal static IQueryable<SurveyorStandardSummaryDTO> ProjectStandardSummaries(IQueryable<SurveyorStandardSummary> query) => query
        .Select(summary => new SurveyorStandardSummaryDTO
        {
            surveyorStandardSummaryId = summary.surveyorStandardSummaryId,
            surveyId = summary.surveyId,
            surveyorId = summary.surveyorId,
            surveyorName = summary.surveyor!.user!.firstName + " " + summary.surveyor.user.lastName,
            standardId = summary.standardId,
            standardNumber = summary.standard!.standardNumber,
            standardTitle = summary.standard.standardTitle,
            summary = summary.summary,
            goodPractices = summary.goodPractices,
            notApplicableNotes = summary.notApplicableNotes,
            areasOfConcern = summary.areasOfConcern,
            recommendations = summary.recommendations,
            serviceAreas = ReadServiceAreas(summary.serviceAreasJson),
            updatedAt = summary.updatedAt,
        });

    private static List<StandardServiceAreaDTO> ReadServiceAreas(string? json) =>
        string.IsNullOrWhiteSpace(json) ? [] : JsonSerializer.Deserialize<List<StandardServiceAreaDTO>>(json) ?? [];

    [HttpGet("survey/{surveyId:int}/mine/standard-summaries")]
    public async Task<ActionResult<IEnumerable<SurveyorStandardSummaryDTO>>> MyStandardSummaries(int surveyId)
    {
        var surveyorId = await CurrentSurveyorIdAsync();
        if (!surveyorId.HasValue) return Forbid();
        return Ok(await ProjectStandardSummaries(context.surveyorStandardSummaries.AsNoTracking()
            .Where(summary => summary.surveyId == surveyId && summary.surveyorId == surveyorId.Value)
            .OrderBy(summary => summary.standard!.standardNumber)).ToListAsync());
    }

    [HttpPut("survey/{surveyId:int}/mine/standards/{standardId:int}/summary")]
    public async Task<ActionResult<SurveyorStandardSummaryDTO>> SaveStandardSummary(int surveyId, int standardId, SurveyorStandardSummarySaveDTO dto)
    {
        var surveyorId = await CurrentSurveyorIdAsync();
        if (!surveyorId.HasValue) return Forbid();
        if (string.IsNullOrWhiteSpace(dto.summary)) return BadRequest("Provide a summary for this standard before continuing.");
        if (new[] { dto.summary, dto.goodPractices, dto.notApplicableNotes, dto.areasOfConcern, dto.recommendations }.Any(value => value?.Length > 10_000)) return BadRequest("Each summation report section must be 10,000 characters or fewer.");
        if (dto.serviceAreas is { Count: > 20 }) return BadRequest("Include at most 20 additional services or areas.");
        if (dto.serviceAreas?.Any(area => area == null || string.IsNullOrWhiteSpace(area.name) || area.name.Length > 200 || string.IsNullOrWhiteSpace(area.overview)
            || new[] { area.overview, area.commendations, area.areasOfConcern, area.recommendations }.Any(value => value?.Length > 10_000)) == true)
            return BadRequest("Each service or area needs a name (up to 200 characters) and an overview. Each section must be 10,000 characters or fewer.");
        if (!await AssignedStandardIds(surveyId, surveyorId.Value).ContainsAsync(standardId)) return Forbid();
        if (await context.surveys.AnyAsync(survey => survey.surveyId == surveyId && survey.isCancelled)) return BadRequest("Cancelled surveys cannot be edited.");
        if (await context.complianceAssessments.AnyAsync(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value && assessment.compliance!.criterion!.standardId == standardId && assessment.scoreId == null)) return BadRequest("Score every requirement in this standard before saving its summary.");

        if (await context.surveyorReports.AnyAsync(r => r.surveyId == surveyId && r.surveyorId == surveyorId.Value && r.isSubmitted))
            return BadRequest("Ask the Team Lead or Administrator to reopen your submitted summations before editing.");
        var summary = await context.surveyorStandardSummaries.SingleOrDefaultAsync(item => item.surveyId == surveyId && item.surveyorId == surveyorId.Value && item.standardId == standardId);
        summary ??= new SurveyorStandardSummary { surveyId = surveyId, surveyorId = surveyorId.Value, standardId = standardId, summary = "" };
        summary.summary = dto.summary.Trim();
        summary.goodPractices = dto.goodPractices?.Trim();
        summary.notApplicableNotes = dto.notApplicableNotes?.Trim();
        summary.areasOfConcern = dto.areasOfConcern?.Trim();
        summary.recommendations = dto.recommendations?.Trim();
        summary.serviceAreasJson = JsonSerializer.Serialize(dto.serviceAreas ?? []);
        summary.updatedAt = DateTime.UtcNow;
        if (summary.surveyorStandardSummaryId == 0) context.surveyorStandardSummaries.Add(summary);
        await context.SaveChangesAsync();
        return Ok(await ProjectStandardSummaries(context.surveyorStandardSummaries.AsNoTracking().Where(item => item.surveyorStandardSummaryId == summary.surveyorStandardSummaryId)).SingleAsync());
    }

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

    [HttpGet("submitted")]
    public async Task<ActionResult<IEnumerable<SurveyorReportDTO>>> Submitted(CancellationToken cancellationToken)
    {
        var query = context.surveyorReports.AsNoTracking().Where(report => report.isSubmitted);
        if (User.IsInRole("Admin"))
            return Ok(await Project(query).OrderByDescending(report => report.submittedAt).ToListAsync(cancellationToken));

        var currentSurveyorId = await CurrentSurveyorIdAsync();
        if (!currentSurveyorId.HasValue) return Forbid();
        if (User.IsInRole("Team Lead"))
            query = query.Where(report => report.survey!.surveyorId == currentSurveyorId.Value);
        else
            query = query.Where(report => report.surveyorId == currentSurveyorId.Value);
        return Ok(await Project(query).OrderByDescending(report => report.submittedAt).ToListAsync(cancellationToken));
    }

    [HttpGet("{surveyorReportId:int}/review")]
    [Authorize(Policy = "Survey.ReviewTeam")]
    public async Task<IActionResult> Review(int surveyorReportId)
    {
        var report = await context.surveyorReports.AsNoTracking()
            .FirstOrDefaultAsync(item => item.surveyorReportId == surveyorReportId);
        if (report == null)
            return NotFound();
        if (!report.isSubmitted)
            return BadRequest("Only submitted surveyor reports can be reviewed.");

        if (!User.IsInRole("Admin"))
        {
            var currentSurveyorId = await CurrentSurveyorIdAsync();
            var isTeamLead = currentSurveyorId.HasValue && await context.surveys.AnyAsync(survey =>
                survey.surveyId == report.surveyId && survey.surveyorId == currentSurveyorId.Value);
            if (!isTeamLead)
                return Forbid();
        }

        var findings = await context.complianceAssessments.AsNoTracking()
            .Where(assessment => assessment.surveyId == report.surveyId
                && assessment.surveyorId == report.surveyorId
                && assessment.score!.scoreValue != null
                && assessment.score.scoreValue <= 2
                && assessment.riskRating!.severityOrder >= 3)
            .OrderBy(assessment => assessment.compliance!.complianceNumber)
            .Select(assessment => new SurveyorReportFindingDTO
            {
                complianceAssessmentId = assessment.complianceAssessmentId,
                complianceNumber = assessment.compliance!.complianceNumber,
                complianceSummary = assessment.compliance.complianceSummary,
                scoreLabel = assessment.score!.scoreLabel,
                riskLabel = assessment.riskRating!.riskLabel,
                comments = assessment.complianceComments,
            })
            .ToListAsync();
        var reportDto = await Project(context.surveyorReports.AsNoTracking()
            .Where(item => item.surveyorReportId == surveyorReportId)).SingleAsync();
        var standardSummaries = await ProjectStandardSummaries(context.surveyorStandardSummaries.AsNoTracking()
            .Where(summary => summary.surveyId == report.surveyId && summary.surveyorId == report.surveyorId)
            .OrderBy(summary => summary.standard!.standardNumber)).ToListAsync();
        return Ok(new { report = reportDto, findings, standardSummaries });
    }

    // Submit the saved standard summations together; no extra overall narrative is required.
    [HttpPut("survey/{surveyId:int}/mine")]
    public async Task<IActionResult> Save(int surveyId, SurveyorReportSaveDTO dto)
    {
        if (!dto.submit) return BadRequest("Save drafts in each standard summation. Use submit to hand over all standards.");
        var surveyorId = await CurrentSurveyorIdAsync();
        if (!surveyorId.HasValue) return Forbid();
        if (await context.surveys.AnyAsync(s => s.surveyId == surveyId && s.isCancelled))
            return BadRequest("Cancelled surveys cannot be submitted.");
        var assigned = await AssignedStandardIds(surveyId, surveyorId.Value).ToListAsync();
        if (assigned.Count == 0) return Forbid();
        if (await context.complianceAssessments.AnyAsync(a => a.surveyId == surveyId && a.surveyorId == surveyorId.Value && a.scoreId == null))
            return BadRequest("Score every assigned requirement before submitting.");
        if (await context.surveyorStandardSummaries.CountAsync(s => s.surveyId == surveyId && s.surveyorId == surveyorId.Value && assigned.Contains(s.standardId) && !string.IsNullOrWhiteSpace(s.summary)) != assigned.Count)
            return BadRequest("Save a summation for every assigned standard before submitting.");
        var report = await context.surveyorReports.SingleOrDefaultAsync(r => r.surveyId == surveyId && r.surveyorId == surveyorId.Value);
        if (report?.isSubmitted == true) return BadRequest("Your standard summations have already been submitted.");
        report ??= new SurveyorReport { surveyId = surveyId, surveyorId = surveyorId.Value };
        // Preserve legacy narrative, but never require or overwrite it during submission.
        report.isSubmitted = true;
        report.submittedAt = report.updatedAt = DateTime.UtcNow;
        if (report.surveyorReportId == 0) context.surveyorReports.Add(report);
        await context.SaveChangesAsync();
        return Ok(new { report.isSubmitted, report.submittedAt });
    }

    [HttpPost("{surveyorReportId:int}/reopen")]
    [Authorize(Policy = "Survey.ReviewTeam")]
    public async Task<IActionResult> Reopen(int surveyorReportId, SurveyorReportReopenDTO dto)
    {
        if (string.IsNullOrWhiteSpace(dto.reason) || dto.reason.Trim().Length > 2000)
            return BadRequest("Provide a reopening reason of 1–2,000 characters.");
        var report = await context.surveyorReports.FindAsync(surveyorReportId);
        if (report == null) return NotFound();
        if (!User.IsInRole("Admin"))
        {
            var surveyorId = await CurrentSurveyorIdAsync();
            if (!surveyorId.HasValue || !await context.surveys.AnyAsync(s => s.surveyId == report.surveyId && s.surveyorId == surveyorId.Value)) return Forbid();
        }
        if (!report.isSubmitted) return BadRequest("This handover is already open.");
        context.surveyorReportReopens.Add(new SurveyorReportReopen {
            surveyorReportId = report.surveyorReportId, reason = dto.reason.Trim(),
            reopenedByUsername = User.Identity?.Name ?? "Unknown", reopenedAt = DateTime.UtcNow,
            previousSubmittedAt = report.submittedAt
        });
        report.isSubmitted = false;
        report.updatedAt = DateTime.UtcNow;
        await context.SaveChangesAsync();
        return NoContent();
    }

    [HttpGet("survey/{surveyId:int}/standard-summaries")]
    [Authorize(Policy = "Survey.ReviewTeam")]
    public async Task<IActionResult> TeamStandardSummaries(int surveyId)
    {
        if (!User.IsInRole("Admin"))
        {
            var surveyorId = await CurrentSurveyorIdAsync();
            if (!surveyorId.HasValue || !await context.surveys.AnyAsync(s => s.surveyId == surveyId && s.surveyorId == surveyorId.Value))
                return Forbid();
        }
        return Ok(await ProjectStandardSummaries(context.surveyorStandardSummaries.AsNoTracking()
            .Where(s => s.surveyId == surveyId)).ToListAsync());
    }

    [HttpGet("survey/{surveyId:int}/mine/workspace")]
    public async Task<IActionResult> Workspace(int surveyId)
    {
        var surveyorId = await CurrentSurveyorIdAsync();
        if (!surveyorId.HasValue) return Forbid();
        var report = await context.surveyorReports.AsNoTracking().SingleOrDefaultAsync(item => item.surveyId == surveyId && item.surveyorId == surveyorId.Value);
        var findings = await context.complianceAssessments.AsNoTracking().Where(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value && assessment.score!.scoreValue != null && assessment.score.scoreValue <= 2 && assessment.riskRating!.severityOrder >= 3).OrderBy(assessment => assessment.compliance!.complianceNumber).Select(assessment => new SurveyorReportFindingDTO { complianceAssessmentId = assessment.complianceAssessmentId, complianceNumber = assessment.compliance!.complianceNumber, complianceSummary = assessment.compliance.complianceSummary, scoreLabel = assessment.score!.scoreLabel, riskLabel = assessment.riskRating!.riskLabel, comments = assessment.complianceComments }).ToListAsync();
        var standardSummaries = await ProjectStandardSummaries(context.surveyorStandardSummaries.AsNoTracking().Where(summary => summary.surveyId == surveyId && summary.surveyorId == surveyorId.Value).OrderBy(summary => summary.standard!.standardNumber)).ToListAsync();
        var assignedStandardIds = await AssignedStandardIds(surveyId, surveyorId.Value).ToListAsync();
        var assignedStandards = await context.complianceAssessments.Where(a => a.surveyId == surveyId && a.surveyorId == surveyorId.Value)
            .GroupBy(a => new { a.compliance!.criterion!.standardId, a.compliance.criterion.standard!.standardNumber })
            .Select(g => new { g.Key.standardId, g.Key.standardNumber, unscored = g.Count(a => a.scoreId == null) }).ToListAsync();
        var assignedStandardCount = assignedStandardIds.Count;
        var counts = await context.complianceAssessments.Where(assessment => assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value).GroupBy(_ => 1).Select(group => new { assigned = group.Count(), scored = group.Count(item => item.scoreId != null) }).FirstOrDefaultAsync();
        return Ok(new { report = report == null ? null : new { report.summary, report.goodPractices, report.notApplicableNotes, report.isSubmitted, report.submittedAt }, findings, standardSummaries, assignedStandards, assignedStandardCount, completedStandardSummaryCount = standardSummaries.Count(summary => assignedStandardIds.Contains(summary.standardId)), assignedRequirements = counts?.assigned ?? 0, scoredRequirements = counts?.scored ?? 0 });
    }

}
