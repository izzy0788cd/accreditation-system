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
        public int? scoreValue { get; set; } //1–4; null represents "Not Applicable"
        public required string scoreLabel { get; set; }
        public string? description { get; set; } //Rating rationale
        public string? guidance { get; set; } //Surveyor guidance for the rating
        public ICollection<ComplianceAssessment>? complianceAssessments { get; set; }
    }
}
