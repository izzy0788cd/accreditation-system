namespace backend.DTOs.Reports;

public class StandardServiceAreaDTO
{
    public string name { get; set; } = "";
    public string overview { get; set; } = "";
    public string? commendations { get; set; }
    public string? areasOfConcern { get; set; }
    public string? recommendations { get; set; }
}
