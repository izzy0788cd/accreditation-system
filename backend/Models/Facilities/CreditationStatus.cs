using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Facilities
{
    public class CreditationStatus
    {
        [Key]
        public int creditationStatusId { get; set; }
        public required string creditationStatus { get; set; }
        public required string description { get; set; }
        public string? comments { get; set; }
        public ICollection<Facility>? facilities { get; set; }
    }
}