using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.FacilitySurvey;
using backend.Models.FaciltitySurvey;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.FacilitySurvey
{
    [Route("api/surveyorCertStatus")]
    [ApiController]
    public class SurveyorCertStatusController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SurveyorCertStatusController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/SurveyorCertStatus
        [HttpGet]
        [Authorize]
        public async Task<
            ActionResult<IEnumerable<SurveyorCertStatusDTO>>
        > GetSurveyorCertStatuses()
        {
            var surveyorCertStatuses = await _context
                .surveyorCertStatuses.Select(sc => new SurveyorCertStatusDTO
                {
                    surveyorCertStatusId = sc.surveyorCertStatusId,
                    surveyorCertStatusName = sc.surveyorCertStatusName,
                    description = sc.description,
                })
                .ToListAsync();

            return Ok(surveyorCertStatuses);
        }

        // GET: api/SurveyorCertStatus/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<SurveyorCertStatusDTO>> GetSurveyorCertStatus(int id)
        {
            var surveyorCertStatus = await _context
                .surveyorCertStatuses.Where(sc => sc.surveyorCertStatusId == id)
                .Select(sc => new SurveyorCertStatusDTO
                {
                    surveyorCertStatusId = sc.surveyorCertStatusId,
                    surveyorCertStatusName = sc.surveyorCertStatusName,
                    description = sc.description,
                })
                .FirstOrDefaultAsync();

            if (surveyorCertStatus == null)
            {
                return NotFound();
            }

            return Ok(surveyorCertStatus);
        }

        // PUT: api/SurveyorCertStatus/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutSurveyorCertStatus(
            int id,
            SurveyorCertStatusUpdateDTO dto
        )
        {
            var surveyorCerttSatus = await _context.surveyorCertStatuses.FindAsync(id);

            if (surveyorCerttSatus == null)
            {
                return NotFound();
            }

            surveyorCerttSatus.surveyorCertStatusName = dto.surveyorCertStatusName;
            surveyorCerttSatus.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SurveyorCertStatusExists(id))
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

        // POST: api/SurveyorCertStatus
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<SurveyorCertStatusDTO>> PostSurveyorCertStatus(
            SurveyorCertStatusCreateDTO dto
        )
        {
            var surveyorCertStatusModel = new SurveyorCertStatus
            {
                surveyorCertStatusName = dto.surveyorCertStatusName,
                description = dto.description,
            };

            _context.surveyorCertStatuses.Add(surveyorCertStatusModel);
            await _context.SaveChangesAsync();

            var surveyorCertStatusDto = new SurveyorCertStatusDTO
            {
                surveyorCertStatusName = surveyorCertStatusModel.surveyorCertStatusName,
                description = surveyorCertStatusModel.description,
            };

            return CreatedAtAction(
                "GetSurveyorCertStatus",
                new { id = surveyorCertStatusDto.surveyorCertStatusId },
                surveyorCertStatusDto
            );
        }

        // DELETE: api/SurveyorCertStatus/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteSurveyorCertStatus(int id)
        {
            var surveyorCertStatus = await _context.surveyorCertStatuses.FindAsync(id);
            if (surveyorCertStatus == null)
            {
                return NotFound();
            }

            _context.surveyorCertStatuses.Remove(surveyorCertStatus);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool SurveyorCertStatusExists(int id)
        {
            return _context.surveyorCertStatuses.Any(e => e.surveyorCertStatusId == id);
        }
    }
}
