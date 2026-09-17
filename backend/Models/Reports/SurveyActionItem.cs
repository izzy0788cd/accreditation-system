using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.Assessment;
using backend.Models.FaciltitySurvey;

namespace backend.Models.Reports;

// A live corrective-action record, intentionally separate from immutable report versions.
public class SurveyActionItem
{
    [Key] public int surveyActionItemId { get; set; }
    public int surveyId { get; set; }
    [ForeignKey("surveyId")] public Survey? survey { get; set; }
    public int complianceAssessmentId { get; set; }
    [ForeignKey("complianceAssessmentId")] public ComplianceAssessment? complianceAssessment { get; set; }
    public required string recommendation { get; set; }
    public string? correctiveAction { get; set; }
    public string? responsibleOfficer { get; set; }
    public DateOnly? dueDate { get; set; }
    public required string status { get; set; } = "Open";
    public string? closureNotes { get; set; }
    public DateTime createdAt { get; set; }
    public DateTime updatedAt { get; set; }
}
