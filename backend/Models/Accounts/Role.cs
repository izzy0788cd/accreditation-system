using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Accounts
{
    public class Role
    {
        [Key]
        public int roleId { get; set; }
        public required string roleName { get; set; }
        public string? description { get; set; }
        public ICollection<UserAccount>? userAccounts { get; set; }
    }
}