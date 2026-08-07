using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class EvidenceDTO
    {
        public int evidenceId { get; set; }
        public int complianceId { get; set; }
        public string evidenceSummary { get; set; } = string.Empty;
        public bool isApplicable { get; set; }
    }
}