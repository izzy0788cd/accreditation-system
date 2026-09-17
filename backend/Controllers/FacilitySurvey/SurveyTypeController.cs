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
    [Route("api/surveyTypes")]
    [ApiController]
    public class SurveyTypeController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SurveyTypeController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/SurveyType
        [HttpGet]
        [Authorize(Policy = "ReferenceData.Read")]
        public async Task<ActionResult<IEnumerable<SurveyTypeDTO>>> GetSurveyTypes()
        {
            var surveyTypes = await _context
                .surveyTypes.Select(st => new SurveyTypeDTO
                {
                    surveyTypeId = st.surveyTypeId,
                    surveyTypeName = st.surveyTypeName,
                    description = st.description,
                })
                .ToListAsync();

            return Ok(surveyTypes);
        }

        // GET: api/SurveyType/5
        [HttpGet("{id}")]
        [Authorize(Policy = "ReferenceData.Read")]
        public async Task<ActionResult<SurveyTypeDTO>> GetSurveyType(int id)
        {
            var surveyType = await _context
                .surveyTypes.Where(st => st.surveyTypeId == id)
                .Select(st => new SurveyTypeDTO
                {
                    surveyTypeId = st.surveyTypeId,
                    surveyTypeName = st.surveyTypeName,
                    description = st.description,
                })
                .FirstOrDefaultAsync();

            if (surveyType == null)
            {
                return NotFound();
            }

            return Ok(surveyType);
        }

        // PUT: api/SurveyType/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<IActionResult> PutSurveyType(int id, SurveyTypeUpdateDTO dto)
        {
            var surveyType = await _context.surveyTypes.FindAsync(id);

            if (surveyType == null)
            {
                return NotFound();
            }

            surveyType.surveyTypeName = dto.surveyTypeName;
            surveyType.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SurveyTypeExists(id))
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

        // POST: api/SurveyType
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<ActionResult<SurveyTypeDTO>> PostSurveyType(SurveyTypeCreateDTO dto)
        {
            var surveyTypeModel = new SurveyType
            {
                surveyTypeName = dto.surveyTypeName,
                description = dto.description,
            };

            _context.surveyTypes.Add(surveyTypeModel);
            await _context.SaveChangesAsync();

            var surveyTypeDto = new SurveyTypeDTO
            {
                surveyTypeId = surveyTypeModel.surveyTypeId,
                surveyTypeName = surveyTypeModel.surveyTypeName,
                description = surveyTypeModel.description,
            };

            return CreatedAtAction(
                nameof(GetSurveyType),
                new { id = surveyTypeDto.surveyTypeId },
                surveyTypeDto
            );
        }

        // DELETE: api/SurveyType/5
        [HttpDelete("{id}")]
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<IActionResult> DeleteSurveyType(int id)
        {
            var surveyType = await _context.surveyTypes.FindAsync(id);
            if (surveyType == null)
            {
                return NotFound();
            }

            _context.surveyTypes.Remove(surveyType);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool SurveyTypeExists(int id)
        {
            return _context.surveyTypes.Any(e => e.surveyTypeId == id);
        }
    }
}
