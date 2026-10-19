namespace backend.DTOs.Reports;

public class SurveyorReportSaveDTO
{
    public string? summary { get; set; }
    public string? goodPractices { get; set; }
    public string? notApplicableNotes { get; set; }
    public bool submit { get; set; }
}
