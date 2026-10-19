namespace backend.DTOs.Reports;

public class SurveyorStandardSummaryDTO
{
    public int surveyorStandardSummaryId { get; set; }
    public int surveyId { get; set; }
    public int surveyorId { get; set; }
    public string surveyorName { get; set; } = "";
    public int standardId { get; set; }
    public string standardNumber { get; set; } = "";
    public string standardTitle { get; set; } = "";
    public string summary { get; set; } = "";
    public string? goodPractices { get; set; }
    public string? notApplicableNotes { get; set; }
    public string? areasOfConcern { get; set; }
    public string? recommendations { get; set; }
    public List<StandardServiceAreaDTO> serviceAreas { get; set; } = [];
    public DateTime updatedAt { get; set; }
}
