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
    [Route("api/evidence")]
    [ApiController]
    public class EvidenceController : ControllerBase
    {
        private readonly AppDbContext _context;

        public EvidenceController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Evidence
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EvidenceDTO>>> GetEvidence()
        {
            var evidences = await _context.evidence.Select(e => new EvidenceDTO
            {
                evidenceId = e.evidenceId,
                evidenceNumber = e.evidenceNumber,
                evidenceSummary = e.evidenceSumaary,
                complianceId = e.complianceId,
                isApplicable = e.isApplicable
            })
            .ToListAsync();

            return Ok(evidences);
        }

        // GET: api/Evidence/5
        [HttpGet("{id}")]
        public async Task<ActionResult<EvidenceDTO>> GetEvidence(int id)
        {
            var evidence = await _context.evidence
                .Where(e => e.evidenceId == id)
                .Select(e => new EvidenceDTO
                {
                    evidenceId = e.evidenceId,
                    evidenceNumber = e.evidenceNumber,
                    evidenceSummary = e.evidenceSumaary,
                    complianceId = e.complianceId,
                    isApplicable = e.isApplicable
                })
                .FirstOrDefaultAsync();

            if (evidence == null)
            {
                return NotFound();
            }

            return Ok(evidence);
        }

        // PUT: api/Evidence/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutEvidence(int id, EvidenceUpdateDTO dto)
        {
            var evidence = await _context.evidence.FindAsync(id);

            if (evidence == null)
            {
                return NotFound();
            }

            evidence.evidenceNumber = dto.evidenceNumber;
            evidence.evidenceSumaary = dto.evidenceSummary;
            evidence.complianceId = dto.complianceId;
            evidence.isApplicable = dto.isApplicable;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DBConcurrencyException)
            {
                if (!EvidenceExists(id))
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

        // POST: api/Evidence
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<EvidenceDTO>> PostEvidence(EvidenceCreateDTO dto)
        {
            var evidenceModel = new Evidence
            {
                evidenceNumber = dto.evidenceNumber,
                evidenceSumaary = dto.evidenceSummary,
                complianceId = dto.complianceId,
                isApplicable = true
            };

            _context.evidence.Add(evidenceModel);
            await _context.SaveChangesAsync();

            evidenceModel = await _context.evidence
                .Include(e => e.compliance)
                .FirstOrDefaultAsync(e => e.evidenceId == evidenceModel.evidenceId);

            if (evidenceModel is null || evidenceModel.compliance is null)
            {
                return NotFound();
            }

            var evidenceDto = new EvidenceDTO
            {
                evidenceId = evidenceModel.evidenceId,
                evidenceNumber = evidenceModel.evidenceNumber,
                evidenceSummary =  evidenceModel.evidenceSumaary,
                complianceId = evidenceModel.complianceId,
                isApplicable = evidenceModel.isApplicable
            };

            return CreatedAtAction("GetEvidence", new { id = evidenceDto.evidenceId }, evidenceDto);
        }

        // DELETE: api/Evidence/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvidence(int id)
        {
            var evidence = await _context.evidence.FindAsync(id);
            if (evidence == null)
            {
                return NotFound();
            }

            _context.evidence.Remove(evidence);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool EvidenceExists(int id)
        {
            return _context.evidence.Any(e => e.evidenceId == id);
        }
    }
}
