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
    [Route("api/provinces")]
    [ApiController]
    public class ProvinceController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ProvinceController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Province
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProvinceDTO>>> GetProvinces()
        {
            return await _context.provinces.Select(p => new ProvinceDTO
            {
                provinceId = p.provinceId,
                provinceName = p.provinceName,
                regionId = p.region!.regionId,
                regionName = p.region!.regionName
            })
            .ToListAsync();
        }

        // GET: api/Province/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ProvinceDTO>> GetProvince(int id)
        {
            var province = await _context.provinces
                .Where(p => p.provinceId == id)
                .Select(p => new ProvinceDTO
                {
                    provinceId = p.provinceId,
                    regionId = p.region!.regionId,
                    provinceName = p.provinceName,
                    regionName = p.region!.regionName
                })
                .FirstOrDefaultAsync();

            if (province == null)
            {
                return NotFound();
            }

            return Ok(province);
        }

        // PUT: api/Province/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProvince(int id, ProvinceUpdateDTO dto)
        {
            var province = await _context.provinces.FindAsync(id);

            if (province == null)
            {
                return NotFound();
            }

            province.provinceName = dto.provinceName;
            province.regionId = dto.regionId;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProvinceExists(id))
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

        // POST: api/Province
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Province>> PostProvince(ProvinceCreateDTO dto)
        {
            var provinceModel = new Province
            {
                provinceName = dto.provinceName,
                regionId = dto.regionId,
            };

            _context.provinces.Add(provinceModel);
            await _context.SaveChangesAsync();

            provinceModel = await _context.provinces
                .Include(p => p.region)
                .FirstOrDefaultAsync(p => p.provinceId == provinceModel.provinceId);
            
            if (provinceModel is null || provinceModel.region is null)
            {
                return NotFound();
            }

            var provinceDto = new ProvinceDTO
            {
                provinceId = provinceModel.provinceId,
                provinceName = provinceModel.provinceName,
                regionId = provinceModel.region!.regionId,
                regionName = provinceModel.region!.regionName,
            };

            return CreatedAtAction("GetProvince", new { id = provinceDto.provinceId }, provinceDto);
        }

        // DELETE: api/Province/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProvince(int id)
        {
            var province = await _context.provinces.FindAsync(id);
            if (province == null)
            {
                return NotFound();
            }

            _context.provinces.Remove(province);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProvinceExists(int id)
        {
            return _context.provinces.Any(e => e.provinceId == id);
        }
    }
}
