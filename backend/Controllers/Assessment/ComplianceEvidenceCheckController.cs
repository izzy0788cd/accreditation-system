using backend.Data;
using backend.DTOs.Assessment;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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

        [HttpPatch("{id}/checked")]
        [Authorize]
        public async Task<IActionResult> PatchChecked(int id, [FromBody] bool isChecked)
        {
            var check = await _context.complianceEvidenceChecks.FindAsync(id);
            if (check == null)
                return NotFound();

            check.isChecked = isChecked;
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
