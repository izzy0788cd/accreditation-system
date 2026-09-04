using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Humanizer;

namespace backend.Models.FaciltitySurvey
{
    public class Specialization
    {
        [Key]
        public int specializationId { get; set; }
        public required string specializationName { get; set; }
        public string? description { get; set; }
        public ICollection<Surveyors>? surveyors { get; set; }
    }
}