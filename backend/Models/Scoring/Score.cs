using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.Assessment;
using Humanizer;

namespace backend.Models.Scoring
{
    public class Score
    {
        [Key]
        public int scoreId { get; set; }
        public int? scoreValue { get; set; } //nullable int: 0, 1, 2 — null represents "Not Applicable"
        public required string scoreLabel { get; set; } //e.g. "Non-Compliant", "Partially Compliant", "Compliant", "Not Applicable"
        public string? description { get; set; }
        public ICollection<ComplianceAssessment>? complianceAssessments { get; set; }
    }
}
