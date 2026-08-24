using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Accounts
{
    public class UserAccount
    {
        [Key]
        public int userAccountId { get; set; }
        public int roleId { get; set; }
        [ForeignKey("roleId")]
        public Role? role { get; set; }
        public required string username { get; set; }
        public required string passwordHash { get; set; }
        public bool isActive { get; set; }
        public DateOnly dateCreated { get; set; }
        public User? user { get; set; }
    }
}