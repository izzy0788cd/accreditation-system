using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyorCreateDTO
    {
        public int userId { get; set; }
        public int surveyorCertStatusId { get; set; }
        public int specializationId { get; set; }
    }
}
