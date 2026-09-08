using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SpecializationDTO
    {
        public int specializationId { get; set; }
        public string specializationName { get; set; } = string.Empty;
        public string? description { get; set; }
    }
}
