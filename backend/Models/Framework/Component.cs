using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace backend.Models.Framework
{
    public class Component
    {
        [Key]
        public required int componentId { get; set; }
        [MaxLength(100)]
        public required string componentName { get; set; }
        [MaxLength(500)]
        public string? componentSummary { get; set; }

        public ICollection<Standard>? standards { get; set; }
    }
}