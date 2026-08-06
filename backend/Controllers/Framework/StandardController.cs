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

namespace backend.Controllers.Framework
{
    [Route("api/standards")]
    [ApiController]
    public class StandardController : ControllerBase
    {
        private readonly AppDbContext _context;

        public StandardController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Standard
        [HttpGet]
        public async Task<ActionResult<IEnumerable<StandardDTO>>> GetStandards()
        {
            var standards = await _context.standards.Select(s => new StandardDTO
            {
                standardId = s.standardId,
                standardTitle = s.standardTitle,
                componentName = s.component!.componentName,
                functionTitle = s.function!.functiontTitle,
                standardSummary = s.standardSummary
            })
            .ToListAsync();

            return Ok(standards);
        }

        // GET: api/Standard/5
        [HttpGet("{id}")]
        public async Task<ActionResult<StandardDTO>> GetStandard(int id)
        {
            var standard = await _context.standards
                .Where(s => s.standardId == id)
                .Select(s => new StandardDTO
                {
                    standardId = s.standardId,
                    standardTitle = s.standardTitle,
                    componentName = s.component!.componentName,
                    functionTitle = s.function!.functiontTitle,
                    standardSummary = s.standardSummary
                })
                .FirstOrDefaultAsync();

            if (standard == null)
            {
                return NotFound();
            }

            return Ok(standard);
        }

        // PUT: api/Standard/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutStandard(int id, StandardUpdateDTO dto)
        {
            var standard = await _context.standards.FindAsync(id);

            if (standard == null)
            {
                return NotFound();
            }

            standard.standardTitle = dto.standardTitle;
            standard.componentId = dto.componentId;
            standard.functionId = dto.functionId;
            standard.standardSummary = dto.standardSummary;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // POST: api/Standard
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<StandardDTO>> PostStandard(StandardCreateDTO dto)
        {
            var standardModel = new Standard
            {
                standardTitle = dto.standardTitle,
                componentId = dto.componentId,
                functionId = dto.functionId,
                standardSummary = dto.standardSummary
            };

            _context.standards.Add(standardModel);
            await _context.SaveChangesAsync();

            standardModel = await _context.standards
                .Include(s => s.component)
                .Include(s => s.function)
                .FirstOrDefaultAsync(s => s.standardId == standardModel.standardId);

            if (standardModel is null || standardModel.component is null || standardModel.function is null)
            {
                return NotFound();
            }
            
            var standardDto = new StandardDTO
            {
                standardId = standardModel.standardId,
                componentName = standardModel.component!.componentName,
                functionTitle = standardModel.function!.functiontTitle,
                standardSummary = standardModel.standardSummary
            };

            return CreatedAtAction("GetStandard", new { id = standardDto.standardId }, standardDto);
        }

        // DELETE: api/Standard/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteStandard(int id)
        {
            var standard = await _context.standards.FindAsync(id);
            if (standard == null)
            {
                return NotFound();
            }

            _context.standards.Remove(standard);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool StandardExists(int id)
        {
            return _context.standards.Any(e => e.standardId == id);
        }
    }
}
