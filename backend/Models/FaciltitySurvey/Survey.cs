using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.Accounts;
using backend.Models.Assessment;
using backend.Models.Facilities;

namespace backend.Models.FaciltitySurvey
{
    public class Survey
    {
        [Key]
        public int surveyId { get; set; }
        public int facilityId { get; set; }
        [ForeignKey("facilityId")]
        public Facility? facility { get; set; }
        public int surveyTypeId { get; set; }
        [ForeignKey("surveyTypeId")]
        public SurveyType? surveyType { get; set; }
        public int surveyorId { get; set; } // survey team lead. 1 survey must have 1 team lead, but 1 team lead can have many surveys
        [ForeignKey("surveyorId")]
        public Surveyors? surveyor { get; set; }
        public DateOnly startDate { get; set; } // approx. start date of survey
        public DateOnly endDate { get; set; } // approx. end date of survey
        public ICollection<ComplianceAssessment>? complianceAssessments { get; set; }
    }
}