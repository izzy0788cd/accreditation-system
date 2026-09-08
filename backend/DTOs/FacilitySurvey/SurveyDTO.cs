using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Humanizer;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyDTO
    {
        public int surveyId { get; set; }
        public int facilityId { get; set; }
        public string facilityName { get; set; } = string.Empty;
        public int surveyTypeId { get; set; }
        public string surveyTypeName { get; set; } = string.Empty;
        public int surveyorId { get; set; } //survey team lead
        public string surveyorName { get; set; } = string.Empty;
        public DateOnly startDate { get; set; }
        public DateOnly endDate { get; set; }
    }
}
