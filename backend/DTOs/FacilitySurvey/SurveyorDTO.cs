using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Humanizer;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyorDTO
    {
        public int surveyorId { get; set; }
        public int userId { get; set; }
        public string firstName { get; set; } = string.Empty;
        public string lastName { get; set; } = string.Empty;
        public string fullName => $"{firstName} {lastName}";
        public int surveyorCertStatusId { get; set; }
        public string surveyorCertStatusName { get; set; } = string.Empty;
        public int specializationId { get; set; }
        public string specializationName { get; set; } = string.Empty;
    }
}
