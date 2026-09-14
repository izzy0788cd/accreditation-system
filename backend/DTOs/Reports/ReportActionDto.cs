namespace backend.DTOs.Reports;

public class ReportActionDto
{
    public required int complianceId { get; set; }
    public required string recommendation { get; set; }
    public required string owner { get; set; }
    public DateOnly? dueDate { get; set; }
}
