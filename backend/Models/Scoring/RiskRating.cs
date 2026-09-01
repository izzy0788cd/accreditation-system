using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.Assessment;

namespace backend.Models.Scoring
{
    public class RiskRating
    {
        [Key]
        public int riskId { get; set; }
        public required string riskValue { get; set; } //using 'L' = low, 'M' = medium, 'H' = high & 'E' = extreme
        public required string riskLabel { get; set; }
        public string? description { get; set; }
        public ICollection<ComplianceAssessment>? complianceAssessments { get; set; }
    }
}