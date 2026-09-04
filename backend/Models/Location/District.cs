using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.Facilities;

namespace backend.Models.Location
{
    public class District
    {
        [Key]
        public int districtId { get; set; }
        [MaxLength(200)]
        public required string districtName { get; set; }
        public required int provinceId { get; set; }
        [ForeignKey("provinceId")]
        public Province? province { get; set; }
        public ICollection<Facility>? facilities { get; set; }
    }
}