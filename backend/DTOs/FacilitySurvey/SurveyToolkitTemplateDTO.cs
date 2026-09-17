namespace backend.DTOs.FacilitySurvey
{
    public class SurveyToolkitTemplateDTO
    {
        public int surveyToolkitTemplateId { get; set; }
        public string templateName { get; set; } = string.Empty;
        public string templateVersion { get; set; } = string.Empty;
        public string? description { get; set; }
        public int? levelId { get; set; }
        public string? levelName { get; set; }
        public bool isServiceOverlay { get; set; }
        public bool isActive { get; set; }
        public List<int> standardIds { get; set; } = [];
        public List<int> complianceIds { get; set; } = [];
    }
}
