import { useState, useEffect, useRef } from "react";
import { getAll } from "../../api/api";

function EvidenceForm({ initialData, onSubmit, onCancel, lockedComplianceId }) {
    const [formData, setFormData] = useState({
        complianceId: lockedComplianceId ?? "",
        evidenceNumber: "",
        evidenceSummary: "",
    });

    const [compliances, setCompliances] = useState([]);
    const numberInputRef = useRef(null);

    useEffect(() => {
        if (lockedComplianceId) return;
        const loadCompliances = async () => {
            try {
                const res = await getAll("compliances");
                setCompliances(res.data);
            } catch (err) {
                console.error("Failed to load Compliances.", err)
            }
        };
        loadCompliances();
    }, [lockedComplianceId]);

    useEffect(() => {
        if (initialData) {
            setFormData({
                complianceId: initialData.complianceId,
                evidenceNumber: initialData.evidenceNumber,
                evidenceSummary: initialData.evidenceSummary,
            });
        } else {
            setFormData({
                complianceId: lockedComplianceId ?? "",
                evidenceNumber: "",
                evidenceSummary: "",
            });
        }
    }, [initialData, lockedComplianceId]);

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
            complianceId: Number(formData.complianceId),
        });
        setFormData({
                complianceId: lockedComplianceId ?? "",
                evidenceNumber: "",
                evidenceSummary: "",
            });
    };

    const sortedCompliances = [ ...compliances].sort((a, b) => 
        a.complianceNumber.localeCompare(b.complianceNumber, undefined, { numeric: true })
    );

    return (
        <form onSubmit={handleSubmit} className="space-y-5"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">{initialData ? "Edit evidence" : "Add evidence"}</h2></div>

            {!lockedComplianceId && (
                <div>
                    <label className="block text-sm font-medium mb-1">Compliance</label>
                    <select name="complianceId" value={formData.complianceId} onChange={handleChange} required className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]">
                        <option value="">Select Compliance</option>
                        {sortedCompliances.map((co) => (
                            <option key={co.complianceId} value={co.complianceId}>{co.complianceNumber}</option>
                        ))}
                    </select>
                </div>
            )}

            <div>
                <label className="block text-sm font-medium mb-1">Number</label>
                <input ref={numberInputRef} type="text" name="evidenceNumber" value={formData.evidenceNumber} onChange={handleChange} required className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Evidence</label>
                <textarea name="evidenceSummary" value={formData.evidenceSummary} onChange={handleChange} required rows={4} className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">{initialData ? "Save changes" : "Add evidence"}</button><button type="button" className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] hover:bg-slate-100" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    );
}

export default EvidenceForm;
