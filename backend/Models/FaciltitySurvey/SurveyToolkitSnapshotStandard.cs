using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.Framework;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyToolkitSnapshotStandard
    {
        [Key]
        public int surveyToolkitSnapshotStandardId { get; set; }
        public int surveyToolkitSnapshotId { get; set; }
        [ForeignKey("surveyToolkitSnapshotId")]
        public SurveyToolkitSnapshot? surveyToolkitSnapshot { get; set; }
        public int standardId { get; set; }
        [ForeignKey("standardId")]
        public Standard? standard { get; set; }
    }
}
