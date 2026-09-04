using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Security.Policy;
using System.Threading.Tasks;
using backend.Models.FaciltitySurvey;

namespace backend.Models.Assessment
{
    public class ComplianceEvidenceCheck
    {
        [Key]
        public int complianceEvidenceCheckId { get; set; }
        public int complianceAssessmentId { get; set; }
        [ForeignKey("complianceAssessmentId")]
        public ComplianceAssessment? complianceAssessment { get; set; }
        public int evidenceId { get; set; }
        [ForeignKey("evidenceId")]
        public Framework.Evidence? evidence { get; set; }
        public bool isChecked { get; set; }
    }
}