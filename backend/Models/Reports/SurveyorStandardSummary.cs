using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.FaciltitySurvey;
using backend.Models.Framework;

namespace backend.Models.Reports;

public class SurveyorStandardSummary
{
    [Key] public int surveyorStandardSummaryId { get; set; }
    public int surveyId { get; set; }
    [ForeignKey("surveyId")] public Survey? survey { get; set; }
    public int surveyorId { get; set; }
    [ForeignKey("surveyorId")] public Surveyors? surveyor { get; set; }
    public int standardId { get; set; }
    [ForeignKey("standardId")] public Standard? standard { get; set; }
    public required string summary { get; set; }
    public string? goodPractices { get; set; }
    public string? notApplicableNotes { get; set; }
    public string? areasOfConcern { get; set; }
    public string? recommendations { get; set; }
    public string? serviceAreasJson { get; set; }
    public DateTime updatedAt { get; set; }
}
