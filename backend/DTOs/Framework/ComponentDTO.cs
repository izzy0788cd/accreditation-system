using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class ComponentDTO
    {
        public int componentId { get; set; }
        public string componentNumber { get; set; } = string.Empty;
        public string componentName { get; set; } = string.Empty;
        public string componentSummary { get; set; } = string.Empty;
    }
}