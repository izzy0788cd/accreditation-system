namespace backend.DTOs.FacilitySurvey
{
    public class SurveyStandardAssignmentUpdateDTO
    {
        public required int standardId { get; set; }
        public required int surveyorId { get; set; }
    }
}
