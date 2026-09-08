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
            var scoreValues = await _context
                .complianceAssessments.Where(ca =>
                    ca.surveyId == surveyId && ca.scoreId != null && ca.score!.scoreValue != null
                )
                .Select(ca => ca.score!.scoreValue!.Value)
                .ToListAsync();

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
                "SurveyRules:InternalPassThresholdPercentage",
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
        [Authorize]
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
                })
                .ToListAsync();

            return Ok(surveys);
        }

        // GET: api/Survey/5
        [HttpGet("{id}")]
        [Authorize]
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
        [Authorize]
        public async Task<IActionResult> PutSurvey(int id, SurveyUpdateDTO dto)
        {
            if (dto.endDate < dto.startDate)
                return BadRequest("End Date cannot be before Start Date.");

            var survey = await _context.surveys.FindAsync(id);
            if (survey == null)
            {
                return NotFound();
            }

            survey.surveyTypeId = dto.surveyTypeId;
            survey.startDate = dto.startDate;
            survey.endDate = dto.endDate;

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

            var surveyorExists = await _context.surveyors.AnyAsync(s =>
                s.surveyorId == dto.surveyorId
            );
            if (!surveyorExists)
                return BadRequest("surveyorId does not exist.");

            survey.surveyorId = dto.surveyorId;
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
            };

            return CreatedAtAction(nameof(GetSurvey), new { id = surveyDto.surveyId }, surveyDto);
        }

        [HttpGet("{id}/progress")]
        [Authorize]
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

            return Ok(
                new SurveyProgressDTO
                {
                    surveyId = id,
                    totalCompliances = totalCompliances,
                    scoredCount = totalCompliances - unscoredCount,
                    unscoredCount = unscoredCount,
                }
            );
        }

        [HttpGet("{surveyId}/standards/{standardId}/progress")]
        [Authorize]
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

            return Ok(
                new StandardProgressDTO
                {
                    surveyId = surveyId,
                    standardId = standardId,
                    totalCompliances = totalCompliances,
                    scoredCount = totalCompliances - unscoredCount,
                    unscoredCount = unscoredCount,
                }
            );
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
