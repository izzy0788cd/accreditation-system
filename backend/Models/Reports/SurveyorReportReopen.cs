using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Models.Reports;

// Immutable audit record for each controlled reopening of a submitted handover.
public class SurveyorReportReopen
{
    [Key] public int surveyorReportReopenId { get; set; }
    public int surveyorReportId { get; set; }
    [ForeignKey("surveyorReportId")] public SurveyorReport? surveyorReport { get; set; }
    public required string reason { get; set; }
    public required string reopenedByUsername { get; set; }
    public DateTime reopenedAt { get; set; }
    public DateTime? previousSubmittedAt { get; set; }
}
