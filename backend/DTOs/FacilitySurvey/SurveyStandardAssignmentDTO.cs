namespace backend.DTOs.FacilitySurvey
{
    public class SurveyStandardAssignmentDTO
    {
        public int standardId { get; set; }
        public string standardNumber { get; set; } = string.Empty;
        public string standardTitle { get; set; } = string.Empty;
        public int surveyorId { get; set; }
        public string surveyorName { get; set; } = string.Empty;
    }
}
