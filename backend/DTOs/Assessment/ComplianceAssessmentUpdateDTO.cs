using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Assessment
{
    public class ComplianceAssessmentUpdateDTO
    {
        public int? surveyorId { get; set; }
        public int? scoreId { get; set; }
        public int? riskId { get; set; }
        public string? complianceComments { get; set; }
    }
}
