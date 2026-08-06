using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Framework
{
    public class Function
    {
        [Key]
        public required int functionId { get; set; }
        [MaxLength(200)]
        public required string functiontTitle { get; set; }
        [MaxLength(500)]
        public string? functionSummary { get; set; }

        public ICollection<Standard>? standards { get; set; }
    }
}