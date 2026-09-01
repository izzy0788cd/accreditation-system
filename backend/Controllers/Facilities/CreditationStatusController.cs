using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using backend.Data;
using backend.Models.Facilities;
using backend.DTOs.Facilities;

namespace backend.Controllers.Facilities
{
    [Route("api/creditationstatuses")]
    [ApiController]
    public class CreditationStatusController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CreditationStatusController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/CreditationStatus
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CreditationStatusDTO>>> GetCreditationStatuses()
        {
            return await _context.creditationStatuses.Select(cs => new CreditationStatusDTO
            {
                creditationStatusId = cs.creditationStatusId,
                creditationStatus = cs.creditationStatus,
                description = cs.description,
                comments = cs.comments ?? string.Empty
            })
            .ToListAsync();
        }

        // GET: api/CreditationStatus/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CreditationStatusDTO>> GetCreditationStatus(int id)
        {
            var creditationStatus = await _context.creditationStatuses
                .Where(cs => cs.creditationStatusId == id)
                .Select(cs => new CreditationStatusDTO
                {
                    creditationStatusId = cs.creditationStatusId,
                    creditationStatus = cs.creditationStatus,
                    description = cs.description,
                    comments = cs.comments ?? string.Empty
                })
                .FirstOrDefaultAsync();

            if (creditationStatus == null)
            {
                return NotFound();
            }

            return Ok(creditationStatus);
        }

        // PUT: api/CreditationStatus/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCreditationStatus(int id, CreditationStatusUpdateDTO dto)
        {
            var creditationStatus = await _context.creditationStatuses.FindAsync(id);

            if (creditationStatus == null)
            {
                return NotFound();
            }

            creditationStatus.creditationStatus = dto.creditationStatus;
            creditationStatus.description = dto.description ?? string.Empty;
            creditationStatus.comments = dto.comments ?? string.Empty;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CreditationStatusExists(id))
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

        // POST: api/CreditationStatus
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<CreditationStatusDTO>> PostCreditationStatus(CreditationStatusCreateDTO dto)
        {
            var creditationStatusModel = new CreditationStatus
            {
                creditationStatus = dto.creditationStatus,
                description = dto.desctiption ?? string.Empty,
                comments = dto.comments ?? string.Empty
            };

            _context.creditationStatuses.Add(creditationStatusModel);
            await _context.SaveChangesAsync();

            var creditationStatusDto = new CreditationStatusDTO
            {
                creditationStatus = creditationStatusModel.creditationStatus,
                description = creditationStatusModel.description,
                comments = creditationStatusModel.comments,
            };

            return CreatedAtAction("GetCreditationStatus", new { id = creditationStatusDto.creditationStatusId }, creditationStatusDto);
        }

        // DELETE: api/CreditationStatus/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCreditationStatus(int id)
        {
            var creditationStatus = await _context.creditationStatuses.FindAsync(id);
            if (creditationStatus == null)
            {
                return NotFound();
            }

            _context.creditationStatuses.Remove(creditationStatus);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CreditationStatusExists(int id)
        {
            return _context.creditationStatuses.Any(e => e.creditationStatusId == id);
        }
    }
}
