using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyorCertStatusDTO
    {
        public int surveyorCertStatusId { get; set; }
        public string surveyorCertStatusName { get; set; } = string.Empty;
        public string? description { get; set; }
    }
}
