using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using backend.Data;
using backend.Models.Framework;
using backend.DTOs.Framework;
using System.Data;

namespace backend.Controllers_Framework
{
    [Route("api/criteria")]
    [ApiController]
    public class CriterionController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CriterionController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Criterion
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CriterionDTO>>> GetCriteria()
        {
            var criteria = await _context.criteria.Select(cr => new CriterionDTO
            {
                criterionId = cr.criterionId,
                criterionTitle = cr.criterionTitle,
                standardTitle = cr.standard!.standardTitle,
                isApplicable = cr.isApplicable
            })
            .ToListAsync();

            return Ok(criteria);
        }

        // GET: api/Criterion/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CriterionDTO>> GetCriterion(int id)
        {
            var criterion = await _context.criteria
                .Where(cr => cr.criterionId == id)
                .Select(cr => new CriterionDTO
                {
                    criterionId = cr.criterionId,
                    criterionTitle = cr.criterionTitle,
                    standardTitle = cr.standard!.standardTitle,
                    isApplicable = cr.isApplicable
                })
                .FirstOrDefaultAsync();

            if (criterion == null)
            {
                return NotFound();
            }

            return Ok(criterion);
        }

        // PUT: api/Criterion/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCriterion(int id, CriterionUpdateDTO dto)
        {
            var criterion = await _context.criteria.FindAsync(id);

            if (criterion == null)
            {
                return NotFound();
            }

            criterion.criterionTitle = dto.criterionTitle;
            criterion.standardId = dto.standardId;
            criterion.isApplicable = dto.isApplicable;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DBConcurrencyException)
            {
                if (!CriterionExists(id))
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

        // POST: api/Criterion
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<CriterionDTO>> PostCriterion(CriterionCreateDTO dto)
        {
            var criterionModel = new Criterion
            {
                criterionTitle = dto.criterionTitle,
                standardId = dto.standardId,
                isApplicable = true
            };

            _context.criteria.Add(criterionModel);
            await _context.SaveChangesAsync();

            criterionModel = await _context.criteria
                .Include(cr => cr.standard)
                .FirstOrDefaultAsync(cr => cr.criterionId == criterionModel.criterionId);

            if (criterionModel is null || criterionModel.standard is null)
            {
                return NotFound();
            }

            var criterionDto = new CriterionDTO
            {
                criterionId = criterionModel.criterionId,
                criterionTitle = criterionModel.criterionTitle,
                standardTitle = criterionModel.standard!.standardTitle,
                isApplicable = criterionModel.isApplicable
            };

            return CreatedAtAction("GetCriterion", new { id = criterionDto.criterionId }, criterionDto);
        }

        // DELETE: api/Criterion/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCriterion(int id)
        {
            var criterion = await _context.criteria.FindAsync(id);
            if (criterion == null)
            {
                return NotFound();
            }

            _context.criteria.Remove(criterion);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CriterionExists(int id)
        {
            return _context.criteria.Any(e => e.criterionId == id);
        }
    }
}
