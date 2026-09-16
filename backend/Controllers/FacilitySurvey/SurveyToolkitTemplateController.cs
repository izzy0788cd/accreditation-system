using backend.Data;
using backend.DTOs.FacilitySurvey;
using backend.Models.FaciltitySurvey;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.FacilitySurvey
{
    [Route("api/survey-toolkit-templates")]
    [ApiController]
    [Authorize]
    public class SurveyToolkitTemplateController : ControllerBase
    {
        private readonly AppDbContext _context;
        public SurveyToolkitTemplateController(AppDbContext context) => _context = context;

        private static SurveyToolkitTemplateDTO ToDto(SurveyToolkitTemplate template) => new()
        {
            surveyToolkitTemplateId = template.surveyToolkitTemplateId,
            templateName = template.templateName,
            templateVersion = template.templateVersion,
            description = template.description,
            levelId = template.levelId,
            levelName = template.level?.levelName,
            isServiceOverlay = template.isServiceOverlay,
            isActive = template.isActive,
            standardIds = template.standards?.Select(item => item.standardId).OrderBy(id => id).ToList() ?? [],
            complianceIds = template.compliances?.Select(item => item.complianceId).OrderBy(id => id).ToList() ?? [],
        };

        [HttpGet]
        public async Task<ActionResult<IEnumerable<SurveyToolkitTemplateDTO>>> GetTemplates()
        {
            var templates = await _context.surveyToolkitTemplates
                .Include(template => template.level).Include(template => template.standards).Include(template => template.compliances)
                .OrderBy(template => template.levelId).ThenBy(template => template.templateName)
                .AsNoTracking().ToListAsync();
            return Ok(templates.Select(ToDto));
        }

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<SurveyToolkitTemplateDTO>> PostTemplate(SurveyToolkitTemplateCreateDTO dto)
        {
            if (dto.levelId != null && !await _context.levels.AnyAsync(level => level.levelId == dto.levelId)) return BadRequest("levelId does not exist.");
            var complianceIds = dto.complianceIds.Distinct().ToList();
            if (complianceIds.Count != await _context.compliances.CountAsync(compliance => complianceIds.Contains(compliance.complianceId))) return BadRequest("One or more compliance requirements do not exist.");
            var template = new SurveyToolkitTemplate { templateName = dto.templateName.Trim(), templateVersion = string.IsNullOrWhiteSpace(dto.templateVersion) ? "1.0" : dto.templateVersion.Trim(), description = dto.description?.Trim(), levelId = dto.levelId, isServiceOverlay = dto.isServiceOverlay, isActive = dto.isActive };
            _context.surveyToolkitTemplates.Add(template);
            await _context.SaveChangesAsync();
            var standardIds = await _context.compliances.Where(compliance => complianceIds.Contains(compliance.complianceId)).Select(compliance => compliance.criterion!.standardId).Distinct().ToListAsync();
            _context.surveyToolkitTemplateStandards.AddRange(standardIds.Select(standardId => new SurveyToolkitTemplateStandard { surveyToolkitTemplateId = template.surveyToolkitTemplateId, standardId = standardId }));
            _context.surveyToolkitTemplateCompliances.AddRange(complianceIds.Select(complianceId => new SurveyToolkitTemplateCompliance { surveyToolkitTemplateId = template.surveyToolkitTemplateId, complianceId = complianceId }));
            await _context.SaveChangesAsync();
            template = await _context.surveyToolkitTemplates.Include(item => item.level).Include(item => item.standards).Include(item => item.compliances).FirstAsync(item => item.surveyToolkitTemplateId == template.surveyToolkitTemplateId);
            return CreatedAtAction(nameof(GetTemplates), new { id = template.surveyToolkitTemplateId }, ToDto(template));
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> PutTemplate(int id, SurveyToolkitTemplateUpdateDTO dto)
        {
            var template = await _context.surveyToolkitTemplates.Include(item => item.standards).Include(item => item.compliances).FirstOrDefaultAsync(item => item.surveyToolkitTemplateId == id);
            if (template == null) return NotFound();
            if (dto.levelId != null && !await _context.levels.AnyAsync(level => level.levelId == dto.levelId)) return BadRequest("levelId does not exist.");
            var complianceIds = dto.complianceIds.Distinct().ToList();
            if (complianceIds.Count != await _context.compliances.CountAsync(compliance => complianceIds.Contains(compliance.complianceId))) return BadRequest("One or more compliance requirements do not exist.");
            template.templateName = dto.templateName.Trim(); template.templateVersion = string.IsNullOrWhiteSpace(dto.templateVersion) ? "1.0" : dto.templateVersion.Trim(); template.description = dto.description?.Trim(); template.levelId = dto.levelId; template.isServiceOverlay = dto.isServiceOverlay; template.isActive = dto.isActive;
            _context.surveyToolkitTemplateStandards.RemoveRange(template.standards!);
            _context.surveyToolkitTemplateCompliances.RemoveRange(template.compliances!);
            var standardIds = await _context.compliances.Where(compliance => complianceIds.Contains(compliance.complianceId)).Select(compliance => compliance.criterion!.standardId).Distinct().ToListAsync();
            _context.surveyToolkitTemplateStandards.AddRange(standardIds.Select(standardId => new SurveyToolkitTemplateStandard { surveyToolkitTemplateId = id, standardId = standardId }));
            _context.surveyToolkitTemplateCompliances.AddRange(complianceIds.Select(complianceId => new SurveyToolkitTemplateCompliance { surveyToolkitTemplateId = id, complianceId = complianceId }));
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteTemplate(int id)
        {
            var template = await _context.surveyToolkitTemplates.FindAsync(id);
            if (template == null) return NotFound();
            _context.surveyToolkitTemplates.Remove(template); await _context.SaveChangesAsync(); return NoContent();
        }
    }
}
