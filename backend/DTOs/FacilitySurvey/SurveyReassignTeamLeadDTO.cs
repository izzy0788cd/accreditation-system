using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DTOs.FacilitySurvey
{
    public class SurveyReassignTeamLeadDTO
    {
        public int surveyorId { get; set; } //use to change the team lead, admin/preceptor access
    }
}
