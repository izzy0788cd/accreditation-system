using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class ComponentUpdateDTO
    {
        public required string componentNumber { get; set; }
        [MaxLength(100)]
        public required string componentName { get; set; }
        [MaxLength(500)]
        public required string componentSummary { get; set; }
    }
}