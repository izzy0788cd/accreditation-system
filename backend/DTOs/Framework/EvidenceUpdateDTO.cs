using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class EvidenceUpdateDTO
    {
        public required string evidenceNumber { get; set; }
        public required string evidenceSummary { get; set; }
        public required int complianceId { get; set; }
        public required bool isApplicable { get; set; }
    }
}