using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.FaciltitySurvey;
using backend.Models.Framework;
using backend.Models.Scoring;

namespace backend.Models.Assessment
{
    public class ComplianceAssessment
    {
        [Key]
        public int complianceAssessmentId { get; set; }
        public int surveyorId { get; set; }
        [ForeignKey("surveyorId")]
        public Surveyors? surveyor { get; set; }
        public int surveyId { get; set; }
        [ForeignKey("surveyId")]
        public Survey? survey { get; set; }
        public int complianceId { get; set; }
        [ForeignKey("complianceId")]
        public Compliance? compliance { get; set; }
        public int scoreId { get; set; }
        [ForeignKey("scoreId")]
        public Score? score { get; set; }
        public int riskRatingId { get; set; }
        [ForeignKey("riskRatingId")]
        public RiskRating? riskRating { get; set; }
        public string? complianceComments { get; set; }
        public ICollection<ComplianceEvidenceCheck>? complianceEvidenceChecks { get; set; }
    }
}