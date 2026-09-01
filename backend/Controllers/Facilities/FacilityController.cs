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
    [Route("api/facilities")]
    [ApiController]
    public class FacilityController : ControllerBase
    {
        private readonly AppDbContext _context;

        public FacilityController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Facility
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FacilityDTO>>> GetFacilities()
        {
            return await _context.facilities.Select(f => new FacilityDTO
            {
                facilityId = f.facilityId,
                facilityName = f.facilityName,
                levelId = f.level!.levelId,
                levelName = f.level!.levelName,
                districtId = f.district!.districtId,
                districtName = f.district!.districtName,
                organizationId = f.organization!.organizationId,
                organizationName = f.organization!.organizationName,
                creditationStatusId = f.creditationStatus!.creditationStatusId,
                creditationStatus = f.creditationStatus!.creditationStatus,
                headOfService = f.headOfService ?? string.Empty,
                comments = f.comments ?? string.Empty
            })
            .ToListAsync();
        }

        // GET: api/Facility/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FacilityDTO>> GetFacility(int id)
        {
            var facility = await _context.facilities
                .Where(f => f.facilityId == id)
                .Select(f => new FacilityDTO
                {
                    facilityId = f.facilityId,
                    facilityName = f.facilityName,
                    levelId = f.level!.levelId,
                    levelName = f.level!.levelName,
                    districtId = f.district!.districtId,
                    districtName = f.district!.districtName,
                    organizationId = f.organization!.organizationId,
                    organizationName = f.organization!.organizationName,
                    creditationStatusId = f.creditationStatus!.creditationStatusId,
                    creditationStatus = f.creditationStatus!.creditationStatus,
                    headOfService = f.headOfService ?? string.Empty,
                    comments = f.comments ?? string.Empty
                })
                .FirstOrDefaultAsync();

            if (facility == null)
            {
                return NotFound();
            }

            return Ok(facility);
        }

        // PUT: api/Facility/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFacility(int id, FacilityUpdateDTO dto)
        {
            var facility = await _context.facilities.FindAsync(id);

            if (facility == null)
            {
                return NotFound();
            }

            facility.facilityName = dto.facilityName;
            facility.levelId = dto.levelId;
            facility.districtId = dto.districtId;
            facility.organizationId = dto.organizationId;
            facility.creditationStatusId = dto.creditationStatusId;
            facility.headOfService = dto.headOfService;
            facility.comments =dto.comments;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FacilityExists(id))
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

        // POST: api/Facility
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<FacilityDTO>> PostFacility(FacilityCreateDTO dto)
        {
            var facilityModel = new Facility
            {
                facilityName = dto.facilityName,
                levelId = dto.levelId,
                districtId = dto.districtId,
                organizationId = dto.organizationId,
                creditationStatusId = dto.creditationStatusId,
                headOfService = dto.headOfService,
                comments =dto.comments,
            };

            _context.facilities.Add(facilityModel);
            await _context.SaveChangesAsync();

            facilityModel = await _context.facilities
                .Include(f => f.level)
                .FirstOrDefaultAsync(f => f.levelId == facilityModel.levelId);

            if (facilityModel is null || facilityModel.level is null)
            {
                return NotFound();
            }

            facilityModel = await _context.facilities
                .Include(f => f.district)
                .FirstOrDefaultAsync(f => f.districtId == facilityModel.districtId);

            if (facilityModel is null || facilityModel.district is null)
            {
                return NotFound();
            }

            facilityModel = await _context.facilities
                .Include(f => f.organization)
                .FirstOrDefaultAsync(f => f.organizationId == facilityModel.organizationId);

            if (facilityModel is null || facilityModel.organization is null)
            {
                return NotFound();
            }

            facilityModel = await _context.facilities
                .Include(f => f.creditationStatus)
                .FirstOrDefaultAsync(f => f.creditationStatusId == facilityModel.creditationStatusId);

            if (facilityModel is null || facilityModel.creditationStatus is null)
            {
                return NotFound();
            }

            var facilityDto = new FacilityDTO
            {
                facilityId = facilityModel.facilityId,
                facilityName = facilityModel.facilityName,
                levelId = facilityModel.level!.levelId,
                levelName = facilityModel.level!.levelName,
                districtId = facilityModel.district!.districtId,
                districtName = facilityModel.district!.districtName,
                organizationId = facilityModel.organization!.organizationId,
                organizationName = facilityModel.organization!.organizationName,
                creditationStatusId = facilityModel.creditationStatus!.creditationStatusId,
                creditationStatus = facilityModel.creditationStatus!.creditationStatus,
                headOfService = facilityModel.headOfService ?? string.Empty,
                comments = facilityModel.comments ?? string.Empty
            };

            return CreatedAtAction("GetFacility", new { id = facilityDto.facilityId }, facilityDto);
        }

        // DELETE: api/Facility/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFacility(int id)
        {
            var facility = await _context.facilities.FindAsync(id);
            if (facility == null)
            {
                return NotFound();
            }

            _context.facilities.Remove(facility);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool FacilityExists(int id)
        {
            return _context.facilities.Any(e => e.facilityId == id);
        }
    }
}
