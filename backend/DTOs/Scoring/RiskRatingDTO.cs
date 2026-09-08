using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Scoring
{
    public class RiskRatingDTO
    {
        public int riskId { get; set; }
        public string riskValue { get; set; } = string.Empty;
        public string riskLabel { get; set; } = string.Empty;
        public int? severityOrder { get; set; }
        public string? description { get; set; }
    }
}
