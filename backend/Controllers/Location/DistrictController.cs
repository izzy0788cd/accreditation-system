using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using backend.Data;
using backend.Models.Location;
using backend.DTOs.Location;

namespace backend.Controllers_Location
{
    [Route("api/districts")]
    [ApiController]
    public class DistrictController : ControllerBase
    {
        private readonly AppDbContext _context;

        public DistrictController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/District
        [HttpGet]
        public async Task<ActionResult<IEnumerable<DistrictDTO>>> Getdistricts()
        {
            var districts = await _context.districts.Select(d => new DistrictDTO
            {
                districtId = d.districtId,
                distrctName = d.districtName,
                provinceId = d.province!.provinceId,
                provinceName = d.province!.provinceName,
            })
            .ToListAsync();

            return Ok(districts);
        }

        // GET: api/District/5
        [HttpGet("{id}")]
        public async Task<ActionResult<DistrictDTO>> GetDistrict(int id)
        {
            var district = await _context.districts
                .Where(d => d.districtId == id)
                .Select(d => new DistrictDTO
                {
                    districtId = d.districtId,
                    distrctName = d.districtName,
                    provinceId = d.province!.provinceId,
                    provinceName = d.province!.provinceName,
                })
                .FirstOrDefaultAsync();

            if (district == null)
            {
                return NotFound();
            }

            return Ok(district);
        }

        // PUT: api/District/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDistrict(int id, DistrictUpdateDTO dto)
        {
            var district = await _context.districts.FindAsync(id);

            if (district == null)
            {
                return NotFound();
            }

            district.districtName = dto.districtName;
            district.provinceId = dto.provinceId;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DistrictExists(id))
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

        // POST: api/District
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<DistrictDTO>> PostDistrict(DistrictCreateDTO dto)
        {
            var districtModel = new District
            {
                districtName = dto.districtName,
                provinceId = dto.provinceId,
            };

            _context.districts.Add(districtModel);
            await _context.SaveChangesAsync();

            districtModel = await _context.districts
                .Include(d => d.province)
                .FirstOrDefaultAsync(d => d.districtId == districtModel.districtId);

            if (districtModel is null || districtModel.province is null)
            {
                return NotFound();
            }

            var districtDto = new DistrictDTO
            {
                districtId = districtModel.districtId,
                distrctName = districtModel.districtName,
                provinceId = districtModel.province!.provinceId,
                provinceName = districtModel.province!.provinceName
            };

            return CreatedAtAction("GetDistrict", new { id = districtDto.districtId }, districtDto);
        }

        // DELETE: api/District/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteDistrict(int id)
        {
            var district = await _context.districts.FindAsync(id);
            if (district == null)
            {
                return NotFound();
            }

            _context.districts.Remove(district);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool DistrictExists(int id)
        {
            return _context.districts.Any(e => e.districtId == id);
        }
    }
}
