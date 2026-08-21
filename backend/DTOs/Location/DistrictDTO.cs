using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Location
{
    public class DistrictDTO
    {
        public int districtId { get; set; }
        public string distrctName { get; set; } = string.Empty;
        public int provinceId { get; set; }
        public string provinceName { get; set; } = string.Empty;
    }
}