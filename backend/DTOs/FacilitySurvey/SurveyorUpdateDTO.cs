using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Humanizer;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyorUpdateDTO
    {
        public int surveyorCertStatusId { get; set; }
        public int specializationId { get; set; }
    }
}
