using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Accounts
{
    public class UserSummaryDTO
    {
        public int userId { get; set; }
        public int userAccountId { get; set; }
        public string firstName { get; set; } = string.Empty;
        public string lastName { get; set; } = string.Empty;
        public int organizationId { get; set; }
        public string? position { get; set; }
        public string email { get; set; } = string.Empty;
        public string phone { get; set; } = string.Empty;
        public string? mobile { get; set; }
        public string? comments { get; set; }
    }
}
