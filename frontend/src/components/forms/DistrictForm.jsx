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
      <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Location directory</p><h2 className="mt-1 text-xl font-bold text-[#143c42]">{initialData ? "Edit district" : "Add a district"}</h2></div>
      <div>
        <label className="mb-1.5 block text-sm font-semibold text-[#284e53]">District name</label>
        <input
          type="text"
          name="districtName"
          value={formData.districtName}
          onChange={handleChange}
          required
          maxLength={100}
          placeholder="e.g. Goroka District"
          className="w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-[#087c77] focus:ring-2 focus:ring-teal-100"
        />
      </div>
      <div>
        <label className="mb-1.5 block text-sm font-semibold text-[#284e53]">Province</label>
        <select
          name="provinceId"
          value={formData.provinceId}
          onChange={handleChange}
          required
          className="w-full rounded-lg border border-[#b9d6d1] bg-white px-3 py-2.5 text-sm outline-none transition focus:border-[#087c77] focus:ring-2 focus:ring-teal-100"
        >
          <option value="" disabled>Select a province</option>
          {provinces.map((p) => (
            <option key={p.provinceId} value={p.provinceId}>{p.provinceName}</option>
          ))}
        </select>
      </div>
      <div className="flex gap-2">
        <button type="submit" className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#05635f]">
          {initialData ? "Save changes" : "Add district"}
        </button>
        <button type="button" onClick={onCancel} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#527076] transition hover:bg-slate-100">
          Cancel
        </button>
      </div>
    </form>
  );
}

export default DistrictForm;
