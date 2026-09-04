using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Location
{
    public class DistrictUpdateDTO
    {
        public required string districtName { get; set; }
        public int provinceId { get; set; }
    }
}