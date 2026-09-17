namespace backend.DTOs.Reports;

public class SurveyActionItemUpdateDto
{
    public required string recommendation { get; set; }
    public string? correctiveAction { get; set; }
    public string? responsibleOfficer { get; set; }
    public DateOnly? dueDate { get; set; }
    public required string status { get; set; }
    public string? closureNotes { get; set; }
}
