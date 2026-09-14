namespace backend.DTOs.Reports;

public class ReportVersionCreateDto
{
    public required List<int> standardIds { get; set; }
    public required List<string> included { get; set; }
    public required string mode { get; set; }
    public required List<ReportActionDto> actions { get; set; }
    public required string reviewerName { get; set; }
    public required string reviewNotes { get; set; }
}
