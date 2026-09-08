using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyTypeDTO
    {
        public int surveyTypeId { get; set; }
        public string surveyTypeName { get; set; } = string.Empty;
        public string? description { get; set; }
    }
}
