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
    [Route("api/categories")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CategoryController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Category
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CategoryDTO>>> GetCategories()
        {
            return await _context.categories.Select(c => new CategoryDTO
            {
                categoryId = c.categoryId,
                categoryName = c.categoryName,
                description = c.description ?? string.Empty
            })
            .ToListAsync();
        }

        // GET: api/Category/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CategoryDTO>> GetCategory(int id)
        {
            var category = await _context.categories
                .Where(c => c.categoryId == id)
                .Select(c => new CategoryDTO
                {
                    categoryId = c.categoryId,
                    categoryName = c.categoryName,
                    description = c.description ?? string.Empty
                })
                .FirstOrDefaultAsync();

            if (category == null)
            {
                return NotFound();
            }

            return Ok(category);
        }

        // PUT: api/Category/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCategory(int id, CategoryUpdateDTO dto)
        {
            var category = await _context.categories.FindAsync(id);

            if (category == null)
            {
                return NotFound();
            }

            category.categoryName = dto.categoryName;
            category.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CategoryExists(id))
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

        // POST: api/Category
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<CategoryDTO>> PostCategory(CategoryCreateDTO dto)
        {
            var categoryModel = new Category
            {
                categoryName = dto.categoryName,
                description = dto.description
            };

            _context.categories.Add(categoryModel);
            await _context.SaveChangesAsync();

            var categoryDto = new CategoryDTO
            {
                categoryId = categoryModel.categoryId,
                categoryName = categoryModel.categoryName,
                description = categoryModel.description ?? string.Empty
            };

            return CreatedAtAction("GetCategory", new { id = categoryDto.categoryId }, categoryDto);
        }

        // DELETE: api/Category/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCategory(int id)
        {
            var category = await _context.categories.FindAsync(id);
            if (category == null)
            {
                return NotFound();
            }

            _context.categories.Remove(category);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CategoryExists(int id)
        {
            return _context.categories.Any(e => e.categoryId == id);
        }
    }
}
