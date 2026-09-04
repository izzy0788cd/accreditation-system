using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Login
{
    public class LoginRequestDTO
    {
        public required string username { get; set; }
        public required string password { get; set; }
    }
}