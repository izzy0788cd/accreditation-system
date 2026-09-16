using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyCreateDTO
    {
        public required int facilityId { get; set; }
        public required int surveyTypeId { get; set; }
        public required int surveyorId { get; set; }
        public required DateOnly startDate { get; set; }
        public required DateOnly endDate { get; set; }
        public string scopeType { get; set; } = "Full";
        public List<int>? toolkitTemplateIds { get; set; }
        public List<int>? selectedStandardIds { get; set; }
        public List<int>? selectedComplianceIds { get; set; }
        public string? customisationReason { get; set; }
    }
}
