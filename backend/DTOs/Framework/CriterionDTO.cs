using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class CriterionDTO
    {
        public int criterionId { get; set; }
        public string criterionNumber { get; set; } = string.Empty;
        public string criterionTitle { get; set; } = string.Empty;
        public string? standardTitle { get; set; }
        public bool isApplicable { get; set; }
    }
}