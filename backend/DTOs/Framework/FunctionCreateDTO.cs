using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class FunctionCreateDTO
    {
        [MaxLength(100)]
        public required string functionNumber { get; set; }
        [MaxLength(100)]
        public required string functionTitle { get; set; }
        [MaxLength(1000)]
        public required string functionSummary { get; set; }
    }
}