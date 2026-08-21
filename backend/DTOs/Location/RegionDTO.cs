using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Location
{
    public class RegionDTO
    {
        public int regionId { get; set; }
        public string regionName { get; set; } = string.Empty;
    }
}