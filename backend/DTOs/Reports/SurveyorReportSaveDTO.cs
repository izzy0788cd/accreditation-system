namespace backend.DTOs.Reports;

public class SurveyorReportSaveDTO
{
    public string? summary { get; set; }
    public string? priorityFindings { get; set; }
    public string? recommendations { get; set; }
    public string? goodPractices { get; set; }
    public string? notApplicableNotes { get; set; }
    public List<SurveyorReportFindingDTO>? findingActions { get; set; }
    public bool submit { get; set; }
}
