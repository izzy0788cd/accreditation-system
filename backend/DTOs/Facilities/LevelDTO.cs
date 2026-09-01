using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class LevelDTO
    {
        public int levelId { get; set; }
        public required string levelName { get; set; }
        public required int levelOrder { get; set; } //aka level number
        public string? description { get; set; }
    }
}