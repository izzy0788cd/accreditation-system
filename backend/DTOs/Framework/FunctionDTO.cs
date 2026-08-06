using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class FunctionDTO
    {
        public int functionId { get; set; }
        public string functionTitle { get; set; } = string.Empty;
        public string functionSummary { get; set; } = string.Empty;
    }
}