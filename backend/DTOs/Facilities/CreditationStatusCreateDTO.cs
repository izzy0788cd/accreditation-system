using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class CreditationStatusCreateDTO
    {
        public required string creditationStatus { get; set; }
        public string? desctiption { get; set; }
        public string? comments { get; set; }
    }
}