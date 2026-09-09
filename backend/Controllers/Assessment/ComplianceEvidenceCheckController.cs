using backend.Data;
using backend.DTOs.Assessment;
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

        [HttpGet("assessment/{complianceAssessmentId}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ComplianceEvidenceCheckDTO>>> GetForAssessment(
            int complianceAssessmentId
        )
        {
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
        [Authorize]
        public async Task<ActionResult<IEnumerable<ComplianceEvidenceCheckDTO>>> GetForSurvey(int surveyId)
        {
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

        [HttpPatch("{id}/checked")]
        [Authorize(Roles = "Admin,Surveyor")]
        public async Task<IActionResult> PatchChecked(int id, [FromBody] bool isChecked)
        {
            var check = await _context.complianceEvidenceChecks.FindAsync(id);
            if (check == null)
                return NotFound();

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
