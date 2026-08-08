using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class ComplianceDTO
    {
        public int complianceId { get; set; }
        [MaxLength(20)]
        public string complianceNumber { get; set; } = string.Empty;
        public string complianceSummary { get; set; } = string.Empty;
        public int criterionId { get; set; }
        public bool isApplicable { get; set; }
    }
}