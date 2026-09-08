import { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { getOne, getAll, create, update, remove, patchApplicability } from "../../api/api";
import EvidenceForm from "../../components/forms/EvidenceForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function ComplianceDetailPage() {
    const { complianceId } = useParams();
    const [compliance, setCompliance] = useState(null);
    const [evidence, setEvidence] = useState([]);
    const [editingEvidence, setEditingEvidence] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [, setSuccessMessage] = useState(null);

    const loadData = async () => {
        try {
            setLoading(true);
            const [complianceRes, evidenceRes] = await Promise.all([
                getOne("compliances", complianceId),
                getAll("evidence"),
            ]);
            setCompliance(complianceRes.data);
            setEvidence(
                evidenceRes.data.filter((ev) => ev.complianceId === Number(complianceId))
            );
        } catch (err) {
            setError("Failed to load Compliances");
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadData();
    }, [complianceId]);

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
                await create("evidence", { ...formData, complianceId: Number(complianceId)});
                setSuccessMessage(`"${formData.evidenceNumber}" added.`);
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
            setError("Failed to delete, remove Evidence.");
            console.error(err);
        }
    };

    const handleToggleApplicability = async (evidence) => {
        try {
            await patchApplicability("evidence", evidence.evidenceId, !evidence.isApplicable);
            loadData();
        } catch (err) {
            setError("Failed to toggle applicability");
            console.error(err);
        }
    };

    const sortedEvidence = [...evidence].sort((a, b) =>
        a.evidenceNumber.localeCompare(b.evidenceNumber, undefined, { numeric: true })
    );

    if (loading) return <p>Loading...</p>
    if (!compliance) return <p>Compliance requirement not found.</p>

    return (
        <div>
            <Link to="/framework/compliance" className="text-sm font-semibold text-[#087c77] hover:underline">
            ← Back to Compliance
            </Link>
            
                <div className="mb-4 mt-3 rounded-xl border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_100%)] px-6 py-5"><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Compliance requirement</p><h1 className="mt-1 text-2xl font-bold tracking-tight text-[#143c42] whitespace-pre-line">
                        {compliance.complianceNumber} - {compliance.complianceSummary}
                    </h1>
                </div>

                {error && <p className="text-red-600 mb-4">{error}</p>}

                <div className="mb-4 flex items-center justify-between"><h2 className="text-xl font-bold text-[#143c42]">Evidence</h2><button onClick={handleAddClick} className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#05635f]">
                        + Add Evidence
                    </button>
                </div>

                {loading ? (
                    <p>Loading...</p>
                ) : (
                    <div className="overflow-x-auto rounded-xl border border-[#e2ecea] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[700px] text-sm">
                        <thead>
                            <tr className="border-b text-left">
                                <th className="p-2">No.</th>
                                <th className="p-2">Evidence</th>
                                <th className="p-2">Applicable</th>
                                <th className="p-2 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {sortedEvidence.map((ev) => (
                                <tr key={ev.evidenceId} className="border-b">
                                    <td className="p-2 text-left font-semibold">{ev.evidenceNumber}</td>
                                    <td className="p-2 whitespace-pre-line text-justify">{ev.evidenceSummary}</td>
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
                                    <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap"><button onClick={() => handleEditClick(ev)} className="rounded-md border border-[#b9d6d1] px-3 py-1.5 text-xs font-semibold text-[#087c77] hover:bg-teal-50">
                                                Edit
                                            </button>
                                            <button onClick={() => handleDeleteClick(ev)} className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50">
                                                Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table></div>
                )}

                <FormModal open={showForm} onClose={handleCancel}>
                    <EvidenceForm
                        initialData={editingEvidence}
                        onSubmit={handleSubmit}
                        onCancel={handleCancel}
                        lockedComplianceId={editingEvidence ? undefined : Number(complianceId)}
                    />
                </FormModal>

                <ConfirmDialog
                    open={!!deleteTarget}
                    title={"Delete Compliance"}
                    message={`Are you sure you want to delete "${deleteTarget?.evidenceNumber}"?`}
                    onConfirm={handleConfirmDelete}
                    onCancel={() => setDeleteTarget(null)}
                />
        </div>
    );
}

export default ComplianceDetailPage;
