import { useState, useEffect } from "react";
import { getAll } from "../../api/api";

function DistrictForm({ initialData, onSubmit, onCancel }) {
  const [provinces, setProvinces] = useState([]);
  const [formData, setFormData] = useState({ districtName: "", provinceId: "" });

  useEffect(() => {
    getAll("provinces").then((res) => setProvinces(res.data));
  }, []);

  useEffect(() => {
    if (initialData) {
      setFormData({ districtName: initialData.districtName, provinceId: initialData.provinceId });
    } else {
      setFormData({ districtName: "", provinceId: "" });
    }
  }, [initialData]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit({ ...formData, provinceId: Number(formData.provinceId) });
  };

  return (
    <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
      <h2 className="text-lg font-semibold">{initialData ? "Edit District" : "Add District"}</h2>
      <div>
        <label className="block text-sm font-medium mb-1">Name</label>
        <input
          type="text"
          name="districtName"
          value={formData.districtName}
          onChange={handleChange}
          required
          maxLength={100}
          className="border rounded px-3 py-2 w-full"
        />
      </div>
      <div>
        <label className="block text-sm font-medium mb-1">Province</label>
        <select
          name="provinceId"
          value={formData.provinceId}
          onChange={handleChange}
          required
          className="border rounded px-3 py-2 w-full"
        >
          <option value="" disabled>Select a province</option>
          {provinces.map((p) => (
            <option key={p.provinceId} value={p.provinceId}>{p.provinceName}</option>
          ))}
        </select>
      </div>
      <div className="flex gap-2">
        <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          {initialData ? "Update" : "Add"}
        </button>
        <button type="button" onClick={onCancel} className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400">
          Cancel
        </button>
      </div>
    </form>
  );
}

export default DistrictForm;