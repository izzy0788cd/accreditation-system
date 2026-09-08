using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class StandardProgressDTO
    {
        public int surveyId { get; set; }
        public int standardId { get; set; }
        public int totalCompliances { get; set; }
        public int scoredCount { get; set; }
        public int unscoredCount { get; set; }
        public bool isComplete => unscoredCount == 0;
    }
}
