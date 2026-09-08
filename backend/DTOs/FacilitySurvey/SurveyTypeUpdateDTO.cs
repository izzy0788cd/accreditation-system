using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyTypeUpdateDTO
    {
        public string surveyTypeName { get; set; } = string.Empty;
        public string? description { get; set; }
    }
}
