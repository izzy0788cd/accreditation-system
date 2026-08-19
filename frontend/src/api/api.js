import axios from "axios";

const BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const getAll = (resource) => axios.get(`${BASE_URL}/${resource}`);
export const getOne = (resource, id) => axios.get(`${BASE_URL}/${resource}/${id}`);
export const create = (resource, data) => axios.post(`${BASE_URL}/${resource}`, data);
export const update = (resource, id, data) => axios.put(`${BASE_URL}/${resource}/${id}`, data);
export const remove = (resource, id) => axios.delete(`${BASE_URL}/${resource}/${id}`);
export const patchApplicability = (resource, id, isApplicable) => 
  axios.patch(`${BASE_URL}/${resource}/${id}/applicability`, JSON.stringify(isApplicable), { headers: { "Content-Type": "application/json" } });