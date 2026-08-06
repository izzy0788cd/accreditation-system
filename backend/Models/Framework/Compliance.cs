using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Framework
{
    public class Compliance
    {
        [Key]
        public required int complianceId { get; set; }
        public required string complianceSummary { get; set; }
        public required int criterionId { get; set; }
        [ForeignKey("criterionId")]
        public Criterion? criterion { get; set; }
        public bool isApplicable { get; set; }

        public ICollection<Evidence>? evidence { get; set; }
    }
}