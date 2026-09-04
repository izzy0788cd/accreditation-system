using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Accounts
{
    public class CompleteProfileDTO
    {
        public required string firstName { get; set; }
        public required string lastName { get; set; }
        public required int organizationId { get; set; }
        public string? position { get; set; }
        public required string email { get; set; }
        public required string phone { get; set; }
        public string? mobile { get; set; }
        public string? comments { get; set; }
    }
}