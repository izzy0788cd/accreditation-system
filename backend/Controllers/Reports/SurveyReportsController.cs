using backend.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Reports;

[ApiController]
[Route("api/reports/surveys")]
[Authorize(Policy = "GenerateSurveyReports")]
[ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
public partial class SurveyReportsController(AppDbContext context) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> List(CancellationToken cancellationToken)
    {
        return Ok(await context.surveys.AsNoTracking()
            .OrderByDescending(s => s.startDate).ThenByDescending(s => s.surveyId)
            .Select(s => new {
                s.surveyId, s.startDate, s.endDate, s.isCancelled,
                facilityName = s.facility!.facilityName,
                surveyType = s.surveyType!.surveyTypeName,
            }).ToListAsync(cancellationToken));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id, CancellationToken cancellationToken)
    {
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
                criterionNumber = a.compliance.criterion.criterionNumber,
                criterionTitle = a.compliance.criterion.criterionTitle,
                a.compliance.complianceNumber, a.compliance.complianceSummary,
                isApplicable = a.compliance.isApplicable && a.compliance.criterion.isApplicable,
                a.scoreId, scoreValue = a.score == null ? (int?)null : a.score.scoreValue,
                a.riskRatingId,
                riskLabel = a.riskRating == null ? null : a.riskRating.riskLabel,
                riskSeverity = a.riskRating == null ? null : a.riskRating.severityOrder,
                a.complianceComments,
                surveyorName = a.surveyor!.user!.firstName + " " + a.surveyor.user.lastName,
                evidence = a.complianceEvidenceChecks!.Select(e => new {
                    e.evidenceId, e.complianceEvidenceCheckId, e.isChecked,
                    e.evidence!.evidenceNumber, e.evidence.evidenceSummary,
                    e.evidence.isApplicable,
                }).ToList(),
            }).ToListAsync(cancellationToken);
        var currentItems = items.Where(a => a.surveyId == id).ToList();
        var complianceIds = currentItems.Select(a => a.complianceId).ToHashSet();
        return Ok(new { survey, generatedAt = DateTimeOffset.UtcNow, items = currentItems, internalSurvey,
            internalItems = items.Where(a => a.surveyId == internalId && complianceIds.Contains(a.complianceId)).ToList() });
    }
}
