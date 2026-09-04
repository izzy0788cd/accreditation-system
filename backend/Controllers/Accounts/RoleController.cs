using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Accounts;
using backend.Models.Accounts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Accounts
{
    [Route("api/roles")]
    [ApiController]
    public class RoleController : ControllerBase
    {
        private readonly AppDbContext _context;

        public RoleController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Role
        [HttpGet]
        [Authorize]
        public async Task<ActionResult<IEnumerable<RoleDTO>>> GetRoles()
        {
            var roles = await _context
                .roles.Select(r => new RoleDTO
                {
                    roleId = r.roleId,
                    roleName = r.roleName,
                    description = r.description,
                })
                .ToListAsync();

            return Ok(roles);
        }

        // GET: api/Role/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<RoleDTO>> GetRole(int id)
        {
            var role = await _context
                .roles.Where(r => r.roleId == id)
                .Select(r => new RoleDTO
                {
                    roleId = r.roleId,
                    roleName = r.roleName,
                    description = r.description,
                })
                .FirstOrDefaultAsync();

            if (role == null)
            {
                return NotFound();
            }

            return Ok(role);
        }

        // PUT: api/Role/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutRole(int id, RoleUpdateDTO dto)
        {
            var role = await _context.roles.FindAsync(id);

            if (role == null)
            {
                return NotFound();
            }

            role.roleName = dto.roleName;
            role.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RoleExists(id))
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

        // POST: api/Role
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<RoleDTO>> PostRole(RoleCreateDTO dto)
        {
            var roleModel = new Role { roleName = dto.roleName, description = dto.description };

            _context.roles.Add(roleModel);
            await _context.SaveChangesAsync();

            var roleDto = new RoleDTO
            {
                roleId = roleModel.roleId,
                roleName = roleModel.roleName,
                description = roleModel.description,
            };

            return CreatedAtAction("GetRole", new { id = roleDto.roleId }, roleDto);
        }

        // DELETE: api/Role/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteRole(int id)
        {
            var role = await _context.roles.FindAsync(id);
            if (role == null)
            {
                return NotFound();
            }

            _context.roles.Remove(role);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RoleExists(int id)
        {
            return _context.roles.Any(e => e.roleId == id);
        }
    }
}
