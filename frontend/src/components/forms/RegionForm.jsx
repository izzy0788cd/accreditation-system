import { useState, useEffect } from "react";

function RegionForm({ initialData, onSubmit, onCancel }) {
  const [formData, setFormData] = useState({ regionName: "" });

  useEffect(() => {
    if (initialData) {
      setFormData({ regionName: initialData.regionName });
    } else {
      setFormData({ regionName: "" });
    }
  }, [initialData]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(formData);
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Location directory</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">{initialData ? "Edit region" : "Add a region"}</h2></div>
      <div>
        <label className="mb-1.5 block text-sm font-semibold text-[#153a70]">Region name</label>
        <input
          type="text"
          name="regionName"
          value={formData.regionName}
          onChange={handleChange}
          required
          maxLength={100}
          placeholder="e.g. Highlands Region"
          className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]"
        />
      </div>
      <div className="flex gap-2">
        <button type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#0d6531]">
          {initialData ? "Save changes" : "Add region"}
        </button>
        <button type="button" onClick={onCancel} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] transition hover:bg-slate-100">
          Cancel
        </button>
      </div>
    </form>
  );
}

export default RegionForm;
