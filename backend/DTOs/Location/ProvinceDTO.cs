using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Location
{
    public class ProvinceDTO
    {
        public int provinceId { get; set; }
        public string provinceName { get; set; } = string.Empty;
        public int regionId { get; set; }
        public string regionName { get; set; } = string.Empty;
    }
}