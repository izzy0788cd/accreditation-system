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
    [Route("api/functions")]
    [ApiController]
    public class FunctionController : ControllerBase
    {
        private readonly AppDbContext _context;

        public FunctionController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Function
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FunctionDTO>>> Getfunctions()
        {
            return await _context.functions.Select(f => new FunctionDTO
            {
                functionId = f.functionId,
                functionNumber = f.functionNumber,
                functionTitle = f.functiontTitle,
                functionSummary = f.functionSummary
            })
            .ToListAsync();
        }

        // GET: api/Function/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FunctionDTO>> GetFunction(int id)
        {
            var function = await _context.functions
                .Where(f => f.functionId == id)
                .Select(f => new FunctionDTO
                {
                    functionId = f.functionId,
                    functionNumber = f.functionNumber,
                    functionTitle = f.functiontTitle,
                    functionSummary = f.functionSummary
                })
                .FirstOrDefaultAsync();

            if (function == null)
            {
                return NotFound();
            }

            return function;
        }

        // PUT: api/Function/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFunction(int id, FunctionUpdateDTO dto)
        {
            var function = await _context.functions.FindAsync(id);

            if (function == null)
            {
                return NotFound();
            }

            function.functionNumber = dto.functionNumber;
            function.functiontTitle = dto.functionTitle;
            function.functionSummary = dto.functionSummary;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FunctionExists(id))
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

        // POST: api/Function
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<FunctionDTO>> PostFunction(FunctionCreateDTO function)
        {
            var functionModel = new Function
            {
                functionNumber = function.functionNumber,
                functiontTitle = function.functionTitle,
                functionSummary = function.functionSummary
            };

            _context.functions.Add(functionModel);

            await _context.SaveChangesAsync();

            var functionDto = new FunctionDTO
            {
                functionId = functionModel.functionId,
                functionNumber = functionModel.functionNumber,
                functionTitle = functionModel.functiontTitle,
                functionSummary = functionModel.functionSummary
            };

            return CreatedAtAction("GetFunction", new { id = functionDto.functionId }, functionDto);
        }

        // DELETE: api/Function/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFunction(int id)
        {
            var function = await _context.functions.FindAsync(id);
            if (function == null)
            {
                return NotFound();
            }

            _context.functions.Remove(function);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool FunctionExists(int id)
        {
            return _context.functions.Any(e => e.functionId == id);
        }
    }
}
