namespace backend.Authorization;

/// <summary>
/// Central names for authorization policies. Controllers must use these instead of
/// duplicating role lists so that role changes remain deliberate and auditable.
/// </summary>
public static class PolicyNames
{
    public const string ReferenceDataRead = "ReferenceData.Read";
    public const string ReferenceDataManage = "ReferenceData.Manage";
    public const string SurveyWork = "Survey.Work";
    public const string SurveyReviewTeam = "Survey.ReviewTeam";
    public const string SurveyAdminister = "Survey.Administer";
    public const string ReportsGenerate = "Reports.Generate";
    public const string AccountsManage = "Accounts.Manage";
}
