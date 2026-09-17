namespace backend.DTOs.Reports;

public class SurveyActionItemCreateDto
{
    public required int surveyId { get; set; }
    public required int complianceAssessmentId { get; set; }
    public required string recommendation { get; set; }
    public string? correctiveAction { get; set; }
    public string? responsibleOfficer { get; set; }
    public DateOnly? dueDate { get; set; }
}
