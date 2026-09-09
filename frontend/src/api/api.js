import axios from "axios";

const BASE_URL = import.meta.env.VITE_API_BASE_URL;

const api = axios.create({ baseURL: BASE_URL, withCredentials: true });

export const setAuthToken = (token) => {
  if (token) {
    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
  } else {
    delete api.defaults.headers.common["Authorization"];
  }
}

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const isAuthRequest = error.config?.url?.includes("/auth/login") || error.config?.url?.includes("/auth/refresh");
    if (error.response?.status === 401 && !isAuthRequest) {
      setAuthToken(null);
      window.location.href = "/login";
    }
    if (error.config?.showErrorDialog) {
      const responseData = error.response?.data;
      const message = typeof responseData === "string" ? responseData : responseData?.message || "Your changes could not be saved. Please try again.";
      window.dispatchEvent(new CustomEvent("api-save-error", { detail: message }));
    }
    return Promise.reject(error);
  }
);

export const login = (username, password) => 
  api.post("/auth/login", { username, password });
export const refreshSession = () => api.post("/auth/refresh");
export const logoutSession = () => api.post("/auth/logout");

export const getOwnProfile = () => api.get("/users/me");
export const updateOwnProfile = (data) => api.put("/users/me", data);

export const getAll = (resource) => api.get(`/${resource}`);
export const getOne = (resource, id) => api.get(`/${resource}/${id}`);
const saveRequest = (request) => {
  window.dispatchEvent(new CustomEvent("api-save-state", { detail: true }));
  return request.finally(() => window.dispatchEvent(new CustomEvent("api-save-state", { detail: false })));
};

export const create = (resource, data) => saveRequest(api.post(`/${resource}`, data, { showErrorDialog: true }));
export const update = (resource, id, data) => saveRequest(api.put(`/${resource}/${id}`, data, { showErrorDialog: true }));
export const remove = (resource, id) => saveRequest(api.delete(`/${resource}/${id}`, { showErrorDialog: true }));
export const patchApplicability = (resource, id, isApplicable) => 
  saveRequest(api.patch(`/${resource}/${id}/applicability`, JSON.stringify(isApplicable), { headers: { "Content-Type": "application/json" }, showErrorDialog: true }));

export const getSurveyProgress = (surveyId) => api.get(`/surveys/${surveyId}/progress`);
export const getStandardProgress = (surveyId, standardId) => api.get(`/surveys/${surveyId}/standards/${standardId}/progress`);
export const resetSurvey = (surveyId) => saveRequest(api.post(`/surveys/${surveyId}/reset`, null, { showErrorDialog: true }));
export const getSurveyStandardAssignments = (surveyId) => api.get(`/surveys/${surveyId}/standard-assignments`);
export const updateSurveyStandardAssignments = (surveyId, assignments) => saveRequest(api.put(`/surveys/${surveyId}/standard-assignments`, assignments, { showErrorDialog: true }));
export const getSurveyAssessments = (surveyId) => api.get(`/complianceAssessments/survey/${surveyId}`);
export const getSurveyAssessmentOverview = (surveyId) => api.get(`/complianceAssessments/survey/${surveyId}/overview`);
export const getSurveyEvidenceChecks = (surveyId) => api.get(`/complianceEvidenceChecks/survey/${surveyId}`);
export const getAssessmentEvidenceChecks = (assessmentId) => api.get(`/complianceEvidenceChecks/assessment/${assessmentId}`);
export const updateAssessment = (assessmentId, data) => saveRequest(api.put(`/complianceAssessments/${assessmentId}`, data, { showErrorDialog: true }));
export const patchEvidenceCheck = (checkId, isChecked) => saveRequest(api.patch(`/complianceEvidenceChecks/${checkId}/checked`, JSON.stringify(isChecked), { headers: { "Content-Type": "application/json" }, showErrorDialog: true }));
