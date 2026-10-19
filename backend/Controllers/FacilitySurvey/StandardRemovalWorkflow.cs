using backend.DTOs.FacilitySurvey;
using backend.Models.Reports;

namespace backend.Controllers.FacilitySurvey;

public static class StandardRemovalWorkflow
{
    public static bool IsConfirmed(SurveyStandardResetRemoveDto dto) => dto.confirmed
        && !string.IsNullOrWhiteSpace(dto.reason) && dto.reason.Trim().Length <= 2000;

    public static List<SurveyorReportReopen> ReopenAffected(IEnumerable<SurveyorReport> reports,
        int surveyId, IEnumerable<int> affectedSurveyorIds, string standardNumber, string reason,
        string actor, DateTime now)
    {
        var owners = affectedSurveyorIds.ToHashSet();
        var audits = new List<SurveyorReportReopen>();
        foreach (var report in reports.Where(r => r.surveyId == surveyId && r.isSubmitted && owners.Contains(r.surveyorId)))
        {
            audits.Add(new SurveyorReportReopen {
                surveyorReportId = report.surveyorReportId,
                reason = $"Standard {standardNumber} reset and removed. Reason: {reason.Trim()}",
                reopenedByUsername = actor, reopenedAt = now, previousSubmittedAt = report.submittedAt,
            });
            report.isSubmitted = false;
            report.updatedAt = now;
        }
        return audits;
    }
}
