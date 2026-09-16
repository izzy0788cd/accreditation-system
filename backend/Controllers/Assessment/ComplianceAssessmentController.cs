using backend.Data;
using backend.DTOs.Assessment;
using backend.Models.Assessment;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace backend.Controllers.Assessment
{
    [Route("api/complianceAssessments")]
    [ApiController]
    public class ComplianceAssessmentController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ComplianceAssessmentController(AppDbContext context) => _context = context;

        private async Task<bool> CanUpdateAsync(ComplianceAssessment assessment)
        {
            if (User.IsInRole("Admin"))
                return true;

            var accountId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(accountId, out var userAccountId))
                return false;

            return await _context.surveyors.AnyAsync(surveyor =>
                surveyor.surveyorId == assessment.surveyorId
                && surveyor.user!.userAccountId == userAccountId
            );
        }

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

        private static IQueryable<ComplianceAssessmentDTO> ProjectAssessments(
            IQueryable<ComplianceAssessment> query
        ) => query.Select(ca => new ComplianceAssessmentDTO
        {
            complianceAssessmentId = ca.complianceAssessmentId,
            surveyId = ca.surveyId,
            surveyorId = ca.surveyorId,
            surveyorName = $"{ca.surveyor!.user!.firstName} {ca.surveyor.user.lastName}",
            complianceId = ca.complianceId,
            complianceNumber = ca.compliance!.complianceNumber,
            complianceSummary = ca.compliance!.complianceSummary,
            scoreId = ca.scoreId,
            scoreValue = ca.score != null ? ca.score.scoreValue : null,
            scoreLabel = ca.score != null ? ca.score.scoreLabel : null,
            riskRatingId = ca.riskRatingId,
            riskValue = ca.riskRating != null ? ca.riskRating.riskValue : null,
            complianceComments = ca.complianceComments,
        });

        [HttpGet("survey/{surveyId}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ComplianceAssessmentDTO>>> GetForSurvey(
            int surveyId
        )
        {
            var query = _context.complianceAssessments.Where(ca => ca.surveyId == surveyId);
            if (!User.IsInRole("Admin"))
            {
                var surveyorId = await GetCurrentSurveyorIdAsync();
                if (!surveyorId.HasValue)
                    return Forbid();
                query = query.Where(ca => ca.surveyorId == surveyorId.Value);
            }

            var assessments = await ProjectAssessments(query).ToListAsync();

            return Ok(assessments);
        }

        // Used when an Admin is intentionally working as a surveyor. This keeps
        // the fieldwork view constrained even though the account retains Admin rights.
        [HttpGet("survey/{surveyId}/mine")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<IEnumerable<ComplianceAssessmentDTO>>> GetMyForSurvey(int surveyId)
        {
            var surveyorId = await GetCurrentSurveyorIdAsync();
            if (!surveyorId.HasValue)
                return Forbid();

            var assessments = await ProjectAssessments(
                _context.complianceAssessments.Where(assessment =>
                    assessment.surveyId == surveyId && assessment.surveyorId == surveyorId.Value)
            ).ToListAsync();

            return Ok(assessments);
        }

        [HttpGet("survey/{surveyId}/overview")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<IEnumerable<ComplianceAssessmentDTO>>> GetSurveyOverview(int surveyId)
        {
            if (!User.IsInRole("Admin"))
            {
                var surveyorId = await GetCurrentSurveyorIdAsync();
                var isTeamLead = User.IsInRole("Team Lead") && surveyorId.HasValue && await _context.surveys.AnyAsync(survey =>
                    survey.surveyId == surveyId && survey.surveyorId == surveyorId.Value
                );
                if (!isTeamLead)
                    return Forbid();
            }

            var assessments = await ProjectAssessments(
                _context.complianceAssessments.Where(ca => ca.surveyId == surveyId)
            ).ToListAsync();
            return Ok(assessments);
        }

        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<ComplianceAssessmentDTO>> GetById(int id)
        {
            var assessment = await _context
                .complianceAssessments.Where(ca => ca.complianceAssessmentId == id)
                .Select(ca => new ComplianceAssessmentDTO
                {
                    complianceAssessmentId = ca.complianceAssessmentId,
                    surveyId = ca.surveyId,
                    surveyorId = ca.surveyorId,
                    surveyorName = $"{ca.surveyor!.user!.firstName} {ca.surveyor.user.lastName}",
                    complianceId = ca.complianceId,
                    complianceNumber = ca.compliance!.complianceNumber,
                    complianceSummary = ca.compliance!.complianceSummary,
                    scoreId = ca.scoreId,
                    scoreValue = ca.score != null ? ca.score.scoreValue : null,
                    scoreLabel = ca.score != null ? ca.score.scoreLabel : null,
                    riskRatingId = ca.riskRatingId,
                    riskValue = ca.riskRating != null ? ca.riskRating.riskValue : null,
                    complianceComments = ca.complianceComments,
                })
                .FirstOrDefaultAsync();

            if (assessment == null)
                return NotFound();

            return Ok(assessment);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<IActionResult> Update(int id, ComplianceAssessmentUpdateDTO dto)
        {
            var assessment = await _context
                .complianceAssessments.Include(ca => ca.survey)
                    .ThenInclude(s => s!.surveyType)
                .FirstOrDefaultAsync(ca => ca.complianceAssessmentId == id);

            if (assessment == null)
                return NotFound();

            if (assessment.survey!.isCancelled)
                return BadRequest("This survey has been cancelled and can no longer be updated.");

            if (!await CanUpdateAsync(assessment))
                return Forbid();

            var reportSubmitted = await _context.surveyorReports.AnyAsync(report =>
                report.surveyId == assessment.surveyId
                && report.surveyorId == assessment.surveyorId
                && report.isSubmitted);
            if (reportSubmitted)
                return BadRequest("Your surveyor report has been submitted. Ask the Team Lead or an Administrator to reopen it before changing this assessment.");

            if (dto.surveyorId.HasValue)
            {
                var surveyorExists = await _context.surveyors.AnyAsync(s =>
                    s.surveyorId == dto.surveyorId
                );
                if (!surveyorExists)
                    return BadRequest("surveyorId does not exist.");
                assessment.surveyorId = dto.surveyorId.Value;
            }

            if (dto.scoreId.HasValue)
            {
                var scoreExists = await _context.scores.AnyAsync(s => s.scoreId == dto.scoreId);
                if (!scoreExists)
                    return BadRequest("scoreId does not exist.");
                assessment.scoreId = dto.scoreId;
            }

            if (dto.riskId.HasValue)
            {
                var riskExists = await _context.riskRatings.AnyAsync(r => r.riskId == dto.riskId);
                if (!riskExists)
                    return BadRequest("riskRatingId does not exist.");
                assessment.riskRatingId = dto.riskId;
            }

            if (dto.complianceComments != null)
                assessment.complianceComments = dto.complianceComments;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // Returns the latest Internal self-assessment for the compliance items visible
        // in an External survey. This lets external surveyors compare the facility's
        // own score, risk rating, and comments without exposing unrelated standards.
        [HttpGet("survey/{surveyId}/internal-reference")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<IEnumerable<ComplianceAssessmentDTO>>> GetInternalReferences(
            int surveyId
        )
        {
            var survey = await _context.surveys
                .Include(item => item.surveyType)
                .FirstOrDefaultAsync(item => item.surveyId == surveyId);
            if (survey == null)
                return NotFound();

            if (survey.surveyType!.surveyTypeName != "External")
                return Ok(Enumerable.Empty<ComplianceAssessmentDTO>());

            var visibleAssessments = _context.complianceAssessments.Where(assessment =>
                assessment.surveyId == surveyId
            );
            if (!User.IsInRole("Admin"))
            {
                var surveyorId = await GetCurrentSurveyorIdAsync();
                if (!surveyorId.HasValue)
                    return Forbid();

                var isTeamLead = survey.surveyorId == surveyorId.Value;
                if (!isTeamLead)
                    visibleAssessments = visibleAssessments.Where(assessment =>
                        assessment.surveyorId == surveyorId.Value
                    );
            }

            var visibleComplianceIds = await visibleAssessments
                .Select(assessment => assessment.complianceId)
                .ToListAsync();
            if (visibleComplianceIds.Count == 0)
                return Ok(Enumerable.Empty<ComplianceAssessmentDTO>());

            var latestInternalSurveyId = await _context.surveys
                .Where(item =>
                    item.facilityId == survey.facilityId
                    && item.surveyType!.surveyTypeName == "Internal"
                )
                .OrderByDescending(item => item.startDate)
                .Select(item => (int?)item.surveyId)
                .FirstOrDefaultAsync();
            if (!latestInternalSurveyId.HasValue)
                return Ok(Enumerable.Empty<ComplianceAssessmentDTO>());

            var references = await ProjectAssessments(
                _context.complianceAssessments.Where(assessment =>
                    assessment.surveyId == latestInternalSurveyId.Value
                    && visibleComplianceIds.Contains(assessment.complianceId)
                )
            ).ToListAsync();
            return Ok(references);
        }

        [HttpGet("{id}/self-assessment")]
        [Authorize]
        public async Task<ActionResult<ComplianceAssessmentDTO>> GetSelfAssessment(int id)
        {
            var externalAssessment = await _context
                .complianceAssessments.Include(ca => ca.survey)
                .FirstOrDefaultAsync(ca => ca.complianceAssessmentId == id);

            if (externalAssessment == null)
                return NotFound();

            var internalAssessment = await _context
                .complianceAssessments.Where(ca =>
                    ca.complianceId == externalAssessment.complianceId
                    && ca.survey!.facilityId == externalAssessment.survey!.facilityId
                    && ca.survey.surveyType!.surveyTypeName == "Internal"
                )
                .OrderByDescending(ca => ca.survey!.startDate)
                .Select(ca => new ComplianceAssessmentDTO
                {
                    complianceAssessmentId = ca.complianceAssessmentId,
                    surveyId = ca.surveyId,
                    surveyorId = ca.surveyorId,
                    surveyorName = $"{ca.surveyor!.user!.firstName} {ca.surveyor.user.lastName}",
                    complianceId = ca.complianceId,
                    complianceNumber = ca.compliance!.complianceNumber,
                    complianceSummary = ca.compliance!.complianceSummary,
                    scoreId = ca.scoreId,
                    scoreValue = ca.score != null ? ca.score.scoreValue : null,
                    scoreLabel = ca.score != null ? ca.score.scoreLabel : null,
                    riskRatingId = ca.riskRatingId,
                    riskValue = ca.riskRating != null ? ca.riskRating.riskValue : null,
                    complianceComments = ca.complianceComments,
                })
                .FirstOrDefaultAsync();

            if (internalAssessment == null)
                return NotFound("No self-assessment found for this facility/compliance.");

            return Ok(internalAssessment);
        }
    }
}
