namespace backend.DTOs.Reports;

public class ReportVersionCreateDto
{
    public required List<int> standardIds { get; set; }
    public required List<string> included { get; set; }
    public required string mode { get; set; }
    public bool includePersonnelNames { get; set; } = true;
    public required string reviewerName { get; set; }
    public required string reviewNotes { get; set; }
    public ReportConclusionDto? conclusion { get; set; }
    public bool approve { get; set; }
    public string? sourceRevision { get; set; }
}
