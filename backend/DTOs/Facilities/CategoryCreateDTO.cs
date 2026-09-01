using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class CategoryCreateDTO
    {
        public required string categoryName { get; set; }
        public string? description { get; set; }
    }
}