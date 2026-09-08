using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Scoring
{
    public class RiskRatingUpdateDTO
    {
        public required string riskValue { get; set; }
        public required string riskLabel { get; set; }
        public int? severityOrder { get; set; }
        public string? description { get; set; }
    }
}
