import { useState, useEffect } from "react";
import { getAll, create, update, patchApplicability, remove } from "../../api/api"
import { Link } from "react-router-dom";
import CriterionForm from "../../components/forms/CriterionForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import ComplianceForm from "../../components/forms/ComplianceForm";

function CompliancePage() {
    const [compliance, setCompliance] = useState([]);
    const [editingCompliance, setEditingCompliance] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [successMessage, setSuccessMessage] = useState(null);

    const loadData = async () => {
        try {
            setLoading(true);
            const res = await getAll("compliances");
            setCompliance(res.data);
            setError(null);
        } catch (err) {
            setError("Failed to load Compliance.");
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadData();
    }, []);

    const handleAddClick = () => {
        setEditingCompliance(null);
        setShowForm(true);
    };

    const handleEditClick = (compliance) => {
        setEditingCompliance(compliance);
        setShowForm(true);
    };

    const handleCancel = () => {
        setEditingCompliance(null);
        setShowForm(false);
    };

    const handleSubmit = async (formData) => {
        try {
            if (editingCompliance) {
                await update("compliances", editingCompliance.complianceId, formData);
                setShowForm(false);
                setEditingCompliance(null);
            } else {
                await create("compliances", formData);
                setSuccessMessage(`"${formData.complianceSummary}" added.`);
                setTimeout(() => setSuccessMessage(null), 2000);
            }
            loadData();
        } catch (err) {
            setError("Failed to save Compliance.");
            console.error(err);
        }
    };

    const handleDeleteClick = (compliance) => {
        setDeleteTarget(compliance);
    };

    const handleConfirmDelete = async () => {
        try {
            await remove("compliances", deleteTarget.complianceId);
            setDeleteTarget(null);
            loadData();
        } catch (err) {
            setError("Failed to delete Compliance.");
            console.error(err);
        }
    };

    const handleToggleApplicability = async (compliance) => {
        try {
            await patchApplicability("compliances", compliance.complianceId, !compliance.isApplicable);
            loadData();
        } catch (err) {
            setError("Failed to change applicability.")
            console.error(err);
        }
    };

    const sortedCompliance = [ ...compliance].sort((a, b) => 
        a.complianceNumber.localeCompare(b.complianceNumber, undefined, { numeric: true })
    );

    return (
        <div>
            <div className="flex items-center justify-between mb-4">
                <h1 className="text-2xl font-bold">
                    Compliance
                </h1>
                <button onClick={handleAddClick} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    + Add Compliance
                </button>
            </div>

            {error && <p className="text-red-600 mb-4">{error}</p>}

            {loading ? (
                <p>Loading...</p>
            ) : (
                <table className="w-full border-collapse">
                    <thead>
                        <tr className="border-b text-left">
                            <th className="p-2">Criteria</th>
                            <th className="p-2">No.</th>
                            <th className="p-2">Compliance</th>
                            <th className="p-2">Applicable</th>
                            <th className="p-2">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {sortedCompliance.map((c) => (
                            <tr key={c.complianceId} className="border-b">
                                <td className="p-2"><Link to={`/framework/criteria/${c.criterionId}`} className="text-blue-600 hover:underline">{c.criterionNumber}</Link></td>
                                <td className="p-2 text-left font-semibold"><Link to={`/framework/compliance/${c.complianceId}`} className="text-blue-600 hover:underline">{c.complianceNumber}</Link></td>
                                <td className="p-2 whitespace-pre-line text-justify">{c.complianceSummary}</td>
                                <td className="p-2">
                                    <button onClick={() => handleToggleApplicability(c)}
                                        className={`px-3 py-1 rounded text-sm font-medium ${
                                            c.isApplicable 
                                            ? "bg-green-100 text-green-700 hover:bg-green-200"
                                            : "bg-gray-200 text-gray-600 hover:bg-gray-300"
                                        }`}>
                                        {c.isApplicable ? "Applicable" : "Not Applicable"}
                                    </button>
                                </td>
                                <td className="p-2 space-x-2">
                                    <div className="flex gap-2">
                                        <button onClick={() => handleEditClick(c)} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 w-20 mb-2">
                                        Edit
                                        </button>
                                        <button onClick={() => handleDeleteClick(c)} className="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 w-20 mb-2">
                                        Delete
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}

            <FormModal open={showForm} onClose={handleCancel}>
                <ComplianceForm
                    initialData={editingCompliance}
                    onSubmit={handleSubmit}
                    onCancel={handleCancel}
                />
            </FormModal>

            <ConfirmDialog
                open={!!deleteTarget}
                title={"Delete Compliance"}
                message={`Are you sure you want to delete "${deleteTarget?.complianceNumber}"?`}
                onConfirm={handleConfirmDelete}
                onCancel={() => setDeleteTarget(null)}
            />
        </div>
    );
}

export default CompliancePage;