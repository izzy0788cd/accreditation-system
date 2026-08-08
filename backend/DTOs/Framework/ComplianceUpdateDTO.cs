using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class ComplianceUpdateDTO
    {
        public required string complianceNumber { get; set; }
        public required string complianceSummary { get; set; }
        public required int criterionId { get; set; }
        //public required bool isApplicable { get; set; }
    }
}