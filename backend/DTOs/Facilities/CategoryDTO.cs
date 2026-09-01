using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class CategoryDTO
    {
        public int categoryId { get; set; }
        public string categoryName { get; set; } = string.Empty;
        public string description { get; set; } = string.Empty;
    }
}