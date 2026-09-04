using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Accounts
{
    public class UserAccountResponseDTO
    {
        public int userAccountId { get; set; }
        public required string username { get; set; }
        public required string roleName { get; set; }
        public bool isActive { get; set; }
        public DateTime dateCreated { get; set; }
    }
}