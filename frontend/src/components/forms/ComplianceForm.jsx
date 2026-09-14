import { useState, useEffect, useRef } from "react";
import { getAll } from "../../api/api";

function ComplianceForm({ initialData, onSubmit, onCancel, lockedCriterionId }) {
    const [formData, setFormData] = useState({
        criterionId: lockedCriterionId ?? "",
        complianceNumber: "",
        complianceSummary: "",
    });

    const [criteria, setCriteria] = useState([]);
    const numberInputRef = useRef(null);

    useEffect(() => {
        if (lockedCriterionId) return;
        const loadCriteria = async () => {
            try {
                const res = await getAll("criteria");
                setCriteria(res.data);
            } catch (err) {
                console.error("Failed to load Criteria", err)
            }
        };
        loadCriteria();
    }, [lockedCriterionId]);

    useEffect(() => {
        if (initialData) {
            setFormData({
                criterionId: initialData.criterionId,
                complianceNumber: initialData.complianceNumber,
                complianceSummary: initialData.complianceSummary,
            });
        } else {
            setFormData({
                criterionId: lockedCriterionId ?? "",
                complianceNumber: "",
                complianceSummary: "",
            });
        }
    }, [initialData, lockedCriterionId]);

    useEffect(() => {
        if (numberInputRef.current) {
            numberInputRef.current.focus();
        }
    }, []);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value});
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit({
            ...formData,
            criterionId: Number(formData.criterionId),
        });
        setFormData({
                criterionId: lockedCriterionId ?? "",
                complianceNumber: "",
                complianceSummary: "",
            });
    };

    const sortedCriteria = [ ...criteria].sort((a, b) => 
        a.criterionNumber.localeCompare(b.criterionNumber, undefined, { numeric: true })
    );

    return (
        <form onSubmit={handleSubmit} className="space-y-5"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">{initialData ? "Edit compliance" : "Add compliance"}</h2></div>

            {!lockedCriterionId && (
                <div>
                    <label className="block text-sm font-medium mb-1">Criterion</label>
                    <select name="criterionId" value={formData.criterionId} onChange={handleChange} required className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]">
                        <option value="">Select Compliance Criterion</option>
                        {sortedCriteria.map((cr) => (
                            <option key={cr.criterionId} value={cr.criterionId}>{cr.criterionNumber}</option>
                        ))}
                    </select>
                </div>
            )}

            <div>
                <label className="block text-sm font-medium mb-1">Number</label>
                <input ref={numberInputRef} type="text" name="complianceNumber" value={formData.complianceNumber} onChange={handleChange} required className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>
                
            <div>
                <label className="block text-sm font-medium mb-1">Compliance</label>
                <textarea name="complianceSummary" value={formData.complianceSummary} onChange={handleChange} required rows={4} className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>
            
            <div className="flex gap-2">
                <button type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">{initialData ? "Save changes" : "Add compliance"}</button><button type="button" className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] hover:bg-slate-100" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    );
}

export default ComplianceForm;
