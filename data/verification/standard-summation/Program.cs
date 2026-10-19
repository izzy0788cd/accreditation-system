using System.Security.Claims;
using backend.Controllers.Reports;
using backend.Data;
using backend.DTOs.Reports;
using backend.Models.Reports;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

// Integration checks use a transaction that is always rolled back. No test narrative is retained.
var connection = Environment.GetEnvironmentVariable("ConnectionStrings__AppDbContext") ?? throw new Exception("Set database connection in the environment.");
await using var db = new AppDbContext(new DbContextOptionsBuilder<AppDbContext>().UseNpgsql(connection).Options);
// Read-only diagnostics: report field presence, never private narrative text.
if (args.Length == 3 && args[0] == "--inspect")
{
    var surveyId = int.Parse(args[1]);
    var surveyorId = int.Parse(args[2]);
    var summaries = await db.surveyorStandardSummaries.AsNoTracking()
        .Where(s => s.surveyId == surveyId && s.surveyorId == surveyorId)
        .Select(s => new { s.standard!.standardNumber, s.areasOfConcern, s.recommendations, s.serviceAreasJson }).ToListAsync();
    foreach (var s in summaries)
        Console.WriteLine($"Standard {s.standardNumber}: concerns={!string.IsNullOrWhiteSpace(s.areasOfConcern)}, recommendations={!string.IsNullOrWhiteSpace(s.recommendations)}, serviceAreas={(!string.IsNullOrWhiteSpace(s.serviceAreasJson) ? System.Text.Json.JsonDocument.Parse(s.serviceAreasJson).RootElement.GetArrayLength() : 0)}");
    return;
}
await using var transaction = await db.Database.BeginTransactionAsync();
try
{
    var candidate = await db.complianceAssessments.AsNoTracking().Where(a => !a.survey!.isCancelled)
        .GroupBy(a => new { a.surveyId, a.surveyorId, a.compliance!.criterion!.standardId })
        .Where(g => g.All(a => a.scoreId != null)).Select(g => g.Key).FirstAsync();
    var account = await db.surveyors.Where(s => s.surveyorId == candidate.surveyorId).Select(s => s.user!.userAccountId).SingleAsync();
    var controller = new SurveyorReportsController(db) { ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext {
        User = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, account.ToString()), new Claim(ClaimTypes.Role, "Surveyor") }, "test"))
    } } };
    var report = await db.surveyorReports.SingleOrDefaultAsync(r => r.surveyId == candidate.surveyId && r.surveyorId == candidate.surveyorId);
    if (report == null) { report = new SurveyorReport { surveyId = candidate.surveyId, surveyorId = candidate.surveyorId, updatedAt = DateTime.UtcNow }; db.surveyorReports.Add(report); }
    report.isSubmitted = false;
    await db.SaveChangesAsync();
    var dto = new SurveyorStandardSummarySaveDTO { summary = "Test overview", goodPractices = "Test commendation", areasOfConcern = "Test concern", recommendations = "Test recommendation", notApplicableNotes = "Test scope", serviceAreas = [new() { name = "NICU", overview = "Area overview", commendations = "Strength", areasOfConcern = "Concern", recommendations = "Improve" }] };
    var saved = await controller.SaveStandardSummary(candidate.surveyId, candidate.standardId, dto);
    Require(saved.Result is OkObjectResult { Value: SurveyorStandardSummaryDTO result } && result.serviceAreas.Single().name == "NICU" && result.areasOfConcern == dto.areasOfConcern && result.recommendations == dto.recommendations, "Structured round trip and SQL projection");
    var read = await controller.MyStandardSummaries(candidate.surveyId);
    Require(read.Result is OkObjectResult, "Summary list projection");
    dto.serviceAreas![0].name = "";
    Require((await controller.SaveStandardSummary(candidate.surveyId, candidate.standardId, dto)).Result is BadRequestObjectResult, "Blank service name rejected");
    dto.serviceAreas[0].name = "NICU";
    dto.recommendations = new string('x', 10001);
    Require((await controller.SaveStandardSummary(candidate.surveyId, candidate.standardId, dto)).Result is BadRequestObjectResult, "Oversized narrative rejected");
    dto.recommendations = "Improve";
    report.isSubmitted = true; await db.SaveChangesAsync();
    Require((await controller.SaveStandardSummary(candidate.surveyId, candidate.standardId, dto)).Result is BadRequestObjectResult, "Submitted report remains locked");
    report.isSubmitted = false; await db.SaveChangesAsync();
    Require((await controller.SaveStandardSummary(candidate.surveyId, int.MaxValue, dto)).Result is ForbidResult, "Unassigned standard rejected");
    var assessment = await db.complianceAssessments.FirstAsync(a => a.surveyId == candidate.surveyId && a.surveyorId == candidate.surveyorId && a.compliance!.criterion!.standardId == candidate.standardId);
    assessment.scoreId = null; await db.SaveChangesAsync();
    Require((await controller.SaveStandardSummary(candidate.surveyId, candidate.standardId, dto)).Result is BadRequestObjectResult, "Unscored requirement blocks saving");
}
finally { await transaction.RollbackAsync(); Console.WriteLine("Rolled back all verification data."); }
static void Require(bool condition, string name) { if (!condition) throw new Exception(name); Console.WriteLine("PASS: " + name); }
