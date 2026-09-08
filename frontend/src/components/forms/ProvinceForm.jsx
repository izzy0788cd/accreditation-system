import { useState, useEffect } from "react";
import { getAll } from "../../api/api";

function ProvinceForm({ initialData, onSubmit, onCancel }) {
  const [regions, setRegions] = useState([]);
  const [formData, setFormData] = useState({ provinceName: "", regionId: "" });

  useEffect(() => {
    getAll("regions").then((res) => setRegions(res.data));
  }, []);

  useEffect(() => {
    if (initialData) {
      setFormData({ provinceName: initialData.provinceName, regionId: initialData.regionId });
    } else {
      setFormData({ provinceName: "", regionId: "" });
    }
  }, [initialData]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit({ ...formData, regionId: Number(formData.regionId) });
  };

  return (
    <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
      <h2 className="text-lg font-semibold">{initialData ? "Edit Province" : "Add Province"}</h2>
      <div>
        <label className="block text-sm font-medium mb-1">Name</label>
        <input
          type="text"
          name="provinceName"
          value={formData.provinceName}
          onChange={handleChange}
          required
          maxLength={100}
          className="border rounded px-3 py-2 w-full"
        />
      </div>
      <div>
        <label className="block text-sm font-medium mb-1">Region</label>
        <select
          name="regionId"
          value={formData.regionId}
          onChange={handleChange}
          required
          className="border rounded px-3 py-2 w-full"
        >
          <option value="" disabled>Select a region</option>
          {regions.map((r) => (
            <option key={r.regionId} value={r.regionId}>{r.regionName}</option>
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

export default ProvinceForm;