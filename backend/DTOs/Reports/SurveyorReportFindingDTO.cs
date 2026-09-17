namespace backend.DTOs.Reports;

public class SurveyorReportFindingDTO
{
    public int complianceAssessmentId { get; set; }
    public string complianceNumber { get; set; } = "";
    public string complianceSummary { get; set; } = "";
    public string? scoreLabel { get; set; }
    public string? riskLabel { get; set; }
    public string? comments { get; set; }
    public string? recommendation { get; set; }
    public string? correctiveAction { get; set; }
}
