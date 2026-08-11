import { useState, useEffect } from "react";

function ComponentForm ({ initialData, onSubmit, onCancel }) {
    const [formData, setFormData] = useState({ componentNumber: "", componentName: "", componentSummary: "" });

    useEffect(() => {
        if (initialData) {
            setFormData({
                componentNumber: initialData.componentNumber,
                componentName: initialData.componentName,
                componentSummary: initialData.componentSummary || "",
            });
        } else {
            setFormData({ componentNumber: "", componentName: "", componentSummary: "" });
        }
    }, [initialData]);
    
    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit(formData);
    }

    return (
        <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
            <h2 className="text-lg font-semibold">{initialData ? "Edit Component" : "Add Component"}</h2>
        <div>
            <label className="block text-sm font-medium mb-1">Number</label>
                <input type="text" name="componentNumber" value={formData.componentNumber} onChange={handleChange} required max={10} className="border rounded px-3 py-2 w-full"/>
        </div>
        <div>
            <label className="block text-sm font-medium mb-1">Name</label>
                <input type="text" name="componentName" value={formData.componentName} onChange={handleChange} required maxLength={100} className="border rounded px-3 py-2 w-full" />
        </div>

        <div>
            <label className="block text-sm font-medium mb-1">Summary</label>
                <textarea name="componentSummary" value={formData.componentSummary} onChange={handleChange} className="border rounded px-3 py-2 w-full" rows={3} />
        </div>

        <div className="flex gap-2">
            <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700" >{initialData ? "Update" : "Add"}</button>
            <button type="button" onClick={onCancel} className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" >Cancel</button>
        </div>
        </form>
    );
}

export default ComponentForm;