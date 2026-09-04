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
    [Route("api/levels")]
    [ApiController]
    public class LevelController : ControllerBase
    {
        private readonly AppDbContext _context;

        public LevelController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Level
        [HttpGet]
        public async Task<ActionResult<IEnumerable<LevelDTO>>> GetLevels()
        {
            var levels = await _context.levels.Select(lv => new LevelDTO
            {
                levelId = lv.levelId,
                levelName = lv.levelName,
                levelOrder = lv.levelOrder,
                description = lv.description
            })
            .ToListAsync();

            return Ok(levels);
        }

        // GET: api/Level/5
        [HttpGet("{id}")]
        public async Task<ActionResult<LevelDTO>> GetLevel(int id)
        {
            var level = await _context.levels
                .Where(lv => lv.levelId == id)
                .Select(lv => new LevelDTO
                {
                    levelId = lv.levelId,
                    levelName = lv.levelName,
                    levelOrder = lv.levelOrder,
                    description = lv.description
                })
                .FirstOrDefaultAsync();

            if (level == null)
            {
                return NotFound();
            }

            return Ok(level);
        }

        // PUT: api/Level/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutLevel(int id, LevelUpdateDTO dto)
        {
            var level = await _context.levels.FindAsync(id);

            if (level == null)
            {
                return NotFound();
            }

            level.levelName = dto.levelName;
            level.levelOrder = dto.levelOrder;
            level.description = dto.description;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LevelExists(id))
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

        // POST: api/Level
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<LevelDTO>> PostLevel(LevelCreateDTO dto)
        {
            var levelModel = new Level
            {
                levelName = dto.levelName,
                levelOrder = dto.levelOrder,
                description = dto.description,
            };

            _context.levels.Add(levelModel);
            await _context.SaveChangesAsync();

            var levelDto = new LevelDTO
            {
                levelId = levelModel.levelId,
                levelName = levelModel.levelName,
                levelOrder = levelModel.levelOrder,
                description = levelModel.description,
            };

            return CreatedAtAction("GetLevel", new { id = levelDto.levelId }, levelDto);
        }

        // DELETE: api/Level/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLevel(int id)
        {
            var level = await _context.levels.FindAsync(id);
            if (level == null)
            {
                return NotFound();
            }

            _context.levels.Remove(level);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool LevelExists(int id)
        {
            return _context.levels.Any(e => e.levelId == id);
        }
    }
}
