using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class FacilityDTO
    {
        public int facilityId { get; set; }
        public int levelId { get; set; }
        public string levelName { get; set; } = string.Empty;
        public string facilityName { get; set; } = string.Empty;
        public int districtId { get; set; }
        public string districtName { get; set; } = string.Empty;
        public int organizationId { get; set; }
        public string organizationName { get; set; } = string.Empty;
        public int creditationStatusId { get; set; }
        public string creditationStatus { get; set; } = string.Empty;
        public string headOfService { get; set; } = string.Empty;
        public string comments { get; set; } = string.Empty;

    }
}