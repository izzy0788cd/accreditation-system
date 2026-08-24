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
        [MaxLength(1)]
        public required string levelNumber { get; set; }
        [MaxLength(100)]
        public required string levelLabel { get; set; }
        public string? description { get; set; }
        public ICollection<Facility>? facilities { get; set; }
    }
}