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
    }
}
