using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.Framework;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyToolkitTemplateCompliance
    {
        [Key]
        public int surveyToolkitTemplateComplianceId { get; set; }
        public int surveyToolkitTemplateId { get; set; }
        [ForeignKey("surveyToolkitTemplateId")]
        public SurveyToolkitTemplate? surveyToolkitTemplate { get; set; }
        public int complianceId { get; set; }
        [ForeignKey("complianceId")]
        public Compliance? compliance { get; set; }
    }
}
