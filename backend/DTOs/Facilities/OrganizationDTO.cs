using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.Facilities
{
    public class OrganizationDTO
    {
        public int organizationId { get; set; }
        public string organizationName { get; set; } = string.Empty;
        public required int categoryId { get; set; }
        public string? categoryName { get; set; }
        public string? description { get; set; }
    }
}