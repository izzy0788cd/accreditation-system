using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace backend.DTOs.Login
{
    public class LoginResponseDTO
    {
        public required string token { get; set; }
        public DateTime ExpiresAt { get; set; }
        public required string username { get; set; }
        public required string roleName { get; set; }
    }
}