using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class StandardUpdateDTO
    {
        public required string standardTitle { get; set; }
        public required int componentId { get; set; }
        public required int functionId { get; set; }
        public required string standardSummary { get; set; }
    }
}