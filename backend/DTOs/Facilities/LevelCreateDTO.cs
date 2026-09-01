using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class LevelCreateDTO
    {
        public string levelName { get; set; } = string.Empty;
        public int levelOrder { get; set; }
        public string description { get; set; } = string.Empty;
    }
}