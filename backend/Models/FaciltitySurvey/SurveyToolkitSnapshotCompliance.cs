using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.Framework;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyToolkitSnapshotCompliance
    {
        [Key]
        public int surveyToolkitSnapshotComplianceId { get; set; }
        public int surveyToolkitSnapshotId { get; set; }
        [ForeignKey("surveyToolkitSnapshotId")]
        public SurveyToolkitSnapshot? surveyToolkitSnapshot { get; set; }
        public int complianceId { get; set; }
        [ForeignKey("complianceId")]
        public Compliance? compliance { get; set; }
    }
}
