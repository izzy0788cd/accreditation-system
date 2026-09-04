using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace backend.Models.Location
{
    public class Region
    {
        [Key]
        public int regionId { get; set; }
        [MaxLength(100)]
        public required string regionName { get; set; }
        public ICollection<Province>? provinces { get; set; }
    }
}