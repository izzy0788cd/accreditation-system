using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace backend.Models.Framework
{
    public class Evidence
    {
        [Key]
        public int evidenceId { get; set; }
        [MaxLength(20)]
        public required string evidenceNumber { get; set; }
        public required string evidenceSummary { get; set; }
        public required int complianceId { get; set; }
        [ForeignKey("complianceId")]
        [JsonIgnore]
        public Compliance? compliance { get; set; }
        public bool isApplicable { get; set; }
    }
}