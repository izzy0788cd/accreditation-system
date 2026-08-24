using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.FaciltitySurvey;
using backend.Models.Location;
using Humanizer;

namespace backend.Models.Facilities
{
    public class Facility
    {
        [Key]
        public int facilityId { get; set; }
        public int levelId { get; set; }
        [ForeignKey("levelId")]
        public Level? level { get; set; }
        public required string facilityName { get; set; }
        public int districtId { get; set; }
        [ForeignKey("districtId")]
        public District? district { get; set; }
        public int organizationId { get; set; }
        [ForeignKey("organizationId")]
        public Organization? organization { get; set; }
        public int creditationStatusId { get; set; }
        [ForeignKey("creditationId")]
        public CreditationStatus? creditationStatus { get; set; }
        public string? headOfService { get; set; }
        public string? comments { get; set; }
        public ICollection<Survey>? surveys { get; set; }
    }
}