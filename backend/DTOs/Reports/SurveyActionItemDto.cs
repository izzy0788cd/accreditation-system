namespace backend.DTOs.Reports;

public class SurveyActionItemDto
{
    public int surveyActionItemId { get; set; }
    public int surveyId { get; set; }
    public int complianceAssessmentId { get; set; }
    public required string facilityName { get; set; }
    public required string surveyType { get; set; }
    public required string complianceNumber { get; set; }
    public required string complianceSummary { get; set; }
    public string? outcome { get; set; }
    public string? riskRating { get; set; }
    public required string recommendation { get; set; }
    public string? correctiveAction { get; set; }
    public string? responsibleOfficer { get; set; }
    public DateOnly? dueDate { get; set; }
    public required string status { get; set; }
    public string? closureNotes { get; set; }
    public DateTime createdAt { get; set; }
    public DateTime updatedAt { get; set; }
}
