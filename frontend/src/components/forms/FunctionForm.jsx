import { useState, useEffect } from "react";

function FunctionForm ({ initialData, onSubmit, onCancel }) {
    const [formData, setFormData] = useState({ functionNumber: "", functionTitle: "", functionSummary: "", });

    useEffect(() => {
        if (initialData) {
            setFormData({
                functionNumber: initialData.functionNumber,
                functionTitle: initialData.functionTitle,
                functionSummary: initialData.functionSummary || "",
            });
        } else {
            setFormData({ functionNumber: "", functionTitle: "", functionSummary: "" });
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
            <h2 className="text-lg font-semibold">{initialData ? "Edit Function" : "Add Function"}</h2>
            <div>
                <label className="block text-sm font-medium mb-1">Number</label>
                <input type="text" name="functionNumber" value={formData.functionNumber} onChange={handleChange} required maxLength={10} className="border rounded px-3 py-2 w-full"></input>
            </div>
            <div>
            <label className="block text-sm font-medium mb-1">Title</label>
                <input type="text" name="functionTitle" value={formData.functionTitle} onChange={handleChange} required maxLength={100} className="border rounded px-3 py-2 w-full" />
            </div>
            <div>
                <label className="block text-sm font-medium mb-1">Summary</label>
                <textarea name="functionSummary" value={formData.functionSummary} onChange={handleChange} className="border rounded px-3 py-2 w-full" rows={3} />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700" >{initialData ? "Update" : "Add"}</button>
                <button type="button" onClick={onCancel} className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" >Cancel</button>
            </div>
        </form>
    )
}

export default FunctionForm;