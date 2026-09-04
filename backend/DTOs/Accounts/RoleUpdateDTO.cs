using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Accounts
{
    public class RoleUpdateDTO
    {
        public required string roleName { get; set; }
        public string? description { get; set; }
    }
}