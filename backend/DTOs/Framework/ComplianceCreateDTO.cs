using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class ComplianceCreateDTO
    {
        [MaxLength(20)]
        public required string complianceNumber { get; set; }
        public required string complianceSummary { get; set; }
        public required int criterionId { get; set; }
    }
}