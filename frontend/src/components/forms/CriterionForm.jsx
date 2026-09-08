import { useState, useEffect, useRef } from "react";
import { getAll } from "../../api/api";

function CriterionForm({ initialData, onSubmit, onCancel, lockedStandardId }) {
    const [formData, setFormData] = useState({
        standardId: lockedStandardId ?? "",
        criterionNumber: "",
        criterionTitle: "",
    });

    const [standards, setStandards] = useState([]);
    const numberInputRef = useRef(null);

    useEffect(() => {
        if (lockedStandardId) return;
        const loadStandards = async () => {
            try {
                const res = await getAll("standards");
                setStandards(res.data);
            } catch (err) {
                console.error("Failed to load Standards.", err);
            }
        };
        loadStandards();
    }, [lockedStandardId]);

    useEffect(() => {
        if (initialData) {
            setFormData({
                standardId: initialData.standardId,
                criterionNumber: initialData.criterionNumber,
                criterionTitle: initialData.criterionTitle,
            });
        } else {
            setFormData({
                standardId: lockedStandardId ?? "",
                criterionNumber: "",
                criterionTitle: ""});
        }
    }, [initialData, lockedStandardId]);

    useEffect(() => {
        if (numberInputRef.current) {
            numberInputRef.current.focus();
        }
    })

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value});
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit({
            ...formData,
            standardId: Number(formData.standardId),
        });
        setFormData({
            standardId: lockedStandardId ?? "",
            criterionNumber: "",
            criterionTitle: "",
        });
    };

    return (
        <form onSubmit={handleSubmit} className="space-y-5"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Framework</p><h2 className="mt-1 text-xl font-bold text-[#143c42]">{initialData ? "Edit criterion" : "Add a criterion"}</h2></div>

            {!lockedStandardId && (
                <div>
                    <label className="block text-sm font-medium mb-1">Standard</label>
                    <select name="standardId" value={formData.standardId} onChange={handleChange} required className="w-full rounded-lg border border-[#b9d6d1] bg-white px-3 py-2.5 text-sm outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100" >
                        <option value="">Select a Standard</option>
                        {standards.map((s) => (
                            <option key={s.standardId} value={s.standardId}>{s.standardNumber} - {s.standardTitle}</option>
                        ))}
                    </select>
                </div>
            )}

            <div>
                <label className="block text-sm font-medium mb-1">Number</label>
                <input ref={numberInputRef} type="text" name="criterionNumber" value={formData.criterionNumber} onChange={handleChange} required maxLength={10} className="w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Title</label>
                <input type="text" name="criterionTitle" value={formData.criterionTitle} onChange={handleChange} required maxLength={500} className="w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100" />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#05635f]">{initialData ? "Save changes" : "Add criterion"}</button><button type="button" className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#527076] hover:bg-slate-100" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    );
}

export default CriterionForm;
