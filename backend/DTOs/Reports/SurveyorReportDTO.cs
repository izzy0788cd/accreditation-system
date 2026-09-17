namespace backend.DTOs.Reports;

public class SurveyorReportDTO
{
    public int surveyorReportId { get; set; }
    public int surveyId { get; set; }
    public int surveyorId { get; set; }
    public string surveyorName { get; set; } = "";
    public string facilityName { get; set; } = "";
    public string surveyType { get; set; } = "";
    public string? summary { get; set; }
    public string? priorityFindings { get; set; }
    public string? recommendations { get; set; }
    public string? goodPractices { get; set; }
    public string? notApplicableNotes { get; set; }
    public bool isSubmitted { get; set; }
    public DateTime? submittedAt { get; set; }
    public DateTime updatedAt { get; set; }
    public int assignedRequirements { get; set; }
    public int scoredRequirements { get; set; }
}
