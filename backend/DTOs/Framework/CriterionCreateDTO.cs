using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace backend.DTOs.Framework
{
    public class CriterionCreateDTO
    {
        [MaxLength(500)]
        public required string criterionTitle { get; set; }
        public required int standardId { get; set; }
    }
}