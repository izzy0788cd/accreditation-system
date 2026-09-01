using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class OrganizationUpdateDTO
    {
        public required string organizationName { get; set; }
        public required int categoryId { get; set; }
        public string? description { get; set; }
    }
}