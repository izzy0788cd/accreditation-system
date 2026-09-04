using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.Accounts;
using Humanizer;

namespace backend.Models.Facilities
{
    public class Organization
    {
        [Key]
        public int organizationId { get; set; }
        public required string organizationName { get; set; }
        public int categoryId { get; set; }
        [ForeignKey("categoryId")]
        public Category? category { get; set; }
        public string? description { get; set; }
        public ICollection<Facility>? facilities { get; set; }
        public ICollection<User>? users { get; set; }
    }
}