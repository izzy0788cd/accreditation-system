// UI capability map mirrors the backend's named authorization policies.
// This controls navigation and affordances only; the API remains authoritative.
export const policyNames = {
  referenceRead: "ReferenceData.Read",
  referenceManage: "ReferenceData.Manage",
  surveyWork: "Survey.Work",
  surveyReviewTeam: "Survey.ReviewTeam",
  surveyAdminister: "Survey.Administer",
  reportsGenerate: "Reports.Generate",
  actionsManage: "Actions.Manage",
  accountsManage: "Accounts.Manage",
};

const roles = {
  [policyNames.referenceRead]: ["Admin", "Team Lead", "Surveyor", "User", "Viewer"],
  [policyNames.referenceManage]: ["Admin"],
  [policyNames.surveyWork]: ["Admin", "Team Lead", "Surveyor"],
  [policyNames.surveyReviewTeam]: ["Admin", "Team Lead"],
  [policyNames.surveyAdminister]: ["Admin"],
  [policyNames.reportsGenerate]: ["Admin", "Team Lead"],
  [policyNames.actionsManage]: ["Admin", "Team Lead"],
  [policyNames.accountsManage]: ["Admin"],
};

export const hasCapability = (role, policy) => roles[policy]?.includes(role) || false;
export const isAdmin = (role) => role === "Admin";
export const isTeamLead = (role) => role === "Team Lead";
export const isSurveyor = (role) => role === "Surveyor";
export const canUseSurveyWorkspace = (role) => hasCapability(role, policyNames.surveyWork);
export const canReviewSurveyReports = (role) => hasCapability(role, policyNames.surveyReviewTeam);
export const canGenerateReports = (role) => hasCapability(role, policyNames.reportsGenerate);
export const canManageActionPlans = (role) => hasCapability(role, policyNames.actionsManage);
export const canManageReferenceData = (role) => hasCapability(role, policyNames.referenceManage);
export const canReadReferenceData = (role) => hasCapability(role, policyNames.referenceRead);
export const canAdministerSurveys = (role) => hasCapability(role, policyNames.surveyAdminister);
export const canManageAccounts = (role) => hasCapability(role, policyNames.accountsManage);

export const roleGroups = {
  surveyWorkspace: roles[policyNames.surveyWork],
  surveyReview: roles[policyNames.surveyReviewTeam],
  // The reference workspace stays deliberately limited in the UI. Survey work
  // can still read the framework data it needs through the API.
  reference: ["Admin", "User", "Viewer"],
};
