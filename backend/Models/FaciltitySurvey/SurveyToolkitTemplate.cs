using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.Facilities;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyToolkitTemplate
    {
        [Key]
        public int surveyToolkitTemplateId { get; set; }
        public required string templateName { get; set; }
        public string templateVersion { get; set; } = "1.0";
        public string? description { get; set; }
        public int? levelId { get; set; }
        [ForeignKey("levelId")]
        public Level? level { get; set; }
        public bool isServiceOverlay { get; set; } = false;
        public bool isActive { get; set; } = true;
        public ICollection<SurveyToolkitTemplateStandard>? standards { get; set; }
        public ICollection<SurveyToolkitTemplateCompliance>? compliances { get; set; }
    }
}
