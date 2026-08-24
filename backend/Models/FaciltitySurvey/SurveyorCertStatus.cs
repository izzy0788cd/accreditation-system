using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyorCertStatus
    {
        [Key]
        public int surveyorCertStatusId { get; set; }
        public required string surveyorCertStatusName { get; set; }
        public string? description { get; set; }
        public ICollection<Surveyors>? surveyors { get; set; }
    }
}