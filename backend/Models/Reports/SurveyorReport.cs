using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.FaciltitySurvey;

namespace backend.Models.Reports;

public class SurveyorReport
{
    [Key] public int surveyorReportId { get; set; }
    public int surveyId { get; set; }
    [ForeignKey("surveyId")] public Survey? survey { get; set; }
    public int surveyorId { get; set; }
    [ForeignKey("surveyorId")] public Surveyors? surveyor { get; set; }
    public string? summary { get; set; }
    public string? priorityFindings { get; set; }
    public string? recommendations { get; set; }
    public string? goodPractices { get; set; }
    public string? notApplicableNotes { get; set; }
    public bool isSubmitted { get; set; }
    public DateTime? submittedAt { get; set; }
    public DateTime updatedAt { get; set; }
}
