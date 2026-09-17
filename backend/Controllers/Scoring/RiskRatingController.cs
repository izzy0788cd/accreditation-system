using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Scoring;
using backend.Models.Scoring;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Scoring
{
    [Route("api/riskRating")]
    [ApiController]
    public class RiskRatingController : ControllerBase
    {
        private readonly AppDbContext _context;

        public RiskRatingController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/RiskRating
        [HttpGet]
        [Authorize(Policy = "ReferenceData.Read")]
        public async Task<ActionResult<IEnumerable<RiskRatingDTO>>> GetRiskRatings()
        {
            var riskRatings = await _context
                .riskRatings.Select(r => new RiskRatingDTO
                {
                    riskId = r.riskId,
                    riskValue = r.riskValue,
                    riskLabel = r.riskLabel,
                    severityOrder = r.severityOrder,
                    description = r.description,
                })
                .ToListAsync();

            return Ok(riskRatings);
        }

        // GET: api/RiskRating/5
        [HttpGet("{id}")]
        [Authorize(Policy = "ReferenceData.Read")]
        public async Task<ActionResult<RiskRatingDTO>> GetRiskRating(int id)
        {
            var riskRating = await _context
                .riskRatings.Where(r => r.riskId == id)
                .Select(r => new RiskRatingDTO
                {
                    riskId = r.riskId,
                    riskValue = r.riskValue,
                    severityOrder = r.severityOrder,
                    description = r.description,
                })
                .FirstOrDefaultAsync();

            if (riskRating == null)
            {
                return NotFound();
            }

            return Ok(riskRating);
        }

        // PUT: api/RiskRating/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<IActionResult> PutRiskRating(int id, RiskRatingUpdateDTO dto)
        {
            var riskRating = await _context.riskRatings.FindAsync(id);

            if (riskRating == null)
            {
                return NotFound();
            }

            riskRating.riskValue = dto.riskValue;
            riskRating.riskLabel = dto.riskLabel;
            riskRating.severityOrder = dto.severityOrder;
            riskRating.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RiskRatingExists(id))
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

        // POST: api/RiskRating
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<ActionResult<RiskRatingDTO>> PostRiskRating(RiskRatingCreateDTO dto)
        {
            var riskRatingModel = new RiskRating
            {
                riskValue = dto.riskValue,
                riskLabel = dto.riskLabel,
                severityOrder = dto.severityOrder,
                description = dto.description,
            };

            _context.riskRatings.Add(riskRatingModel);
            await _context.SaveChangesAsync();

            var riskRatingDto = new RiskRatingDTO
            {
                riskValue = riskRatingModel.riskValue,
                riskLabel = riskRatingModel.riskLabel,
                severityOrder = riskRatingModel.severityOrder,
                description = riskRatingModel.description,
            };

            return CreatedAtAction(
                "GetRiskRating",
                new { id = riskRatingDto.riskId },
                riskRatingDto
            );
        }

        // DELETE: api/RiskRating/5
        [HttpDelete("{id}")]
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<IActionResult> DeleteRiskRating(int id)
        {
            var riskRating = await _context.riskRatings.FindAsync(id);
            if (riskRating == null)
            {
                return NotFound();
            }

            _context.riskRatings.Remove(riskRating);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RiskRatingExists(int id)
        {
            return _context.riskRatings.Any(e => e.riskId == id);
        }
    }
}
