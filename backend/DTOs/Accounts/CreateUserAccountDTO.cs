using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Accounts
{
    public class CreateUserAccountDTO
    {
        public required string username { get; set; }
        public required string temporaryPassword { get; set; }
        public required int roleId { get; set; }
    }
}