using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Location;
using backend.Models.Location;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers_Location
{
    [Route("api/regions")]
    [ApiController]
    public class RegionController : ControllerBase
    {
        private readonly AppDbContext _context;

        public RegionController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Region
        [HttpGet]
        [Authorize]
        public async Task<ActionResult<IEnumerable<RegionDTO>>> GetRegions()
        {
            return await _context
                .regions.Select(r => new RegionDTO
                {
                    regionId = r.regionId,
                    regionName = r.regionName,
                })
                .ToListAsync();
        }

        // GET: api/Region/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<RegionDTO>> GetRegion(int id)
        {
            var region = await _context
                .regions.Where(r => r.regionId == id)
                .Select(r => new RegionDTO { regionId = r.regionId, regionName = r.regionName })
                .FirstOrDefaultAsync();

            if (region == null)
            {
                return NotFound();
            }

            return region;
        }

        // PUT: api/Region/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutRegion(int id, RegionUpdateDTO dto)
        {
            var region = await _context.regions.FindAsync(id);

            if (region == null)
            {
                return NotFound();
            }

            region.regionName = dto.regionName;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RegionExists(id))
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

        // POST: api/Region
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<RegionDTO>> PostRegion(RegionCreateDTO region)
        {
            var regionModel = new Region { regionName = region.regionName };

            _context.regions.Add(regionModel);
            await _context.SaveChangesAsync();

            var regionDto = new RegionDTO { regionName = regionModel.regionName };

            return CreatedAtAction("GetRegion", new { id = regionDto.regionId }, regionDto);
        }

        // DELETE: api/Region/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteRegion(int id)
        {
            var region = await _context.regions.FindAsync(id);
            if (region == null)
            {
                return NotFound();
            }

            _context.regions.Remove(region);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RegionExists(int id)
        {
            return _context.regions.Any(e => e.regionId == id);
        }
    }
}
