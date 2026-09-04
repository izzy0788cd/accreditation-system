import axios from "axios";

const BASE_URL = import.meta.env.VITE_API_BASE_URL;

const api = axios.create({ baseURL: BASE_URL });

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
    if (error.response && error.response.status === 401) {
      setAuthToken(null);
      window.location.href = "/login";
    }
    return Promise.reject(error);
  }
)

export const login = (username, password) => 
  api.post("/auth/login", { username, password });

export const getOwnProfile = () => api.get("/users/me");
export const updateOwnProfile = (data) => api.put("/users/me", data);

export const getAll = (resource) => api.get(`/${resource}`);
export const getOne = (resource, id) => api.get(`/${resource}/${id}`);
export const create = (resource, data) => api.post(`/${resource}`, data);
export const update = (resource, id, data) => api.put(`/${resource}/${id}`, data);
export const remove = (resource, id) => api.delete(`/${resource}/${id}`);
export const patchApplicability = (resource, id, isApplicable) => 
  api.patch(`/${resource}/${id}/applicability`, JSON.stringify(isApplicable), { headers: { "Content-Type": "application/json" } });