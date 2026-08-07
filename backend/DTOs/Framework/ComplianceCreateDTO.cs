using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class ComplianceCreateDTO
    {
        public required string complianceSummary { get; set; }
        public required int criterionId { get; set; }
    }
}