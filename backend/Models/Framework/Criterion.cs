using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Framework
{
    public class Criterion
    {
        [Key]
        public required int criterionId { get; set; }
        [MaxLength(500)]
        public required string criterionTitle { get; set; }
        public required int standardId { get; set; }
        [ForeignKey("standardId")]
        public Standard? standard { get; set; }
        [Required]
        public bool isApplicable { get; set; }

        public ICollection<Compliance>? compliances { get; set; }
    }
}