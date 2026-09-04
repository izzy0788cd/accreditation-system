using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.FaciltitySurvey
{
    public class SurveyType
    {
        [Key]
        public int surveyTypeId { get; set; }
        public required string surveyTypeName { get; set; } //only 2 types, 'external' and 'internal'
        public string? description { get; set; }
        public ICollection<Survey>? surveys { get; set; }
    }
}