namespace backend.DTOs.Reports;

public class ReportVersionDto
{
    public int reportVersionId { get; set; }
    public int surveyId { get; set; }
    public int versionNumber { get; set; }
    public DateTime createdAt { get; set; }
    public required string createdBy { get; set; }
}
