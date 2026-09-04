using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.Accounts;
using backend.Models.Assessment;

namespace backend.Models.FaciltitySurvey
{
    public class Surveyors
    {
        [Key]
        public int surveyorId { get; set; }
        public int userId { get; set; }
        [ForeignKey("userId")]
        public User? user { get; set; }
        public int surveyorCertStatusId { get; set; }
        [ForeignKey("surveyorCertStatusId")]
        public SurveyorCertStatus? surveyorCertStatus { get; set; }
        public int specializationId { get; set; }
        [ForeignKey("specializationId")]
        public Specialization? specialization { get; set; }
        public ICollection<Survey>? surveys { get; set; } //survey(s) team lead
        public ICollection<ComplianceAssessment>? complianceAssessments { get; set; }
    }
}