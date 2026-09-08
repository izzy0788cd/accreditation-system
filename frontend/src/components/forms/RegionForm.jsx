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
    <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
      <h2 className="text-lg font-semibold">{initialData ? "Edit Region" : "Add Region"}</h2>
      <div>
        <label className="block text-sm font-medium mb-1">Name</label>
        <input
          type="text"
          name="regionName"
          value={formData.regionName}
          onChange={handleChange}
          required
          maxLength={100}
          className="border rounded px-3 py-2 w-full"
        />
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

export default RegionForm;