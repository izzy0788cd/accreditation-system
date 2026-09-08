using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Scoring
{
    public class ScoreUpdateDTO
    {
        public int? scoreValue { get; set; } //0 = not met, 1 = met with recommendation(s), 2 = met, NA = not applicable, i.e., don't calculate
        public required string scoreLabel { get; set; }
        public string? description { get; set; }
    }
}
