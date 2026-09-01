using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class CreditationStatusDTO
    {
        public int creditationStatusId { get; set; }
        public string creditationStatus { get; set; } = string.Empty;
        public string description { get; set; } = string.Empty;
        public string comments { get; set; } = string.Empty;
    }
}