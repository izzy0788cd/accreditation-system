using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class StandardDTO
    {
        public int standardId { get; set; }
        public string standardNumber { get; set; } = string.Empty;
        public string standardTitle { get; set; } = string.Empty;
        public string? componentNumber { get; set; }
        public string? componentName { get; set; }
        public string? functionNumber { get; set; }
        public string? functionTitle { get; set; }
        public string standardSummary { get; set; } = string.Empty;
    }
}