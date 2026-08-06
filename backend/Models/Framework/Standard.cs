using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace backend.Models.Framework
{
    public class Standard
    {
        [Key]
        public int standardId { get; set; }
        [MaxLength(200)]
        public required string standardTitle { get; set; }
        public required int functionId { get; set; }
        [ForeignKey("functionId")]
        public Function? function { get; set; }
        public required int componentId { get; set; }
        [ForeignKey("componentId")] 
        public Component? component { get; set; }
        public required string standardSummary { get; set; }
        [JsonIgnore]
        public ICollection<Criterion>? criteria { get; set; }
    }
}