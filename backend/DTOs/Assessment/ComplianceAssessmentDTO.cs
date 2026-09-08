using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Humanizer;

namespace backend.DTOs.Assessment
{
    public class ComplianceAssessmentDTO
    {
        public int complianceAssessmentId { get; set; }
        public int surveyId { get; set; }
        public int surveyorId { get; set; }
        public string surveyorName { get; set; } = string.Empty;
        public int complianceId { get; set; }
        public string complianceNumber { get; set; } = string.Empty;
        public string complianceSummary { get; set; } = string.Empty;
        public int? scoreId { get; set; }
        public int? scoreValue { get; set; }
        public int? riskRatingId { get; set; }
        public string? riskValue { get; set; }
        public string? complianceComments { get; set; }
    }
}
