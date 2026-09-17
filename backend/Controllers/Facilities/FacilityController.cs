using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Facilities;
using backend.Infrastructure.Paging;
using backend.Models.Facilities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Facilities
{
    [Route("api/facilities")]
    [ApiController]
    [Authorize(Policy = "ReferenceData.Read")]
    public class FacilityController : ControllerBase
    {
        private readonly AppDbContext _context;

        public FacilityController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Facility
        [HttpGet]
        public async Task<IActionResult> GetFacilities([FromQuery] PageQuery pageQuery, CancellationToken cancellationToken)
        {
            var facilities = _context.facilities.AsNoTracking().Select(f => new FacilityDTO
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
                    comments = f.comments ?? string.Empty,
                });
            if (!string.IsNullOrWhiteSpace(pageQuery.Search))
            {
                var pattern = $"%{pageQuery.Search.Trim()}%";
                facilities = facilities.Where(f => EF.Functions.ILike(f.facilityName, pattern)
                    || EF.Functions.ILike(f.districtName, pattern)
                    || EF.Functions.ILike(f.organizationName, pattern));
            }
            facilities = pageQuery.Sort?.ToLowerInvariant() switch
            {
                "district" => pageQuery.IsDescending ? facilities.OrderByDescending(f => f.districtName) : facilities.OrderBy(f => f.districtName),
                "level" => pageQuery.IsDescending ? facilities.OrderByDescending(f => f.levelName) : facilities.OrderBy(f => f.levelName),
                _ => pageQuery.IsDescending ? facilities.OrderByDescending(f => f.facilityName) : facilities.OrderBy(f => f.facilityName),
            };
            return pageQuery.IsPaged
                ? Ok(await facilities.ToPagedResultAsync(pageQuery, cancellationToken))
                : Ok(await facilities.ToListAsync(cancellationToken));
        }

        // GET: api/Facility/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FacilityDTO>> GetFacility(int id)
        {
            var facility = await _context
                .facilities.Where(f => f.facilityId == id)
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
                    comments = f.comments ?? string.Empty,
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
        [Authorize(Policy = "ReferenceData.Manage")]
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
            facility.comments = dto.comments;

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
        [Authorize(Policy = "ReferenceData.Manage")]
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
                comments = dto.comments,
            };

            _context.facilities.Add(facilityModel);
            await _context.SaveChangesAsync();

            facilityModel = await _context
                .facilities.Include(f => f.level)
                .Include(f => f.district)
                .Include(f => f.organization)
                .Include(f => f.creditationStatus)
                .FirstOrDefaultAsync(f => f.facilityId == facilityModel.facilityId);

            if (facilityModel is null)
            {
                // Shouldn't happen right after a successful insert, but guard anyway
                return Problem("Facility was created but could not be reloaded.");
            }

            var facilityDto = new FacilityDTO
            {
                facilityId = facilityModel.facilityId,
                facilityName = facilityModel.facilityName,
                levelId = facilityModel.level?.levelId ?? facilityModel.levelId,
                levelName = facilityModel.level?.levelName ?? string.Empty,
                districtId = facilityModel.district?.districtId ?? facilityModel.districtId,
                districtName = facilityModel.district?.districtName ?? string.Empty,
                organizationId =
                    facilityModel.organization?.organizationId ?? facilityModel.organizationId,
                organizationName = facilityModel.organization?.organizationName ?? string.Empty,
                creditationStatusId =
                    facilityModel.creditationStatus?.creditationStatusId
                    ?? facilityModel.creditationStatusId,
                creditationStatus =
                    facilityModel.creditationStatus?.creditationStatus ?? string.Empty,
                headOfService = facilityModel.headOfService ?? string.Empty,
                comments = facilityModel.comments ?? string.Empty,
            };

            return CreatedAtAction(nameof(GetFacility), new { id = facilityDto.facilityId }, facilityDto);
        }

        // DELETE: api/Facility/5
        [HttpDelete("{id}")]
        [Authorize(Policy = "ReferenceData.Manage")]
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
