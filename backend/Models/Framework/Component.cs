using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace backend.Models.Framework
{
    public class Component
    {
        [Key]
        public int componentId { get; set; }
        [MaxLength(100)]
        public required string componentName { get; set; }
        [MaxLength(500)]
        public required string componentSummary { get; set; }
        [JsonIgnore]
        public ICollection<Standard>? standards { get; set; }
    }
}