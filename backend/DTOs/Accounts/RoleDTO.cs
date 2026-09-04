using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Accounts
{
    public class RoleDTO
    {
        public int roleId { get; set; }
        public required string roleName { get; set; }
        public string? description { get; set; }
    }
}