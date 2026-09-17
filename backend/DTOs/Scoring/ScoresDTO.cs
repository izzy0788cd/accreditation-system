using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Scoring
{
    public class ScoresDTO
    {
        public int scoreId { get; set; }
        public int? scoreValue { get; set; } //1 = poor, 2 = fair, 3 = good, 4 = full achievement; N/A is null
        public required string scoreLabel { get; set; }
        public string? description { get; set; } //Rating rationale
        public string? guidance { get; set; }
    }
}
