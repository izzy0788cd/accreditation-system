using backend.Data;
using System.Security.Claims;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Reports;

[ApiController]
[Route("api/reports/surveys")]
[Authorize(Policy = "Reports.Generate")]
[ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
public partial class SurveyReportsController(AppDbContext context) : ControllerBase
{
    private async Task<int?> CurrentSurveyorIdAsync()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var accountId)
            ? await context.surveyors.Where(s => s.user!.userAccountId == accountId)
                .Select(s => (int?)s.surveyorId).FirstOrDefaultAsync()
            : null;
    }

    private async Task<bool> CanAccessSurveyAsync(int surveyId, CancellationToken cancellationToken)
    {
        if (User.IsInRole("Admin")) return true;
        var surveyorId = await CurrentSurveyorIdAsync();
        return surveyorId.HasValue && await context.surveys.AnyAsync(s => s.surveyId == surveyId && s.surveyorId == surveyorId.Value, cancellationToken);
    }

    private async Task<IQueryable<backend.Models.FaciltitySurvey.Survey>?> ScopedSurveysAsync()
    {
        if (User.IsInRole("Admin")) return context.surveys.AsNoTracking();
        var surveyorId = await CurrentSurveyorIdAsync();
        return surveyorId.HasValue ? context.surveys.AsNoTracking().Where(s => s.surveyorId == surveyorId.Value) : null;
    }

    [HttpGet]
    public async Task<IActionResult> List(CancellationToken cancellationToken)
    {
        var surveys = await ScopedSurveysAsync();
        if (surveys == null) return Forbid();
        return Ok(await surveys
            .OrderByDescending(s => s.startDate).ThenByDescending(s => s.surveyId)
            .Select(s => new {
                s.surveyId, s.facilityId, s.startDate, s.endDate, s.isCancelled,
                facilityName = s.facility!.facilityName,
                surveyType = s.surveyType!.surveyTypeName,
            }).ToListAsync(cancellationToken));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id, CancellationToken cancellationToken)
    {
        if (!await CanAccessSurveyAsync(id, cancellationToken)) return Forbid();
        var survey = await context.surveys.AsNoTracking().Where(s => s.surveyId == id)
            .Select(s => new {
                s.surveyId, s.facilityId, s.startDate, s.endDate, s.isCancelled, s.cancellationReason,
                facilityName = s.facility!.facilityName,
                surveyType = s.surveyType!.surveyTypeName,
                teamLead = s.surveyor!.user!.firstName + " " + s.surveyor.user.lastName,
            }).SingleOrDefaultAsync(cancellationToken);
        if (survey == null) return NotFound();

        var internalSurvey = survey.surveyType == "External"
            ? await context.surveys.AsNoTracking()
                .Where(s => s.facilityId == survey.facilityId && s.surveyType!.surveyTypeName == "Internal"
                    && !s.isCancelled && s.startDate <= survey.startDate)
                .OrderByDescending(s => s.startDate).ThenByDescending(s => s.surveyId)
                .Select(s => new { s.surveyId, s.startDate, s.endDate }).FirstOrDefaultAsync(cancellationToken)
            : null;
        var internalId = internalSurvey == null ? -1 : internalSurvey.surveyId;
        // Project both assessments with the same shape to keep comparison rendering consistent.
        // Project only report fields: no account data or unrestricted entity graphs.
        var items = await context.complianceAssessments.AsNoTracking()
            .Where(a => a.surveyId == id || a.surveyId == internalId)
            .OrderBy(a => a.complianceAssessmentId)
            .Select(a => new {
                a.surveyId, a.complianceAssessmentId, a.complianceId,
                standardId = a.compliance!.criterion!.standardId,
                standardNumber = a.compliance.criterion.standard!.standardNumber,
                standardTitle = a.compliance.criterion.standard.standardTitle,
                componentNumber = a.compliance.criterion.standard.component!.componentNumber,
                criterionNumber = a.compliance.criterion.criterionNumber,
                criterionTitle = a.compliance.criterion.criterionTitle,
                a.compliance.complianceNumber, a.compliance.complianceSummary,
                isApplicable = a.compliance.isApplicable && a.compliance.criterion.isApplicable,
                a.scoreId,
                scoreValue = a.score == null ? (int?)null : a.score.scoreValue,
                scoreLabel = a.score == null ? null : a.score.scoreLabel,
                a.riskRatingId,
                riskLabel = a.riskRating == null ? null : a.riskRating.riskLabel,
                riskSeverity = a.riskRating == null ? null : a.riskRating.severityOrder,
                a.complianceComments, a.surveyorId,
                surveyorName = a.surveyor!.user!.firstName + " " + a.surveyor.user.lastName,
                evidence = a.complianceEvidenceChecks!.OrderBy(e => e.complianceEvidenceCheckId).Select(e => new {
                    e.evidenceId, e.complianceEvidenceCheckId, e.isChecked,
                    e.evidence!.evidenceNumber, e.evidence.evidenceSummary,
                    e.evidence.isApplicable,
                }).ToList(),
            }).ToListAsync(cancellationToken);
        var currentItems = items.Where(a => a.surveyId == id).ToList();
        var complianceIds = currentItems.Select(a => a.complianceId).ToHashSet();
        var standardSummaries = await SurveyorReportsController.ProjectStandardSummaries(context.surveyorStandardSummaries.AsNoTracking()
            .Where(summary => summary.surveyId == id))
            .OrderBy(summary => summary.surveyorStandardSummaryId).ToListAsync(cancellationToken);
        var summaries = await context.surveyorStandardSummaries.AsNoTracking().Where(s => s.surveyId == id)
            .Select(s => new { s.standardId, s.surveyorId }).ToListAsync(cancellationToken);
        var submitted = await context.surveyorReports.Where(r => r.surveyId == id && r.isSubmitted).Select(r => r.surveyorId).ToListAsync(cancellationToken);
        var summationStatus = currentItems.GroupBy(a => new { a.standardId, a.surveyorId })
            .Select(g => new {
                g.Key.standardId, g.Key.surveyorId, g.First().standardNumber, g.First().standardTitle, g.First().surveyorName,
                submitted = submitted.Contains(g.Key.surveyorId),
                saved = summaries.Any(s => s.standardId == g.Key.standardId && s.surveyorId == g.Key.surveyorId),
            }).ToList();
        var source = JsonSerializer.SerializeToNode(new { survey, items = currentItems, internalSurvey, standardSummaries, summationStatus,
            internalItems = items.Where(a => a.surveyId == internalId && complianceIds.Contains(a.complianceId)).ToList() }, ReportJsonOptions)!.AsObject();
        source["sourceRevision"] = ReportWorkflow.Revision(source);
        source["workflowVersion"] = 2;
        source["generatedAt"] = JsonSerializer.SerializeToNode(DateTimeOffset.UtcNow);
        return Ok(source);
    }
}
