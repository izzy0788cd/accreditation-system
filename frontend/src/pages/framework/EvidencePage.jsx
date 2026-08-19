import { useState, useEffect } from "react";
import { getAll, create, update, patchApplicability, remove } from "../../api/api";
import { Link } from "react-router-dom";
import EvidenceForm from "../../components/forms/EvidenceForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function EvidencePage() {
    const [evidence, setEvidence] = useState([]);
    const [editingEvidence, setEditingEvidence] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [successMessage, setSuccessMessage] = useState(null);

    const loadData = async () => {
        try {
            setLoading(true);
            const res = await getAll("evidence");
            setEvidence(res.data);
            setError(null);
        } catch (err) {
            setError("Failed to load Evidence.");
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadData();
    }, []);
    
    const handleAddClick = () => {
        setEditingEvidence(null);
        setShowForm(true);
    };

    const handleEditClick = (evidence) => {
        setEditingEvidence(evidence);
        setShowForm(true);
    };

    const handleCancel = () => {
        setEditingEvidence(null);
        setShowForm(false);
    };

    const handleSubmit = async (formData) => {
        try {
            if (editingEvidence) {
                await update("evidence", editingEvidence.evidenceId, formData);
                setShowForm(false);
                setEditingEvidence(null);
            } else {
                await create("evidence", formData);
                setSuccessMessage(`"${formData.evidenceSummary}" added.`);
                setTimeout(() => setSuccessMessage(null), 2000);
            }
            loadData();
        } catch (err) {
            setError("Failed to save Evidence.");
            console.error(err);
        }
    };

    const handleDeleteClick = (evidence) => {
        setDeleteTarget(evidence);
    };

    const handleConfirmDelete = async () => {
        try {
            await remove("evidence", deleteTarget.evidenceId);
            setDeleteTarget(null);
            loadData();
        } catch (err) {
            setError("Failed to delete, remove evidence");
            console.error(err);
        }
    };

    const handleToggleApplicability = async (evidence) => {
        try {
            await patchApplicability("evidence", evidence.evidenceId, !evidence.isApplicable);
            loadData();
        } catch (err) {
            setError("Failed to change applicability.");
            console.error(err);
        }
    };

    const sortedEvidence = [ ...evidence].sort((a, b) => {
        const complianceCompare = a.complianceNumber.localeCompare(b.complianceNumber, undefined, { numeric: true });
        if (complianceCompare !== 0) return complianceCompare;

        return a.evidenceNumber.localeCompare(b.evidenceNumber, undefined, { numeric: true });
    });


    return (
        <div>
            <div className="flex items-center justify-between mb-4">
                <h1 className="text-2xl font-bold">
                    Evidence
                </h1>
                <button onClick={handleAddClick} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    + Add Evidence
                </button>
            </div>

            {error && <p className="text-red-600 mb-4">{error}</p>}

            {loading ? (
                <p>Loading...</p>
            ) : (
                <table className="w-full border-collapse">
                    <thead>
                        <tr className="border-b text-left">
                            <th className="p-2">Compliance</th>
                            <th className="p-2">No.</th>
                            <th className="p-2">Evidence</th>
                            <th className="p-2">Applicable</th>
                            <th className="p-2">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {sortedEvidence.map((ev) => (
                            <tr key={ev.evidenceId} className="border-b">
                                <td className="p-2"><Link to={`/framework/compliance/${ev.complianceId}`} className="text-blue-600 hover:underline">{ev.complianceNumber}</Link></td>
                                <td className="p-2 text-center">{ev.evidenceNumber}</td>
                                <td className="p-2 text-justify whitespace-pre-line">{ev.evidenceSummary}</td>
                                <td className="p-2">
                                    <button onClick={() => handleToggleApplicability(ev)}
                                        className={`px-3 py-1 rounded text-sm font-medium ${
                                            ev.isApplicable 
                                            ? "bg-green-100 text-green-700 hover:bg-green-200"
                                            : "bg-gray-200 text-gray-600 hover:bg-gray-300"
                                        }`}>
                                        {ev.isApplicable ? "Applicable" : "Not Applicable"}
                                    </button>
                                </td>
                                <td className="p-2 space-x-2">
                                    <div className="flex gap-2">
                                        <button onClick={() => handleEditClick(ev)} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 w-20 mb-2">
                                            Edit
                                        </button>
                                        <button onClick={() => handleDeleteClick(ev)} className="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 w-20 mb-2">
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
                <EvidenceForm
                    initialData={editingEvidence}
                    onSubmit={handleSubmit}
                    onCancel={handleCancel}
                />
            </FormModal>

            <ConfirmDialog
                open={!!deleteTarget}
                title={"Delete Evidence"}
                message={`Are you sure you want to delete "${deleteTarget?.evidenceNumber}"?`}
                onConfirm={handleConfirmDelete}
                onCancel={() => setDeleteTarget(null)}
            />            
        </div>
    );
}

export default EvidencePage;