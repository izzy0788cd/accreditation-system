import { useState, useEffect } from "react";
import { getAll } from "../../api/api";

function StandardForm ({ initialData, onSubmit, onCancel }) {
    const [formData, setFormData] = useState({
        functionId: "",
        componentId: "",
        standardNumber: "",
        standardTitle: "",
        standardSummary: "",
    });

    const [functions, setFunctions] = useState([]);
    const [components, setComponents] = useState([]);

    useEffect(() => {
        const loadOptions = async () => {
            try {
                const [functionsRes, componentsRes] = await Promise.all([
                    getAll("functions"),
                    getAll("components"),
                ]);
                setFunctions(functionsRes.data);
                setComponents(componentsRes.data);
            } catch (err) {
                console.error("Failed to load Functions/Components", err);
            }
        };
        loadOptions();
    }, []);

    useEffect(() => {
        if (initialData) {
            setFormData({
                functionId: initialData.functionId,
                componentId: initialData.componentId,
                standardNumber: initialData.standardNumber,
                standardTitle: initialData.standardTitle,
                standardSummary: initialData.standardSummary,
            });
        } else {
            setFormData({
                functionId: "",
                componentId: "",
                standardNumber: "",
                standardTitle: "",
                standardSummary: "",
            });
        }
    }, [initialData]);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit({
            ...formData,
            functionId: Number(formData.functionId),
            componentId: Number(formData.componentId),
        });
    };

    const sortedFunctions = [ ...functions].sort((a, b) => 
        a.functionNumber.localeCompare(b.functionNumber, undefined, { numeric: true })
    );

    const sortedComponents = [ ...components].sort((a, b) => 
        a.componentNumber.localeCompare(b.componentNumber, undefined, { numeric: true })
    );

    return (
        <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
            <h2 className="text-lg font-semibold">{initialData ? "Edit Standard" : "Add Standard"}</h2>

            <div>
                <label className="block text-sm font-medium mb-1">Function</label>
                <select name="functionId" value={formData.functionId} onChange={handleChange} required className="border rounded px-3 py-2 w-full" >
                    <option value="">Select a Function</option>
                    {sortedFunctions.map((f) => (
                        <option key={f.functionId} value={f.functionId}>{f.functionNumber} - {f.functionTitle}</option>
                    ))}
                </select>
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Component</label>
                <select name="componentId" value={formData.componentId} onChange={handleChange} required className="border rounded px-3 py-2 w-full" >
                    <option value="">Select a Component</option>
                    {sortedComponents.map((c) => (
                        <option key={c.componentId} value={c.componentId}>{c.componentNumber} - {c.componentName}</option>
                    ))}
                </select>
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Standard No.</label>
                <input type="text" name="standardNumber" value={formData.standardNumber} onChange={handleChange} required maxLength={10} className="border rounded px-3 py-2 w-full" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Standard Title</label>
                <input typeof="text" name="standardTitle" value={formData.standardTitle} onChange={handleChange} required className="border rounded px-3 py-2 w-full" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Standard Summary</label>
                <textarea name="standardSummary" value={formData.standardSummary} onChange={handleChange} required className="border rounded px-3 py-2 w-full" />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">{initialData ? "Update" : "Add"}</button>
                <button type="button" className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    )
}

export default StandardForm;