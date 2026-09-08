using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SpecializationUpdateDTO
    {
        public string specializationName { get; set; } = string.Empty;
        public string? description { get; set; }
    }
}
