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

namespace backend.Controllers_FacilitySurvey
{
    [Route("api/specializations")]
    [ApiController]
    public class SpecializationController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SpecializationController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Specialization
        [HttpGet]
        [Authorize]
        public async Task<ActionResult<IEnumerable<SpecializationDTO>>> GetSpecializations()
        {
            var specializations = await _context
                .specializations.Select(sp => new SpecializationDTO
                {
                    specializationName = sp.specializationName,
                    description = sp.description,
                })
                .ToListAsync();

            return Ok(specializations);
        }

        // GET: api/Specialization/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<SpecializationDTO>> GetSpecialization(int id)
        {
            var specialization = await _context
                .specializations.Where(sp => sp.specializationId == id)
                .Select(sp => new SpecializationDTO
                {
                    specializationName = sp.specializationName,
                    description = sp.description,
                })
                .FirstOrDefaultAsync();

            if (specialization == null)
            {
                return NotFound();
            }

            return Ok(specialization);
        }

        // PUT: api/Specialization/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutSpecialization(int id, SpecializationUpdateDTO dto)
        {
            var specialization = await _context.specializations.FindAsync(id);

            if (specialization == null)
            {
                return NotFound();
            }

            specialization.specializationName = dto.specializationName;
            specialization.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SpecializationExists(id))
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

        // POST: api/Specialization
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<SpecializationDTO>> PostSpecialization(
            SpecializationCreateDTO dto
        )
        {
            var specializationModel = new Specialization
            {
                specializationName = dto.specializationName,
                description = dto.description,
            };

            _context.specializations.Add(specializationModel);
            await _context.SaveChangesAsync();

            var specializationDto = new SpecializationDTO
            {
                specializationName = specializationModel.specializationName,
                description = specializationModel.description,
            };

            return CreatedAtAction(
                "GetSpecialization",
                new { id = specializationDto.specializationId },
                specializationDto
            );
        }

        // DELETE: api/Specialization/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteSpecialization(int id)
        {
            var specialization = await _context.specializations.FindAsync(id);
            if (specialization == null)
            {
                return NotFound();
            }

            _context.specializations.Remove(specialization);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool SpecializationExists(int id)
        {
            return _context.specializations.Any(e => e.specializationId == id);
        }
    }
}
