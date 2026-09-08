using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Assessment
{
    public class ComplianceEvidenceCheckDTO
    {
        public int complianceEvidenceCheckId { get; set; }
        public int complianceAssessmentId { get; set; }
        public int evidenceId { get; set; }
        public string evidenceNumber { get; set; } = string.Empty;
        public string evidenceSummary { get; set; } = string.Empty;
        public bool isChecked { get; set; }
    }
}
