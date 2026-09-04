using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Facilities
{
    public class Level
    {
        [Key]
        public int levelId { get; set; }
        [MaxLength(100)]
        public required string levelName { get; set; }
        [MaxLength(1)]
        public required int levelOrder { get; set; } //aka, level number
        public string? description { get; set; }
        public ICollection<Facility>? facilities { get; set; }
    }
}