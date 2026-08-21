using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace backend.DTOs.Location
{
    public class RegionUpdateDTO
    {
        public required string regionName { get; set; }
    }
}