namespace backend.DTOs.Reports;

public class SurveyorStandardSummarySaveDTO
{
    public string? summary { get; set; }
    public string? goodPractices { get; set; }
    public string? notApplicableNotes { get; set; }
    public string? areasOfConcern { get; set; }
    public string? recommendations { get; set; }
    public List<StandardServiceAreaDTO>? serviceAreas { get; set; }
}
