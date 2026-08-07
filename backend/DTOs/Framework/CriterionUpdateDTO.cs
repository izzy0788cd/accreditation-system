using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Framework
{
    public class CriterionUpdateDTO
    {
        [MaxLength(20)]
        public required string criterionNumber { get; set; }
        [MaxLength(500)]
        public required string criterionTitle { get; set; }
        public required int standardId { get; set; }
        public required bool isApplicable { get; set; }
    }
}