using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Location
{
    public class Province
    {
        [Key]
        public int provinceId { get; set; }
        [MaxLength(100)]
        public required string provinceName { get; set; }
        public required int regionId { get; set; }
        [ForeignKey("regionId")]
        public Region? region { get; set; }
        public ICollection<District>? districts { get; set; }
    }
}