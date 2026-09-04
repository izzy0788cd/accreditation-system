using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Humanizer;

namespace backend.DTOs.Facilities
{
    public class FacilityUpdateDTO
    {
        public int levelId { get; set; }
        public required string facilityName { get; set; }
        public int districtId { get; set; }
        public int organizationId { get; set; }
        public int creditationStatusId { get; set; }
        public string? headOfService { get; set; }
        public string? comments { get; set; }
    }
}