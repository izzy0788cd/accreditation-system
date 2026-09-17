using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyToolkitSnapshot
    {
        [Key]
        public int surveyToolkitSnapshotId { get; set; }
        public int surveyId { get; set; }
        [ForeignKey("surveyId")]
        public Survey? survey { get; set; }
        public required string scopeType { get; set; }
        public string? templateSummary { get; set; }
        public string? customisationReason { get; set; }
        public ICollection<SurveyToolkitSnapshotStandard>? standards { get; set; }
        public ICollection<SurveyToolkitSnapshotCompliance>? compliances { get; set; }
    }
}
