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

namespace backend.Controllers_Facilities
{
    [Route("api/organizations")]
    [ApiController]
    public class OrganizationController : ControllerBase
    {
        private readonly AppDbContext _context;

        public OrganizationController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Organization
        [HttpGet]
        public async Task<ActionResult<IEnumerable<OrganizationDTO>>> GetOrganizations()
        {
            return await _context.organizations.Select(o => new OrganizationDTO
            {
                organizationId = o.organizationId,
                organizationName = o.organizationName,
                categoryId = o.category!.categoryId,
                categoryName = o.category!.categoryName,
                description = o.description
            })
            .ToListAsync();
        }

        // GET: api/Organization/5
        [HttpGet("{id}")]
        public async Task<ActionResult<OrganizationDTO>> GetOrganization(int id)
        {
            var organization = await _context.organizations
                .Where(o => o.organizationId == id)
                .Select(o => new OrganizationDTO
                {
                    organizationId = o.organizationId,
                    organizationName = o.organizationName,
                    categoryId = o.category!.categoryId,
                    categoryName = o.category!.categoryName,
                    description = o.description
                })
                .FirstOrDefaultAsync();

            if (organization == null)
            {
                return NotFound();
            }

            return Ok(organization);
        }

        // PUT: api/Organization/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutOrganization(int id, OrganizationUpdateDTO dto)
        {
            var organization = await _context.organizations.FindAsync(id);

            if (organization == null)
            {
                return NotFound();
            }

            organization.organizationName = dto.organizationName;
            organization.categoryId = dto.categoryId;
            organization.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!OrganizationExists(id))
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

        // POST: api/Organization
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<OrganizationDTO>> PostOrganization(OrganizationCreateDTO dto)
        {
            var organizationModel = new Organization
            {
                organizationName = dto.organizationName,
                categoryId = dto.categoryId,
                description = dto.description,
            };

            _context.organizations.Add(organizationModel);
            await _context.SaveChangesAsync();

            organizationModel = await _context.organizations
                .Include(o => o.category)
                .FirstOrDefaultAsync(o => o.categoryId == organizationModel.categoryId);

            if (organizationModel is null || organizationModel.category is null)
            {
                return NotFound();
            }

            var organizationDto = new OrganizationDTO
            {
                organizationId = organizationModel.organizationId,
                organizationName = organizationModel.organizationName,
                categoryId = organizationModel.category!.categoryId,
                categoryName = organizationModel.category!.categoryName,
                description = organizationModel.description,
            };

            return CreatedAtAction("GetOrganization", new { id = organizationDto.organizationId }, organizationDto);
        }

        // DELETE: api/Organization/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrganization(int id)
        {
            var organization = await _context.organizations.FindAsync(id);
            if (organization == null)
            {
                return NotFound();
            }

            _context.organizations.Remove(organization);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool OrganizationExists(int id)
        {
            return _context.organizations.Any(e => e.organizationId == id);
        }
    }
}
