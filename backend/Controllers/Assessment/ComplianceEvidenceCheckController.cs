using backend.Data;
using backend.DTOs.Assessment;
using backend.Models.Assessment;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace backend.Controllers.Assessment
{
    [Route("api/complianceEvidenceChecks")]
    [ApiController]
    public class ComplianceEvidenceCheckController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ComplianceEvidenceCheckController(AppDbContext context) => _context = context;

        private async Task<int?> GetCurrentSurveyorIdAsync()
        {
            var accountId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(accountId, out var userAccountId))
                return null;

            return await _context.surveyors
                .Where(surveyor => surveyor.user!.userAccountId == userAccountId)
                .Select(surveyor => (int?)surveyor.surveyorId)
                .FirstOrDefaultAsync();
        }

        // A survey snapshots the evidence list when it is created. Framework evidence can
        // subsequently be added (for example, evidence for compliance 1.4.8), so bring an
        // existing survey checklist up to date before returning it. Existing check states
        // are deliberately left untouched.
        private async Task EnsureCurrentEvidenceChecksAsync(int surveyId)
        {
            var assessmentEvidencePairs = await _context.complianceAssessments
                .Where(assessment => assessment.surveyId == surveyId)
                .SelectMany(assessment => _context.evidence
                    .Where(evidence =>
                        evidence.complianceId == assessment.complianceId
                        && evidence.isApplicable
                    )
                    .Select(evidence => new
                    {
                        assessment.complianceAssessmentId,
                        evidence.evidenceId,
                    })
                )
                .ToListAsync();

            if (assessmentEvidencePairs.Count == 0)
                return;

            var assessmentIds = assessmentEvidencePairs
                .Select(pair => pair.complianceAssessmentId)
                .Distinct()
                .ToList();
            var existingPairs = await _context.complianceEvidenceChecks
                .Where(check => assessmentIds.Contains(check.complianceAssessmentId))
                .Select(check => new { check.complianceAssessmentId, check.evidenceId })
                .ToListAsync();
            var existing = existingPairs
                .Select(pair => (pair.complianceAssessmentId, pair.evidenceId))
                .ToHashSet();
            var missing = assessmentEvidencePairs
                .Where(pair => !existing.Contains((pair.complianceAssessmentId, pair.evidenceId)))
                .Select(pair => new ComplianceEvidenceCheck
                {
                    complianceAssessmentId = pair.complianceAssessmentId,
                    evidenceId = pair.evidenceId,
                    isChecked = false,
                })
                .ToList();

            if (missing.Count == 0)
                return;

            _context.complianceEvidenceChecks.AddRange(missing);
            await _context.SaveChangesAsync();
        }

        [HttpGet("assessment/{complianceAssessmentId}")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<IEnumerable<ComplianceEvidenceCheckDTO>>> GetForAssessment(
            int complianceAssessmentId
        )
        {
            var surveyId = await _context.complianceAssessments
                .Where(assessment => assessment.complianceAssessmentId == complianceAssessmentId)
                .Select(assessment => (int?)assessment.surveyId)
                .FirstOrDefaultAsync();
            if (!surveyId.HasValue)
                return NotFound();

            await EnsureCurrentEvidenceChecksAsync(surveyId.Value);

            var checks = await _context
                .complianceEvidenceChecks.Where(ce =>
                    ce.complianceAssessmentId == complianceAssessmentId
                )
                .Select(ce => new ComplianceEvidenceCheckDTO
                {
                    complianceEvidenceCheckId = ce.complianceEvidenceCheckId,
                    complianceAssessmentId = ce.complianceAssessmentId,
                    evidenceId = ce.evidenceId,
                    evidenceNumber = ce.evidence!.evidenceNumber,
                    evidenceSummary = ce.evidence!.evidenceSummary,
                    isChecked = ce.isChecked,
                })
                .ToListAsync();

            return Ok(checks);
        }

        [HttpGet("survey/{surveyId}")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<IEnumerable<ComplianceEvidenceCheckDTO>>> GetForSurvey(int surveyId)
        {
            if (!await _context.surveys.AnyAsync(survey => survey.surveyId == surveyId))
                return NotFound();

            await EnsureCurrentEvidenceChecksAsync(surveyId);

            var checks = await _context
                .complianceEvidenceChecks.Where(check =>
                    check.complianceAssessment!.surveyId == surveyId
                )
                .Select(check => new ComplianceEvidenceCheckDTO
                {
                    complianceEvidenceCheckId = check.complianceEvidenceCheckId,
                    complianceAssessmentId = check.complianceAssessmentId,
                    evidenceId = check.evidenceId,
                    evidenceNumber = check.evidence!.evidenceNumber,
                    evidenceSummary = check.evidence.evidenceSummary,
                    isChecked = check.isChecked,
                })
                .ToListAsync();

            return Ok(checks);
        }

        [HttpGet("survey/{surveyId}/mine")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<IEnumerable<ComplianceEvidenceCheckDTO>>> GetMyForSurvey(int surveyId)
        {
            var surveyorId = await GetCurrentSurveyorIdAsync();
            if (!surveyorId.HasValue)
                return Forbid();
            if (!await _context.surveys.AnyAsync(survey => survey.surveyId == surveyId))
                return NotFound();

            await EnsureCurrentEvidenceChecksAsync(surveyId);

            var checks = await _context.complianceEvidenceChecks
                .Where(check => check.complianceAssessment!.surveyId == surveyId
                    && check.complianceAssessment.surveyorId == surveyorId.Value)
                .Select(check => new ComplianceEvidenceCheckDTO
                {
                    complianceEvidenceCheckId = check.complianceEvidenceCheckId,
                    complianceAssessmentId = check.complianceAssessmentId,
                    evidenceId = check.evidenceId,
                    evidenceNumber = check.evidence!.evidenceNumber,
                    evidenceSummary = check.evidence.evidenceSummary,
                    isChecked = check.isChecked,
                })
                .ToListAsync();

            return Ok(checks);
        }

        [HttpPatch("{id}/checked")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<IActionResult> PatchChecked(int id, [FromBody] bool isChecked)
        {
            var check = await _context.complianceEvidenceChecks
                .Include(item => item.complianceAssessment)
                    .ThenInclude(assessment => assessment!.survey)
                .FirstOrDefaultAsync(item => item.complianceEvidenceCheckId == id);
            if (check == null)
                return NotFound();
            if (check.complianceAssessment!.survey!.isCancelled)
                return BadRequest("This survey has been cancelled and evidence checks can no longer be changed.");

            var reportSubmitted = await _context.surveyorReports.AnyAsync(report =>
                report.surveyId == check.complianceAssessment.surveyId
                && report.surveyorId == check.complianceAssessment.surveyorId
                && report.isSubmitted);
            if (reportSubmitted)
                return BadRequest("Your surveyor report has been submitted. Ask the Team Lead or an Administrator to reopen it before changing evidence checks.");

            if (!User.IsInRole("Admin"))
            {
                var accountId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (!int.TryParse(accountId, out var userAccountId))
                    return Forbid();

                var isAssignedSurveyor = await _context.complianceEvidenceChecks.AnyAsync(item =>
                    item.complianceEvidenceCheckId == id
                    && item.complianceAssessment!.surveyor!.user!.userAccountId == userAccountId
                );
                if (!isAssignedSurveyor)
                    return Forbid();
            }

            check.isChecked = isChecked;
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
