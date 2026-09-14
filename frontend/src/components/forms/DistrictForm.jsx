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
    <form onSubmit={handleSubmit} className="space-y-5">
      <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Location directory</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">{initialData ? "Edit district" : "Add a district"}</h2></div>
      <div>
        <label className="mb-1.5 block text-sm font-semibold text-[#153a70]">District name</label>
        <input
          type="text"
          name="districtName"
          value={formData.districtName}
          onChange={handleChange}
          required
          maxLength={100}
          placeholder="e.g. Goroka District"
          className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]"
        />
      </div>
      <div>
        <label className="mb-1.5 block text-sm font-semibold text-[#153a70]">Province</label>
        <select
          name="provinceId"
          value={formData.provinceId}
          onChange={handleChange}
          required
          className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm outline-none transition focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]"
        >
          <option value="" disabled>Select a province</option>
          {provinces.map((p) => (
            <option key={p.provinceId} value={p.provinceId}>{p.provinceName}</option>
          ))}
        </select>
      </div>
      <div className="flex gap-2">
        <button type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#0d6531]">
          {initialData ? "Save changes" : "Add district"}
        </button>
        <button type="button" onClick={onCancel} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] transition hover:bg-slate-100">
          Cancel
        </button>
      </div>
    </form>
  );
}

export default DistrictForm;
