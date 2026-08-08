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
    [Route("api/components")]
    [ApiController]
    public class ComponentController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ComponentController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Component
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ComponentDTO>>> Getcomponents()
        {
            return await _context.components.Select(c => new ComponentDTO
            {
                componentId = c.componentId,
                componentNumber = c.componentNumber,
                componentName = c.componentName,
                componentSummary = c.componentSummary
            })
            .ToListAsync();
        }

        // GET: api/Component/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ComponentDTO>> GetComponent(int id)
        {
            var component = await _context.components
                .Where(c => c.componentId == id)
                .Select(c => new ComponentDTO
                {
                    componentId = c.componentId,
                    componentNumber= c.componentNumber,
                    componentName = c.componentName,
                    componentSummary = c.componentSummary
                })
                .FirstOrDefaultAsync();

            if (component == null)
            {
                return NotFound();
            }

            return component;
        }

        // PUT: api/Component/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutComponent(int id, ComponentUpdateDTO dto)
        {
            var component = await _context.components.FindAsync(id);

            if (component == null)
            {
                return NotFound();
            }

            component.componentNumber = dto.componentNumber;
            component.componentName = dto.componentName;
            component.componentSummary = dto.componentSummary;
            
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ComponentExists(id))
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

        // POST: api/Component
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<ComponentDTO>> PostComponent(ComponentCreateDTO component)
        {
            var componentModel = new Component
            {
                componentNumber = component.componentNumber,
                componentName = component.componentName,
                componentSummary = component.componentSummary
            };

            _context.components.Add(componentModel);
            await _context.SaveChangesAsync();

            var componentDto = new ComponentDTO
            {
                componentId = componentModel.componentId,
                componentNumber = componentModel.componentNumber,
                componentName = componentModel.componentName,
                componentSummary = componentModel.componentSummary
            };

            return CreatedAtAction("GetComponent", new { id = componentDto.componentId }, componentDto);
        }

        // DELETE: api/Component/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteComponent(int id)
        {
            var component = await _context.components.FindAsync(id);
            if (component == null)
            {
                return NotFound();
            }

            _context.components.Remove(component);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ComponentExists(int id)
        {
            return _context.components.Any(e => e.componentId == id);
        }
    }
}
