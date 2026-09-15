using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Scoring;
using backend.Models.Scoring;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Scoring
{
    [Route("api/scores")]
    [ApiController]
    public class ScoreController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ScoreController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Score
        [HttpGet]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ScoresDTO>>> GetScores()
        {
            var scores = await _context
                .scores.Select(s => new ScoresDTO
                {
                    scoreId = s.scoreId,
                    scoreValue = s.scoreValue,
                    scoreLabel = s.scoreLabel,
                    description = s.description,
                    guidance = s.guidance,
                })
                .ToListAsync();

            return Ok(scores);
        }

        // GET: api/Score/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<ScoresDTO>> GetScore(int id)
        {
            var score = await _context
                .scores.Where(s => s.scoreId == id)
                .Select(s => new ScoresDTO
                {
                    scoreId = s.scoreId,
                    scoreValue = s.scoreValue,
                    scoreLabel = s.scoreLabel,
                    description = s.description,
                    guidance = s.guidance,
                })
                .FirstOrDefaultAsync();

            if (score == null)
            {
                return NotFound();
            }

            return Ok(score);
        }

        // PUT: api/Score/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutScore(int id, ScoreUpdateDTO dto)
        {
            if (!IsValidScoreValue(dto.scoreValue))
                return BadRequest("scoreValue must be 1, 2, 3, or 4. Leave it empty for N/A.");

            var score = await _context.scores.FindAsync(id);

            if (score == null)
            {
                return NotFound();
            }

            score.scoreValue = dto.scoreValue;
            score.scoreLabel = dto.scoreLabel;
            score.description = dto.description;
            score.guidance = dto.guidance;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ScoreExists(id))
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

        // POST: api/Score
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ScoresDTO>> PostScore(ScoreCreateDTO dto)
        {
            if (!IsValidScoreValue(dto.scoreValue))
                return BadRequest("scoreValue must be 1, 2, 3, or 4. Leave it empty for N/A.");

            var scoreModel = new Score
            {
                scoreValue = dto.scoreValue,
                scoreLabel = dto.scoreLabel,
                description = dto.description,
                guidance = dto.guidance,
            };

            _context.scores.Add(scoreModel);
            await _context.SaveChangesAsync();

            var scoreDto = new ScoresDTO
            {
                scoreId = scoreModel.scoreId,
                scoreValue = scoreModel.scoreValue,
                scoreLabel = scoreModel.scoreLabel,
                description = scoreModel.description,
                guidance = scoreModel.guidance,
            };

            return CreatedAtAction("GetScore", new { id = scoreDto.scoreId }, scoreDto);
        }

        // DELETE: api/Score/5
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteScore(int id)
        {
            var score = await _context.scores.FindAsync(id);
            if (score == null)
            {
                return NotFound();
            }

            _context.scores.Remove(score);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ScoreExists(int id)
        {
            return _context.scores.Any(e => e.scoreId == id);
        }

        private static bool IsValidScoreValue(int? scoreValue)
        {
            return scoreValue is null or >= 1 and <= 4;
        }
    }
}
