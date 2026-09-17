using System.Security.Claims;
using backend.Data;
using backend.DTOs.Reports;
using backend.Models.Reports;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Reports;

[ApiController]
[Route("api/survey-actions")]
[Authorize(Policy = "Actions.Manage")]
public class SurveyActionItemsController(AppDbContext context) : ControllerBase
{
    private static readonly string[] ValidStatuses = ["Open", "In progress", "Closed"];

    private async Task<int?> CurrentSurveyorIdAsync()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var accountId)
            ? await context.surveyors.Where(s => s.user!.userAccountId == accountId)
                .Select(s => (int?)s.surveyorId).FirstOrDefaultAsync()
            : null;
    }

    private async Task<IQueryable<SurveyActionItem>?> ScopedQueryAsync()
    {
        var query = context.surveyActionItems.AsQueryable();
        if (User.IsInRole("Admin")) return query;
        var surveyorId = await CurrentSurveyorIdAsync();
        return surveyorId.HasValue
            ? query.Where(item => item.survey!.surveyorId == surveyorId.Value)
            : null;
    }

    private static IQueryable<SurveyActionItemDto> Project(IQueryable<SurveyActionItem> query) => query.Select(item => new SurveyActionItemDto
    {
        surveyActionItemId = item.surveyActionItemId, surveyId = item.surveyId,
        complianceAssessmentId = item.complianceAssessmentId,
        facilityName = item.survey!.facility!.facilityName,
        surveyType = item.survey.surveyType!.surveyTypeName,
        complianceNumber = item.complianceAssessment!.compliance!.complianceNumber,
        complianceSummary = item.complianceAssessment.compliance.complianceSummary,
        outcome = item.complianceAssessment.score!.scoreLabel,
        riskRating = item.complianceAssessment.riskRating!.riskLabel,
        recommendation = item.recommendation, correctiveAction = item.correctiveAction,
        responsibleOfficer = item.responsibleOfficer, dueDate = item.dueDate,
        status = item.status, closureNotes = item.closureNotes,
        createdAt = item.createdAt, updatedAt = item.updatedAt,
    });

    private static IQueryable<SurveyActionItem> ApplyFilters(IQueryable<SurveyActionItem> query, int? surveyId, int? facilityId, string? status, string? owner, string? risk, bool? overdue)
    {
        if (surveyId.HasValue) query = query.Where(item => item.surveyId == surveyId.Value);
        if (facilityId.HasValue) query = query.Where(item => item.survey!.facilityId == facilityId.Value);
        if (!string.IsNullOrWhiteSpace(status)) query = query.Where(item => item.status == status);
        if (!string.IsNullOrWhiteSpace(owner)) query = query.Where(item => item.responsibleOfficer != null && EF.Functions.ILike(item.responsibleOfficer, $"%{owner.Trim()}%"));
        if (!string.IsNullOrWhiteSpace(risk)) query = query.Where(item => item.complianceAssessment!.riskRating != null && item.complianceAssessment.riskRating.riskLabel == risk);
        if (overdue == true)
        {
            var today = DateOnly.FromDateTime(DateTime.UtcNow);
            query = query.Where(item => item.status != "Closed" && item.dueDate != null && item.dueDate < today);
        }
        return query;
    }

    [HttpGet]
    public async Task<IActionResult> List([FromQuery] int? surveyId, [FromQuery] int? facilityId, [FromQuery] string? status, [FromQuery] string? owner, [FromQuery] string? risk, [FromQuery] bool? overdue, [FromQuery] int? page, [FromQuery] int? pageSize, CancellationToken cancellationToken)
    {
        var query = await ScopedQueryAsync();
        if (query == null) return Forbid();
        query = ApplyFilters(query, surveyId, facilityId, status, owner, risk, overdue);
        var projected = Project(query.AsNoTracking()).OrderBy(item => item.status == "Closed")
            .ThenBy(item => item.dueDate == null).ThenBy(item => item.dueDate).ThenBy(item => item.complianceNumber);
        if (!page.HasValue && !pageSize.HasValue) return Ok(await projected.ToListAsync(cancellationToken));
        var safePage = Math.Max(1, page ?? 1);
        var safePageSize = Math.Clamp(pageSize ?? 20, 1, 100);
        var total = await projected.CountAsync(cancellationToken);
        var rows = await projected.Skip((safePage - 1) * safePageSize).Take(safePageSize).ToListAsync(cancellationToken);
        return Ok(new { items = rows, total, page = safePage, pageSize = safePageSize });
    }

    [HttpGet("summary")]
    public async Task<IActionResult> Summary([FromQuery] int? surveyId, [FromQuery] int? facilityId, [FromQuery] string? status, [FromQuery] string? owner, [FromQuery] string? risk, [FromQuery] bool? overdue, CancellationToken cancellationToken)
    {
        var query = await ScopedQueryAsync();
        if (query == null) return Forbid();
        query = ApplyFilters(query, surveyId, facilityId, status, owner, risk, overdue);
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        return Ok(new {
            total = await query.CountAsync(cancellationToken),
            open = await query.CountAsync(item => item.status == "Open", cancellationToken),
            inProgress = await query.CountAsync(item => item.status == "In progress", cancellationToken),
            closed = await query.CountAsync(item => item.status == "Closed", cancellationToken),
            overdue = await query.CountAsync(item => item.status != "Closed" && item.dueDate != null && item.dueDate < today, cancellationToken),
        });
    }

    [HttpPost]
    public async Task<ActionResult<SurveyActionItemDto>> Create(SurveyActionItemCreateDto dto, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(dto.recommendation) || dto.recommendation.Trim().Length > 10000
            || dto.correctiveAction?.Length > 10000 || dto.responsibleOfficer?.Length > 200)
            return BadRequest("Provide a recommendation and keep action fields within their maximum length.");
        var assessment = await context.complianceAssessments.AsNoTracking().SingleOrDefaultAsync(item =>
            item.complianceAssessmentId == dto.complianceAssessmentId && item.surveyId == dto.surveyId, cancellationToken);
        if (assessment == null) return BadRequest("Choose an assessment from the selected survey.");
        if (!User.IsInRole("Admin"))
        {
            var surveyorId = await CurrentSurveyorIdAsync();
            if (!surveyorId.HasValue || !await context.surveys.AnyAsync(s => s.surveyId == dto.surveyId && s.surveyorId == surveyorId.Value, cancellationToken)) return Forbid();
        }
        var now = DateTime.UtcNow;
        var item = new SurveyActionItem { surveyId = dto.surveyId, complianceAssessmentId = dto.complianceAssessmentId,
            recommendation = dto.recommendation.Trim(), correctiveAction = dto.correctiveAction?.Trim(), responsibleOfficer = dto.responsibleOfficer?.Trim(),
            dueDate = dto.dueDate, status = "Open", createdAt = now, updatedAt = now };
        context.surveyActionItems.Add(item);
        await context.SaveChangesAsync(cancellationToken);
        var result = await Project(context.surveyActionItems.AsNoTracking().Where(action => action.surveyActionItemId == item.surveyActionItemId)).SingleAsync(cancellationToken);
        return CreatedAtAction(nameof(List), new { surveyId = item.surveyId }, result);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<SurveyActionItemDto>> Update(int id, SurveyActionItemUpdateDto dto, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(dto.recommendation) || dto.recommendation.Trim().Length > 10000
            || dto.correctiveAction?.Length > 10000 || dto.responsibleOfficer?.Length > 200 || dto.closureNotes?.Length > 10000
            || !ValidStatuses.Contains(dto.status)) return BadRequest("Provide valid action-plan details and status.");
        var query = await ScopedQueryAsync();
        if (query == null) return Forbid();
        var item = await query.SingleOrDefaultAsync(action => action.surveyActionItemId == id, cancellationToken);
        if (item == null) return NotFound();
        item.recommendation = dto.recommendation.Trim(); item.correctiveAction = dto.correctiveAction?.Trim();
        item.responsibleOfficer = dto.responsibleOfficer?.Trim(); item.dueDate = dto.dueDate;
        item.status = dto.status; item.closureNotes = dto.closureNotes?.Trim(); item.updatedAt = DateTime.UtcNow;
        await context.SaveChangesAsync(cancellationToken);
        return Ok(await Project(context.surveyActionItems.AsNoTracking().Where(action => action.surveyActionItemId == id)).SingleAsync(cancellationToken));
    }
}
