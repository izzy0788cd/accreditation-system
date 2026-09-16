namespace backend.DTOs.FacilitySurvey
{
    public class SurveyToolkitTemplateCreateDTO
    {
        public required string templateName { get; set; }
        public string? templateVersion { get; set; }
        public string? description { get; set; }
        public int? levelId { get; set; }
        public bool isServiceOverlay { get; set; }
        public bool isActive { get; set; } = true;
        public List<int> standardIds { get; set; } = [];
        public List<int> complianceIds { get; set; } = [];
    }
}
