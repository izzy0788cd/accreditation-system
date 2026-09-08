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
      const message = error.response?.data?.message || "Your changes could not be saved. Please try again.";
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
