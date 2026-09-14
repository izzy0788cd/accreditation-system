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
    [Route("api/surveyors")]
    [ApiController]
    public class SurveyorController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SurveyorController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Surveyor
        [HttpGet]
        [Authorize]
        public async Task<ActionResult<IEnumerable<SurveyorDTO>>> GetSurveyors()
        {
            var surveyors = await _context
                .surveyors.Select(sv => new SurveyorDTO
                {
                    surveyorId = sv.surveyorId,
                    userId = sv.userId,
                    firstName = sv.user!.firstName,
                    lastName = sv.user!.lastName,
                    surveyorCertStatusId = sv.surveyorCertStatusId,
                    surveyorCertStatusName = sv.surveyorCertStatus!.surveyorCertStatusName,
                    specializationId = sv.specialization!.specializationId,
                    specializationName = sv.specialization!.specializationName,
                })
                .ToListAsync();

            return Ok(surveyors);
        }

        // GET: api/Surveyor/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<SurveyorDTO>> GetSurveyor(int id)
        {
            var surveyor = await _context
                .surveyors.Where(sv => sv.surveyorId == id)
                .Select(sv => new SurveyorDTO
                {
                    surveyorId = sv.surveyorId,
                    userId = sv.userId,
                    firstName = sv.user!.firstName,
                    lastName = sv.user!.lastName,
                    surveyorCertStatusId = sv.surveyorCertStatusId,
                    surveyorCertStatusName = sv.surveyorCertStatus!.surveyorCertStatusName,
                    specializationId = sv.specialization!.specializationId,
                    specializationName = sv.specialization!.specializationName,
                })
                .FirstOrDefaultAsync();

            if (surveyor == null)
            {
                return NotFound();
            }

            return Ok(surveyor);
        }

        // PUT: api/Surveyor/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutSurveyors(int id, SurveyorUpdateDTO dto)
        {
            var surveyor = await _context.surveyors.FindAsync(id);

            if (surveyor == null)
            {
                return NotFound();
            }

            surveyor.surveyorCertStatusId = dto.surveyorCertStatusId;
            surveyor.specializationId = dto.specializationId;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SurveyorsExists(id))
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

        // POST: api/Surveyor
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<SurveyorDTO>> PostSurveyors(SurveyorCreateDTO dto)
        {
            if (!await _context.users.AnyAsync(user => user.userId == dto.userId))
                return BadRequest("Select a user with a completed profile before registering them as a surveyor.");

            if (await _context.surveyors.AnyAsync(surveyor => surveyor.userId == dto.userId))
                return BadRequest("This user is already registered as a surveyor.");

            if (!await _context.surveyorCertStatuses.AnyAsync(status => status.surveyorCertStatusId == dto.surveyorCertStatusId))
                return BadRequest("Select a valid surveyor certification status.");

            if (!await _context.specializations.AnyAsync(specialization => specialization.specializationId == dto.specializationId))
                return BadRequest("Select a valid surveyor specialisation.");

            var surveyorModel = new Surveyors
            {
                userId = dto.userId,
                surveyorCertStatusId = dto.surveyorCertStatusId,
                specializationId = dto.specializationId,
            };

            _context.surveyors.Add(surveyorModel);
            await _context.SaveChangesAsync();

            surveyorModel = await _context
                .surveyors.Include(sv => sv.user)
                .Include(sv => sv.surveyorCertStatus)
                .Include(sv => sv.specialization)
                .FirstOrDefaultAsync(sv => sv.surveyorId == surveyorModel.surveyorId);

            if (surveyorModel is null)
            {
                return Problem("Surveyor was created but could not be reloaded.");
            }

            var surveyorDto = new SurveyorDTO
            {
                surveyorId = surveyorModel.surveyorId,
                userId = surveyorModel.userId,
                firstName = surveyorModel.user!.firstName,
                lastName = surveyorModel.user!.lastName,
                surveyorCertStatusId = surveyorModel.surveyorCertStatusId,
                surveyorCertStatusName = surveyorModel.surveyorCertStatus!.surveyorCertStatusName,
                specializationId = surveyorModel.specializationId,
                specializationName = surveyorModel.specialization!.specializationName,
            };

            return CreatedAtAction(
                nameof(GetSurveyor),
                new { id = surveyorDto.surveyorId },
                surveyorDto
            );
        }

        // DELETE: api/Surveyor/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteSurveyors(int id)
        {
            var surveyors = await _context.surveyors.FindAsync(id);
            if (surveyors == null)
            {
                return NotFound();
            }

            _context.surveyors.Remove(surveyors);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool SurveyorsExists(int id)
        {
            return _context.surveyors.Any(e => e.surveyorId == id);
        }
    }
}
