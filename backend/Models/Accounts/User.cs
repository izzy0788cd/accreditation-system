using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using backend.Models.Facilities;
using backend.Models.FaciltitySurvey;

namespace backend.Models.Accounts
{
    public class User
    {
        [Key]
        public int userId { get; set; }
        public int userAccountId { get; set; }
        [ForeignKey("userAccountId")]
        public UserAccount? userAccount { get; set; }
        public required string firstName { get; set; }
        public required string lastName { get; set; }
        public int organizationId { get; set; }
        [ForeignKey("organizationId")]
        public Organization? organization { get; set; }
        public string? position { get; set; }
        public required string email { get; set; }
        public required string phone { get; set; }
        public string? mobile { get; set; }
        public string? comments { get; set; }
        public ICollection<Surveyors>? surveyors { get; set; }
        public ICollection<Survey>? surveys { get; set; }
    }
}