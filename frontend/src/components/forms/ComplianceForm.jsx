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
    });

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
        <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
            <h2 className="text-lg font-semibold">{initialData ? "Edit Compliance" : "Add Compliance"}</h2>

            {!lockedCriterionId && (
                <div>
                    <label className="block text-sm font-medium mb-1">Criterion</label>
                    <select name="criterionId" value={formData.criterionId} onChange={handleChange} required className="border rounded px-3 py-2 w-full">
                        <option value="">Select Compliance Criterion</option>
                        {sortedCriteria.map((cr) => (
                            <option key={cr.criterionId} value={cr.criterionId}>{cr.criterionNumber}</option>
                        ))}
                    </select>
                </div>
            )}

            <div>
                <label className="block text-sm font-medium mb-1">Number</label>
                <input ref={numberInputRef} type="text" name="complianceNumber" value={formData.complianceNumber} onChange={handleChange} required className="border rounded px-3 py-2 w-full" />
            </div>
                
            <div>
                <label className="block text-sm font-medium mb-1">Compliance</label>
                <textarea name="complianceSummary" value={formData.complianceSummary} onChange={handleChange} required className="border rounded px-3 py-2 w-full h-auto" />
            </div>
            
            <div className="flex gap-2">
                <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">{initialData ? "Update" : "Add"}</button>
                <button type="button" className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    );
}

export default ComplianceForm;