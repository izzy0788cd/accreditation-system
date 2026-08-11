import { useState, useEffect } from "react";
import { getAll } from "../../api/api";

function CriterionForm({ initialData, onSubmit, onCancel }) {
    const [formData, setFormData] = useState({
        standardId: "",
        criterionNumber: "",
        criterionTitle: "",
    });

    const [standards, setStandards] = useState([]);

    useEffect(() => {
        const loadStandards = async () => {
            try {
                const res = await getAll("standards");
                setStandards(res.data);
            } catch (err) {
                console.error("Failed to load Standards.", err);
            }
        };
        loadStandards();
    }, []);

    useEffect(() => {
        if (initialData) {
            setFormData({
                standardId: initialData.standardId,
                criterionNumber: initialData.criterionNumber,
                criterionTitle: initialData.criterionTitle,
            });
        } else {
            setFormData({
                standardId: "",
                criterionNumber: "",
                criterionTitle: ""});
        }
    }, [initialData]);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value});
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit({
            ...formData,
            standardId: Number(formData.standardId),
        });
    };

    return (
        <form onSubmit={handleSubmit} className="mb-8 space-y-3 border p-4 rounded">
            <h2 className="text-lg font-semibold">{initialData ? "Edit Criterion" : "Add Criterion"}</h2>

            <div>
                <label className="block text-sm font-medium mb-1">Standard</label>
                <select name="standardId" value={formData.standardId} onChange={handleChange} required className="border rounded px-3 py-2 w-full" >
                    <option value="">Select a Standard</option>
                    {standards.map((s) => (
                        <option key={s.standardId} value={s.standardId}>{s.standardNumber} - {s.standardTitle}</option>
                    ))}
                </select>
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Number</label>
                <input type="text" name="criterionNumber" value={formData.criterionNumber} onChange={handleChange} required maxLength={10} className="border rounded px-3 py-2 w-full" />
            </div>

            <div>
                <label className="block text-sm font-medium mb-1">Title</label>
                <input type="text" name="criterionTitle" value={formData.criterionTitle} onChange={handleChange} required maxLength={500} className="border rounded px-3 py-2 w-full" />
            </div>

            <div className="flex gap-2">
                <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">{initialData ? "Update" : "Add"}</button>
                <button type="button" className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" onClick={onCancel}>Cancel</button>
            </div>
        </form>
    );
}

export default CriterionForm;