using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class EvidenceCreateDTO
    {
        public required string evidenceSummary { get; set; }
        public int complianceId { get; set; }
    }
}