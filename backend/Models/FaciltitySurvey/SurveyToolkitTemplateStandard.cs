using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.Framework;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyToolkitTemplateStandard
    {
        [Key]
        public int surveyToolkitTemplateStandardId { get; set; }
        public int surveyToolkitTemplateId { get; set; }
        [ForeignKey("surveyToolkitTemplateId")]
        public SurveyToolkitTemplate? surveyToolkitTemplate { get; set; }
        public int standardId { get; set; }
        [ForeignKey("standardId")]
        public Standard? standard { get; set; }
    }
}
