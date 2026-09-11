using System.ComponentModel.DataAnnotations;
using backend.Models.FaciltitySurvey;

namespace backend.Models.Reports;

// Append-only report content. No update/delete API is exposed.
public class SurveyReportVersion
{
    [Key] public int reportVersionId { get; set; }
    public int surveyId { get; set; }
    public Survey? survey { get; set; }
    public int versionNumber { get; set; }
    public DateTime createdAt { get; set; }
    public required string createdBy { get; set; }
    public required string reportJson { get; set; }
}
