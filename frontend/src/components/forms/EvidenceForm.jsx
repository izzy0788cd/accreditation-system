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
    });

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
        <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
            <h2 className="text-lg font-semibold">{initialData ? "Edit Evidence" : "Add Evidence"}</h2>

            {!lockedComplianceId && (
                <div>
                    <label className="block text-sm font-medium mb-1">Compliance</label>
                    <select name="complianceId" value={formData.complianceId} onChange={handleChange} required className="border rounded px-3 py-2 w-full">
                        <option value="">Select Compliance</option>
                        {sortedCompliances.map((co) => (
                            <option key={co.complianceId} value={co.complianceId}>{co.complianceNumber}</option>
                        ))}
                    </select>
                </div>
            )}

            <div>
                <label className="block text-sm font-medium mb-1">Number</label>
                <input ref={numberInputRef} type="text" name="evidenceNumber" value={formData.evidenceNumber} onChange={handleChange} required className="border rounded px-3 py-2 w-full" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Evidence</label>
                <textarea name="evidenceSummary" value={formData.evidenceSummary} onChange={handleChange} required className="border rounded px-3 py-2 w-full" />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">{initialData ? "Update" : "Add"}</button>
                <button type="button" className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    );
}

export default EvidenceForm;