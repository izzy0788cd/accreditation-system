using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Framework;
using backend.Infrastructure.Paging;
using backend.Models.Framework;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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
        [Authorize(Policy = "ReferenceData.Read")]
        public async Task<IActionResult> GetStandards([FromQuery] PageQuery pageQuery, CancellationToken cancellationToken)
        {
            var standards = _context.standards.AsNoTracking().Select(s => new StandardDTO
                {
                    standardId = s.standardId,
                    functionId = s.functionId,
                    componentId = s.componentId,
                    standardNumber = s.standardNumber,
                    standardTitle = s.standardTitle,
                    componentNumber = s.component!.componentNumber,
                    componentName = s.component!.componentName,
                    functionNumber = s.function!.functionNumber,
                    functionTitle = s.function!.functionTitle,
                    standardSummary = s.standardSummary,
                });

            if (!string.IsNullOrWhiteSpace(pageQuery.Search))
            {
                var pattern = $"%{pageQuery.Search.Trim()}%";
                standards = standards.Where(s => EF.Functions.ILike(s.standardNumber, pattern)
                    || EF.Functions.ILike(s.standardTitle, pattern)
                    || EF.Functions.ILike(s.standardSummary, pattern));
            }
            standards = pageQuery.Sort?.ToLowerInvariant() switch
            {
                "title" => pageQuery.IsDescending ? standards.OrderByDescending(s => s.standardTitle) : standards.OrderBy(s => s.standardTitle),
                "component" => pageQuery.IsDescending ? standards.OrderByDescending(s => s.componentNumber) : standards.OrderBy(s => s.componentNumber),
                _ => pageQuery.IsDescending ? standards.OrderByDescending(s => s.standardNumber) : standards.OrderBy(s => s.standardNumber),
            };

            return pageQuery.IsPaged
                ? Ok(await standards.ToPagedResultAsync(pageQuery, cancellationToken))
                : Ok(await standards.ToListAsync(cancellationToken));
        }

        // GET: api/Standard/5
        [HttpGet("{id}")]
        [Authorize(Policy = "ReferenceData.Read")]
        public async Task<ActionResult<StandardDTO>> GetStandard(int id)
        {
            var standard = await _context
                .standards.Where(s => s.standardId == id)
                .Select(s => new StandardDTO
                {
                    standardId = s.standardId,
                    functionId = s.functionId,
                    componentId = s.componentId,
                    standardNumber = s.standardNumber,
                    standardTitle = s.standardTitle,
                    componentNumber = s.component!.componentNumber,
                    componentName = s.component!.componentName,
                    functionNumber = s.function!.functionNumber,
                    functionTitle = s.function!.functionTitle,
                    standardSummary = s.standardSummary,
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
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<IActionResult> PutStandard(int id, StandardUpdateDTO dto)
        {
            var standard = await _context.standards.FindAsync(id);

            if (standard == null)
            {
                return NotFound();
            }

            standard.standardNumber = dto.standardNumber;
            standard.standardTitle = dto.standardTitle;
            standard.componentId = dto.componentId;
            standard.functionId = dto.functionId;
            standard.standardSummary = dto.standardSummary;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!StandardExists(id))
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

        // POST: api/Standard
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Policy = "ReferenceData.Manage")]
        public async Task<ActionResult<StandardDTO>> PostStandard(StandardCreateDTO dto)
        {
            var standardModel = new Standard
            {
                standardNumber = dto.standardNumber,
                standardTitle = dto.standardTitle,
                componentId = dto.componentId,
                functionId = dto.functionId,
                standardSummary = dto.standardSummary,
            };

            _context.standards.Add(standardModel);
            await _context.SaveChangesAsync();

            standardModel = await _context
                .standards.Include(s => s.component)
                .Include(s => s.function)
                .FirstOrDefaultAsync(s => s.standardId == standardModel.standardId);

            if (
                standardModel is null
                || standardModel.component is null
                || standardModel.function is null
            )
            {
                return NotFound();
            }

            var standardDto = new StandardDTO
            {
                standardId = standardModel.standardId,
                functionId = standardModel.functionId,
                componentId = standardModel.componentId,
                standardNumber = standardModel.standardNumber,
                standardTitle = standardModel.standardTitle,
                componentNumber = standardModel.component.componentNumber,
                componentName = standardModel.component!.componentName,
                functionNumber = standardModel.function.functionNumber,
                functionTitle = standardModel.function!.functionTitle,
                standardSummary = standardModel.standardSummary,
            };

            return CreatedAtAction("GetStandard", new { id = standardDto.standardId }, standardDto);
        }

        // DELETE: api/Standard/5
        [HttpDelete("{id}")]
        [Authorize(Policy = "ReferenceData.Manage")]
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
