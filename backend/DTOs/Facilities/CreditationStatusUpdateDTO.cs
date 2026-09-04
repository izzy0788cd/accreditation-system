using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class CreditationStatusUpdateDTO
    {
        public required string creditationStatus { get; set; }
        public string? description { get; set; }
        public string? comments { get; set; }
    }
}