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
    [Route("api/compliances")]
    [ApiController]
    public class ComplianceController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ComplianceController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Compliance
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ComplianceDTO>>> GetCompliances()
        {
            var compliances = await _context.compliances.Select(co => new ComplianceDTO
            {
                complianceId = co.complianceId,
                complianceNumber = co.complianceNumber,
                complianceSummary = co.complianceSummary,
                criterionId = co.criterion!.criterionId,
                criterionNumber = co.criterion!.criterionNumber,
                isApplicable = co.isApplicable
            })
            .ToListAsync();

            return Ok(compliances);
        }

        // GET: api/Compliance/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ComplianceDTO>> GetCompliance(int id)
        {
            var compliance = await _context.compliances
                .Where(co => co.complianceId == id)
                .Select(co => new ComplianceDTO
                {
                    complianceId = co.complianceId,
                    complianceNumber= co.complianceNumber,
                    complianceSummary = co.complianceSummary,
                    criterionId = co.criterion!.criterionId,
                    criterionNumber = co.criterion!.criterionNumber,
                    isApplicable = co.isApplicable
                })
                .FirstOrDefaultAsync();

            if (compliance == null)
            {
                return NotFound();
            }

            return Ok(compliance);
        }

        // PUT: api/Compliance/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCompliance(int id, ComplianceUpdateDTO dto)
        {
            var compliance = await _context.compliances.FindAsync(id);

            if (compliance == null)
            {
                return NotFound();
            }

            compliance.complianceNumber = dto.complianceNumber;
            compliance.complianceSummary = dto.complianceSummary;
            compliance.criterionId = dto.criterionId;
            //compliance.isApplicable = dto.isApplicable;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ComplianceExists(id))
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

        // PATCH: api/compliance/1/applicability
        [HttpPatch("{id}/applicability")]
        public async Task<IActionResult> PatchEvidenceApplicability(int id, [FromBody] bool isApplicable)
        {
            var compliance = await _context.compliances
                .Include(co => co.evidence)
                .FirstOrDefaultAsync(co => co.complianceId == id);

            if (compliance == null)
            {
                return NotFound();
            }

            compliance.isApplicable = isApplicable;

            if (compliance.evidence != null)
            {
                foreach (var ev in compliance.evidence)
                {
                    ev.isApplicable = isApplicable;
                }
            }

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                throw;
            }

            return NoContent();
        }

        // POST: api/Compliance
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<ComplianceDTO>> PostCompliance(ComplianceCreateDTO dto)
        {
            var complianceModel = new Compliance
            {
                complianceNumber = dto.complianceNumber,
                complianceSummary = dto.complianceSummary,
                criterionId = dto.criterionId,
                isApplicable = true
            };

            _context.compliances.Add(complianceModel);
            await _context.SaveChangesAsync();

            complianceModel = await _context.compliances
                .Include(co => co.criterion)
                .FirstOrDefaultAsync(co => co.complianceId == complianceModel.complianceId);
                
            if (complianceModel is null || complianceModel.criterion is null)
            {
                return NotFound();
            }
            
            var complianceDto = new ComplianceDTO
            {
                complianceId = complianceModel.complianceId,
                complianceNumber = complianceModel.complianceNumber,
                complianceSummary = complianceModel.complianceSummary,
                criterionId = complianceModel.criterion!.criterionId,
                criterionNumber = complianceModel.criterion!.criterionNumber,
                isApplicable = complianceModel.isApplicable
            };

            return CreatedAtAction("GetCompliance", new { id = complianceDto.complianceId }, complianceDto);
        }

        // DELETE: api/Compliance/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCompliance(int id)
        {
            var compliance = await _context.compliances.FindAsync(id);
            if (compliance == null)
            {
                return NotFound();
            }

            _context.compliances.Remove(compliance);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ComplianceExists(int id)
        {
            return _context.compliances.Any(e => e.complianceId == id);
        }
    }
}
