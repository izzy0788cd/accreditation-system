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
        <form onSubmit={handleSubmit} className="space-y-5"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Framework</p><h2 className="mt-1 text-xl font-bold text-[#143c42]">{initialData ? "Edit component" : "Add a component"}</h2></div>
        <div>
            <label className="mb-1.5 block text-sm font-semibold text-[#284e53]">Number</label><input type="text" name="componentNumber" value={formData.componentNumber} onChange={handleChange} required max={10} className="w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100"/>
        </div>
        <div>
            <label className="mb-1.5 block text-sm font-semibold text-[#284e53]">Name</label><input type="text" name="componentName" value={formData.componentName} onChange={handleChange} required maxLength={100} className="w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100" />
        </div>

        <div>
            <label className="mb-1.5 block text-sm font-semibold text-[#284e53]">Summary</label><textarea name="componentSummary" value={formData.componentSummary} onChange={handleChange} className="w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100" rows={3} />
        </div>

        <div className="flex gap-2">
            <button type="submit" className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#05635f]" >{initialData ? "Save changes" : "Add component"}</button><button type="button" onClick={onCancel} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#527076] hover:bg-slate-100" >Cancel</button>
        </div>
        </form>
    );
}

export default ComponentForm;
