using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Humanizer;

namespace backend.DTOs.Location
{
    public class ProvinceUpdateDTO
    {
        public required string provinceName { get; set; }
        public int regionId { get; set; }
    }
}