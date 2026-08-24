using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Scoring
{
    public class Score
    {
        [Key]
        public int scoreId { get; set; }
        public required string scoreValue { get; set; } //0 = not met, 1 = met with recommendation(s), 2 = met, NA = not applicable, i.e., don't calculate
        public required string scoreLabel { get; set; }
        public string? description { get; set; }
    }
}