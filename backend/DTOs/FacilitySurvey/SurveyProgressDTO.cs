using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyProgressDTO
    {
        public int surveyId { get; set; }
        public int totalCompliances { get; set; }
        public int scoredCount { get; set; } // scoreId != null (includes NA)
        public int unscoredCount { get; set; } // scoreId == null, i.e, the "did we miss anything" check
        public bool isComplete => unscoredCount == 0;
        public int totalEvidenceChecks { get; set; }
        public int checkedEvidenceCount { get; set; }
        public int uncheckedEvidenceCount { get; set; }
        public bool isEvidenceComplete => uncheckedEvidenceCount == 0;
    }
}
