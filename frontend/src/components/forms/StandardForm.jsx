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
        <form onSubmit={handleSubmit} className="space-y-5"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">{initialData ? "Edit standard" : "Add a standard"}</h2></div>

            <div>
                <label className="block text-sm font-medium mb-1">Function</label>
                <select name="functionId" value={formData.functionId} onChange={handleChange} required className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" >
                    <option value="">Select a Function</option>
                    {sortedFunctions.map((f) => (
                        <option key={f.functionId} value={f.functionId}>{f.functionNumber} - {f.functionTitle}</option>
                    ))}
                </select>
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Component</label>
                <select name="componentId" value={formData.componentId} onChange={handleChange} required className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" >
                    <option value="">Select a Component</option>
                    {sortedComponents.map((c) => (
                        <option key={c.componentId} value={c.componentId}>{c.componentNumber} - {c.componentName}</option>
                    ))}
                </select>
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Standard No.</label>
                <input type="text" name="standardNumber" value={formData.standardNumber} onChange={handleChange} required maxLength={10} className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Standard Title</label>
                <input type="text" name="standardTitle" value={formData.standardTitle} onChange={handleChange} required className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Standard Summary</label>
                <textarea name="standardSummary" value={formData.standardSummary} onChange={handleChange} required rows={4} className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">{initialData ? "Save changes" : "Add standard"}</button><button type="button" className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] hover:bg-slate-100" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    )
}

export default StandardForm;
