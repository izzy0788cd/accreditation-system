export const canManageReferenceData = (roleName) => roleName === "Admin";

// These names are also enforced by the API's role policies.  Adding a role
// without adding its permissions would create an account that can sign in but
// cannot use the intended parts of the toolkit.
export const supportedRoleNames = Object.freeze(["Admin", "Surveyor", "Team Lead", "Viewer"]);
export const isSupportedRole = (roleName) => supportedRoleNames.includes(roleName);
