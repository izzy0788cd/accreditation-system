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
        <form onSubmit={handleSubmit} className="space-y-5"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">{initialData ? "Edit function" : "Add a function"}</h2></div>
            <div>
                <label className="mb-1.5 block text-sm font-semibold text-[#153a70]">Number</label><input type="text" name="functionNumber" value={formData.functionNumber} onChange={handleChange} required maxLength={10} className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]"></input>
            </div>
            <div>
            <label className="mb-1.5 block text-sm font-semibold text-[#153a70]">Title</label><input type="text" name="functionTitle" value={formData.functionTitle} onChange={handleChange} required maxLength={100} className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>
            <div>
                <label className="mb-1.5 block text-sm font-semibold text-[#153a70]">Summary</label><textarea name="functionSummary" value={formData.functionSummary} onChange={handleChange} className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" rows={3} />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]" >{initialData ? "Save changes" : "Add function"}</button><button type="button" onClick={onCancel} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] hover:bg-slate-100" >Cancel</button>
            </div>
        </form>
    )
}

export default FunctionForm;
