using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.FacilitySurvey;
using backend.Models.Assessment;
using backend.Models.FaciltitySurvey;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.FacilitySurvey
{
    [Route("api/surveys")]
    [ApiController]
    public class SurveyController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public SurveyController(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        private async Task<double?> CalculateSurveyGradeAsync(int surveyId)
        {
            var scores = await _context.complianceAssessments
                .Where(ca => ca.surveyId == surveyId)
                .Select(ca => new { ca.scoreId, scoreValue = ca.score!.scoreValue })
                .ToListAsync();

            if (scores.Count == 0 || scores.Any(score => score.scoreId == null))
                return null;

            var scoreValues = scores
                .Where(score => score.scoreValue != null)
                .Select(score => score.scoreValue!.Value)
                .ToList();
            if (scoreValues.Count == 0)
                return null;

            const int maxPerItem = 2;
            var totalScore = scoreValues.Sum();
            var maxPossible = scoreValues.Count * maxPerItem;
            return (double)totalScore / maxPossible * 100;
        }

        // Only relevant at survey CREATION — checks whether an External survey
        // is allowed to start, based on the facility's most recent Internal survey.
        private async Task<string?> ValidateExternalSurveyPrerequisite(
            int facilityId,
            int surveyTypeId
        )
        {
            var surveyType = await _context.surveyTypes.FindAsync(surveyTypeId);
            if (surveyType == null)
                return "Invalid Survey Type.";

            if (surveyType.surveyTypeName != "External")
                return null;

            var mostRecentInternal = await _context
                .surveys.Where(s =>
                    s.facilityId == facilityId && s.surveyType!.surveyTypeName == "Internal"
                )
                .OrderByDescending(s => s.startDate)
                .FirstOrDefaultAsync();

            if (mostRecentInternal == null)
                return "This facility has no Internal survey on record. Complete an Internal self-assessment first.";

            var grade = await CalculateSurveyGradeAsync(mostRecentInternal.surveyId);
            var threshold = _config.GetValue<double>(
                "SurveyRules:InternalPassingThresholdPercentage",
                70
            );

            if (grade == null)
                return "The facility's most recent Internal survey has not been fully scored yet.";

            if (grade < threshold)
                return $"The facility's most recent Internal survey scored {grade:F1}%, below the required {threshold}% to proceed with an External survey.";

            return null;
        }

        // GET: api/Survey
        [HttpGet]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<IEnumerable<SurveyDTO>>> GetSurveys()
        {
            var surveys = await _context
                .surveys.Select(s => new SurveyDTO
                {
                    surveyId = s.surveyId,
                    facilityId = s.facilityId,
                    facilityName = s.facility!.facilityName,
                    surveyTypeId = s.surveyTypeId,
                    surveyTypeName = s.surveyType!.surveyTypeName,
                    surveyorId = s.surveyorId,
                    surveyorName = $"{s.surveyor!.user!.firstName} {s.surveyor!.user!.lastName}",
                    startDate = s.startDate,
                    endDate = s.endDate,
                    isCancelled = s.isCancelled,
                    cancellationReason = s.cancellationReason,
                    cancelledAt = s.cancelledAt,
                    cancelledByUsername = s.cancelledByUsername,
                })
                .ToListAsync();

            return Ok(surveys);
        }

        // GET: api/Survey/5
        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<SurveyDTO>> GetSurvey(int id)
        {
            var survey = await _context
                .surveys.Where(s => s.surveyId == id)
                .Select(s => new SurveyDTO
                {
                    surveyId = s.surveyId,
                    facilityId = s.facilityId,
                    facilityName = s.facility!.facilityName,
                    surveyTypeId = s.surveyTypeId,
                    surveyTypeName = s.surveyType!.surveyTypeName,
                    surveyorId = s.surveyorId,
                    surveyorName = $"{s.surveyor!.user!.firstName} {s.surveyor!.user!.lastName}",
                    startDate = s.startDate,
                    endDate = s.endDate,
                    isCancelled = s.isCancelled,
                    cancellationReason = s.cancellationReason,
                    cancelledAt = s.cancelledAt,
                    cancelledByUsername = s.cancelledByUsername,
                })
                .FirstOrDefaultAsync();

            if (survey == null)
            {
                return NotFound();
            }

            return Ok(survey);
        }

        // PUT: api/Survey/5
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutSurvey(int id, SurveyUpdateDTO dto)
        {
            if (dto.endDate < dto.startDate)
                return BadRequest("End Date cannot be before Start Date.");

            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
            {
                return NotFound();
            }
            if (survey.isCancelled)
                return BadRequest("A cancelled survey cannot be edited.");

            var surveyTypeExists = await _context.surveyTypes.AnyAsync(type =>
                type.surveyTypeId == dto.surveyTypeId
            );
            if (!surveyTypeExists)
                return BadRequest("surveyTypeId does not exist.");

            var surveyorExists = await _context.surveyors.AnyAsync(surveyor =>
                surveyor.surveyorId == dto.surveyorId
            );
            if (!surveyorExists)
                return BadRequest("surveyorId does not exist.");

            survey.surveyTypeId = dto.surveyTypeId;
            survey.surveyorId = dto.surveyorId;
            survey.startDate = dto.startDate;
            survey.endDate = dto.endDate;

            // Standards without a dedicated assignment remain the responsibility
            // of the team lead when the lead changes.
            var dedicatedStandardIds = await _context.surveyStandardAssignments
                .Where(assignment => assignment.surveyId == id)
                .Select(assignment => assignment.standardId)
                .ToListAsync();
            var leadAssessments = await _context
                .complianceAssessments.Include(assessment => assessment.compliance)
                    .ThenInclude(compliance => compliance!.criterion)
                .Where(assessment =>
                    assessment.surveyId == id
                    && !dedicatedStandardIds.Contains(
                        assessment.compliance!.criterion!.standardId
                    )
                )
                .ToListAsync();
            foreach (var assessment in leadAssessments)
                assessment.surveyorId = dto.surveyorId;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SurveyExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpPatch("{id}/team-lead")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> ReassignTeamLead(int id, SurveyReassignTeamLeadDTO dto)
        {
            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
            {
                return NotFound();
            }
            if (survey.isCancelled)
                return BadRequest("A cancelled survey cannot be edited.");

            var surveyorExists = await _context.surveyors.AnyAsync(s =>
                s.surveyorId == dto.surveyorId
            );
            if (!surveyorExists)
                return BadRequest("surveyorId does not exist.");

            survey.surveyorId = dto.surveyorId;
            var dedicatedStandardIds = await _context.surveyStandardAssignments
                .Where(assignment => assignment.surveyId == id)
                .Select(assignment => assignment.standardId)
                .ToListAsync();
            var leadAssessments = await _context
                .complianceAssessments.Include(assessment => assessment.compliance)
                    .ThenInclude(compliance => compliance!.criterion)
                .Where(assessment =>
                    assessment.surveyId == id
                    && !dedicatedStandardIds.Contains(
                        assessment.compliance!.criterion!.standardId
                    )
                )
                .ToListAsync();
            foreach (var assessment in leadAssessments)
                assessment.surveyorId = dto.surveyorId;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // POST: api/Survey
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<SurveyDTO>> PostSurvey(SurveyCreateDTO dto)
        {
            if (dto.endDate < dto.startDate)
                return BadRequest("End Date cannot be before Start Date.");

            var gateError = await ValidateExternalSurveyPrerequisite(
                dto.facilityId,
                dto.surveyTypeId
            );
            if (gateError != null)
                return BadRequest(gateError);

            var surveyModel = new Survey
            {
                facilityId = dto.facilityId,
                surveyTypeId = dto.surveyTypeId,
                surveyorId = dto.surveyorId,
                startDate = dto.startDate,
                endDate = dto.endDate,
            };

            _context.surveys.Add(surveyModel);
            await _context.SaveChangesAsync();

            surveyModel = await _context
                .surveys.Include(s => s.facility)
                .Include(s => s.surveyType)
                .Include(s => s.surveyor)
                    .ThenInclude(sv => sv!.user)
                .FirstOrDefaultAsync(s => s.surveyId == surveyModel.surveyId);

            if (surveyModel is null)
            {
                return Problem("Survey was created but could not be reloaded.");
            }

            var compliances = await _context
                .compliances.Where(c => c.isApplicable)
                .Include(c => c.evidence)
                .ToListAsync();

            foreach (var compliance in compliances)
            {
                var assessment = new ComplianceAssessment
                {
                    surveyId = surveyModel.surveyId,
                    complianceId = compliance.complianceId,
                    surveyorId = surveyModel.surveyorId,
                };

                _context.complianceAssessments.Add(assessment);
                await _context.SaveChangesAsync();

                var checks = compliance
                    .evidence!.Where(e => e.isApplicable)
                    .Select(e => new ComplianceEvidenceCheck
                    {
                        complianceAssessmentId = assessment.complianceAssessmentId,
                        evidenceId = e.evidenceId,
                        isChecked = false,
                    });

                _context.complianceEvidenceChecks.AddRange(checks);
            }

            await _context.SaveChangesAsync();

            var surveyDto = new SurveyDTO
            {
                surveyId = surveyModel.surveyId,
                facilityId = surveyModel.facilityId,
                facilityName = surveyModel.facility!.facilityName,
                surveyTypeId = surveyModel.surveyTypeId,
                surveyTypeName = surveyModel.surveyType!.surveyTypeName,
                surveyorId = surveyModel.surveyorId,
                surveyorName =
                    $"{surveyModel.surveyor!.user!.firstName} {surveyModel.surveyor!.user!.lastName}",
                startDate = surveyModel.startDate,
                endDate = surveyModel.endDate,
                isCancelled = surveyModel.isCancelled,
                cancellationReason = surveyModel.cancellationReason,
                cancelledAt = surveyModel.cancelledAt,
                cancelledByUsername = surveyModel.cancelledByUsername,
            };

            return CreatedAtAction(nameof(GetSurvey), new { id = surveyDto.surveyId }, surveyDto);
        }

        [HttpGet("{id}/progress")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<SurveyProgressDTO>> GetSurveyProgress(int id)
        {
            var totalCompliances = await _context.complianceAssessments.CountAsync(ca =>
                ca.surveyId == id
            );
            if (totalCompliances == 0)
                return NotFound("No assessments found for this survey.");

            var unscoredCount = await _context.complianceAssessments.CountAsync(ca =>
                ca.surveyId == id && ca.scoreId == null
            );
            var totalEvidenceChecks = await _context.complianceEvidenceChecks.CountAsync(check =>
                check.complianceAssessment!.surveyId == id
            );
            var checkedEvidenceCount = await _context.complianceEvidenceChecks.CountAsync(check =>
                check.complianceAssessment!.surveyId == id && check.isChecked
            );

            return Ok(
                new SurveyProgressDTO
                {
                    surveyId = id,
                    totalCompliances = totalCompliances,
                    scoredCount = totalCompliances - unscoredCount,
                    unscoredCount = unscoredCount,
                    totalEvidenceChecks = totalEvidenceChecks,
                    checkedEvidenceCount = checkedEvidenceCount,
                    uncheckedEvidenceCount = totalEvidenceChecks - checkedEvidenceCount,
                }
            );
        }

        [HttpGet("{surveyId}/standards/{standardId}/progress")]
        [Authorize(Roles = "Admin,Surveyor,Team Lead")]
        public async Task<ActionResult<StandardProgressDTO>> GetStandardProgress(
            int surveyId,
            int standardId
        )
        {
            var query = _context.complianceAssessments.Where(ca =>
                ca.surveyId == surveyId && ca.compliance!.criterion!.standardId == standardId
            );

            var totalCompliances = await query.CountAsync();
            if (totalCompliances == 0)
                return NotFound("No assessments found for this survey/standard combination.");

            var unscoredCount = await query.CountAsync(ca => ca.scoreId == null);
            var totalEvidenceChecks = await _context.complianceEvidenceChecks.CountAsync(check =>
                check.complianceAssessment!.surveyId == surveyId
                && check.complianceAssessment.compliance!.criterion!.standardId == standardId
            );
            var checkedEvidenceCount = await _context.complianceEvidenceChecks.CountAsync(check =>
                check.complianceAssessment!.surveyId == surveyId
                && check.complianceAssessment.compliance!.criterion!.standardId == standardId
                && check.isChecked
            );

            return Ok(
                new StandardProgressDTO
                {
                    surveyId = surveyId,
                    standardId = standardId,
                    totalCompliances = totalCompliances,
                    scoredCount = totalCompliances - unscoredCount,
                    unscoredCount = unscoredCount,
                    totalEvidenceChecks = totalEvidenceChecks,
                    checkedEvidenceCount = checkedEvidenceCount,
                    uncheckedEvidenceCount = totalEvidenceChecks - checkedEvidenceCount,
                }
            );
        }

        // POST: api/surveys/5/reset
        // Keeps the survey checklist intact while returning every response to its initial state.
        [HttpPost("{id}/reset")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> ResetSurvey(int id)
        {
            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
                return NotFound();
            if (survey.isCancelled)
                return BadRequest("A cancelled survey cannot be reset.");

            var assessments = await _context
                .complianceAssessments.Where(ca => ca.surveyId == id)
                .ToListAsync();

            if (assessments.Count == 0)
                return NotFound("No assessments found for this survey.");

            foreach (var assessment in assessments)
            {
                assessment.scoreId = null;
                assessment.riskRatingId = null;
                assessment.complianceComments = null;
            }

            var assessmentIds = assessments.Select(assessment => assessment.complianceAssessmentId);
            var evidenceChecks = await _context
                .complianceEvidenceChecks.Where(check =>
                    assessmentIds.Contains(check.complianceAssessmentId)
                )
                .ToListAsync();

            foreach (var check in evidenceChecks)
                check.isChecked = false;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // Adds framework requirements introduced after the survey was created. Existing
        // findings are never changed, and newly added requirements follow the current
        // standard-to-surveyor assignments.
        [HttpPost("{id}/sync-framework")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> SyncFramework(int id)
        {
            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
                return NotFound();
            if (survey.isCancelled)
                return BadRequest("A cancelled survey cannot be synchronised.");

            var existingComplianceIds = await _context.complianceAssessments
                .Where(assessment => assessment.surveyId == id)
                .Select(assessment => assessment.complianceId)
                .ToListAsync();
            var assignmentByStandard = await _context.surveyStandardAssignments
                .Where(assignment => assignment.surveyId == id)
                .ToDictionaryAsync(assignment => assignment.standardId, assignment => assignment.surveyorId);
            var missingCompliances = await _context.compliances
                .Where(compliance => compliance.isApplicable && !existingComplianceIds.Contains(compliance.complianceId))
                .Include(compliance => compliance.criterion)
                .Include(compliance => compliance.evidence)
                .ToListAsync();

            var additions = missingCompliances.Select(compliance => new
            {
                compliance,
                assessment = new ComplianceAssessment
                {
                    surveyId = id,
                    complianceId = compliance.complianceId,
                    surveyorId = assignmentByStandard.TryGetValue(compliance.criterion!.standardId, out var assignedSurveyorId)
                        ? assignedSurveyorId
                        : survey.surveyorId,
                },
            }).ToList();

            _context.complianceAssessments.AddRange(additions.Select(addition => addition.assessment));
            await _context.SaveChangesAsync();

            var checks = additions.SelectMany(addition => addition.compliance.evidence!
                .Where(evidence => evidence.isApplicable)
                .Select(evidence => new ComplianceEvidenceCheck
                {
                    complianceAssessmentId = addition.assessment.complianceAssessmentId,
                    evidenceId = evidence.evidenceId,
                    isChecked = false,
                }))
                .ToList();
            _context.complianceEvidenceChecks.AddRange(checks);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                addedCompliances = additions.Count,
                addedEvidenceChecks = checks.Count,
                message = additions.Count == 0
                    ? "This survey already contains every applicable framework requirement."
                    : $"Added {additions.Count} newly applicable requirement(s) and {checks.Count} evidence check(s).",
            });
        }

        [HttpPost("{id}/cancel")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> CancelSurvey(int id, SurveyCancelDTO dto)
        {
            if (string.IsNullOrWhiteSpace(dto.cancellationReason))
                return BadRequest("A cancellation reason is required.");

            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
                return NotFound();
            if (survey.isCancelled)
                return BadRequest("This survey has already been cancelled.");

            survey.isCancelled = true;
            survey.cancellationReason = dto.cancellationReason.Trim();
            survey.cancelledAt = DateTime.UtcNow;
            survey.cancelledByUsername = User.Identity?.Name;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpGet("{id}/standard-assignments")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<IEnumerable<SurveyStandardAssignmentDTO>>> GetStandardAssignments(int id)
        {
            if (!await _context.surveys.AnyAsync(survey => survey.surveyId == id))
                return NotFound();

            var assignments = await _context.surveyStandardAssignments
                .Where(assignment => assignment.surveyId == id)
                .OrderBy(assignment => assignment.standard!.standardNumber)
                .Select(assignment => new SurveyStandardAssignmentDTO
                {
                    standardId = assignment.standardId,
                    standardNumber = assignment.standard!.standardNumber,
                    standardTitle = assignment.standard.standardTitle,
                    surveyorId = assignment.surveyorId,
                    surveyorName = $"{assignment.surveyor!.user!.firstName} {assignment.surveyor.user.lastName}",
                })
                .ToListAsync();

            return Ok(assignments);
        }

        [HttpPut("{id}/standard-assignments")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutStandardAssignments(
            int id,
            List<SurveyStandardAssignmentUpdateDTO> dto
        )
        {
            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
                return NotFound();
            if (survey.isCancelled)
                return BadRequest("A cancelled survey cannot be edited.");

            if (dto.GroupBy(assignment => assignment.standardId).Any(group => group.Count() > 1))
                return BadRequest("Each standard can be assigned to only one surveyor per survey.");

            var requestedStandardIds = dto.Select(assignment => assignment.standardId).ToList();
            var validStandardCount = await _context.standards.CountAsync(standard =>
                requestedStandardIds.Contains(standard.standardId)
            );
            if (validStandardCount != requestedStandardIds.Count)
                return BadRequest("One or more standards do not exist.");

            var requestedSurveyorIds = dto.Select(assignment => assignment.surveyorId).Distinct().ToList();
            var validSurveyorCount = await _context.surveyors.CountAsync(surveyor =>
                requestedSurveyorIds.Contains(surveyor.surveyorId)
            );
            if (validSurveyorCount != requestedSurveyorIds.Count)
                return BadRequest("One or more surveyors do not exist.");

            var existingAssignments = await _context.surveyStandardAssignments
                .Where(assignment => assignment.surveyId == id)
                .ToListAsync();
            _context.surveyStandardAssignments.RemoveRange(existingAssignments);
            _context.surveyStandardAssignments.AddRange(dto.Select(assignment => new SurveyStandardAssignment
            {
                surveyId = id,
                standardId = assignment.standardId,
                surveyorId = assignment.surveyorId,
            }));

            var assignmentByStandard = dto.ToDictionary(
                assignment => assignment.standardId,
                assignment => assignment.surveyorId
            );
            var assessments = await _context
                .complianceAssessments.Include(assessment => assessment.compliance)
                    .ThenInclude(compliance => compliance!.criterion)
                .Where(assessment => assessment.surveyId == id)
                .ToListAsync();
            foreach (var assessment in assessments)
            {
                var standardId = assessment.compliance!.criterion!.standardId;
                assessment.surveyorId = assignmentByStandard.TryGetValue(standardId, out var surveyorId)
                    ? surveyorId
                    : survey.surveyorId;
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/Survey/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteSurvey(int id)
        {
            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
            {
                return NotFound();
            }

            if (await _context.surveyReportVersions.AnyAsync(version => version.surveyId == id))
            {
                return Conflict("This survey has saved report versions and cannot be deleted. Cancel the survey instead to preserve its reporting history.");
            }

            _context.surveys.Remove(survey);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool SurveyExists(int id)
        {
            return _context.surveys.Any(e => e.surveyId == id);
        }
    }
}
