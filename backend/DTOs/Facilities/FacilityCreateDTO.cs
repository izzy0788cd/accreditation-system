using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class FacilityCreateDTO
    {
        public required int levelId { get; set; }
        public required string facilityName { get; set; }
        public required int districtId { get; set; }
        public int organizationId { get; set; }
        public required int creditationStatusId { get; set; }
        public required string headOfService { get; set; }
        public string? comments { get; set; }
    }
}