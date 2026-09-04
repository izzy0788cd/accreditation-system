using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Facilities
{
    public class Category
    {
        [Key]
        public int categoryId { get; set; }
        [MaxLength(100)]
        public required string categoryName { get; set; }
        public string? description { get; set; }
        public ICollection<Organization>? organizations { get; set; }
    }
}