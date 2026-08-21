using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Location
{
    public class ProvinceCreateDTO
    {
        public required string provinceName { get; set; }
        public int regionId { get; set; }
    }
}