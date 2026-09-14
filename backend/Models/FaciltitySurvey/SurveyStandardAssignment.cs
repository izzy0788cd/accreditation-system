using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Models.Framework;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyStandardAssignment
    {
        [Key]
        public int surveyStandardAssignmentId { get; set; }

        public int surveyId { get; set; }
        [ForeignKey("surveyId")]
        public Survey? survey { get; set; }

        public int standardId { get; set; }
        [ForeignKey("standardId")]
        public Standard? standard { get; set; }

        public int surveyorId { get; set; }
        [ForeignKey("surveyorId")]
        public Surveyors? surveyor { get; set; }
    }
}
