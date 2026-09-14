import { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { getOne, getAll, create, update, remove, patchApplicability } from "../../api/api";
import ComplianceForm from "../../components/forms/ComplianceForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function CriterionDetailPage() {
    const { criterionId } = useParams();
    const [criterion, setCriterion] = useState(null);
    const [compliances, setCompliances] = useState([]);
    const [editingCompliance, setEditingCompliance] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [, setSuccessMessage] = useState(null);

    const loadData = async () => {
        try {
            setLoading(true);
            const [criteriaRes, complianceRes] = await Promise.all([
                getOne("criteria", criterionId),
                getAll("compliances"),
            ]);
            setCriterion(criteriaRes.data);
            setCompliances(
                complianceRes.data.filter((co) => co.criterionId === Number(criterionId))
            );
            setError(null);
        } catch (err) {
            setError("Failed to load Criteria.");
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadData();
    }, [criterionId]);

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
                await create("compliances", { ...formData, criterionId : Number(criterionId) });
                setSuccessMessage(`"${formData.complianceNumber}" added.`);
                setTimeout(() => setSuccessMessage(null), 2000);
            }
            loadData();
        } catch (err) {
            setError("Failed to save Compliance");
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
            setError("Failed to delete Compliance.")
            console.error(err);
        }
    };

    const handleToggleApplicability = async (compliance) => {
        try {
            await patchApplicability("compliances", compliance.complianceId, !compliance.isApplicable);
            loadData();
        } catch (err) {
            setError("Failed to toggle applicability.")
            console.error(err);
        }
    };

    const sortedCompliance = [ ...compliances].sort((a, b) => 
        a.complianceNumber.localeCompare(b.complianceNumber, undefined, { numeric: true })
    );

    if (loading) return <p>Loading...</p>
    if (!criterion) return <p>Criterion not found.</p>

    return (
        <div>
            <Link to="/framework/criteria" className="text-sm font-semibold text-[#16803a] hover:underline">
            ← Back to Criteria
            </Link>
            
            <div>
                <div className="mb-4 mt-3 flex flex-col gap-4 rounded-xl border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_100%)] px-6 py-5 sm:flex-row sm:items-center sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Criterion</p><h1 className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">
                        {criterion.criterionNumber} {criterion.criterionTitle}
                    </h1></div><button onClick={handleAddClick} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">
                        + Add Compliance
                    </button>
                </div>

                    {error && <p className="text-red-600 mb-4">{error}</p>}

                    {loading ? (
                        <p>Loading...</p>
                    ) : (
                        <div className="overflow-x-auto rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[700px] text-sm">
                            <thead>
                                <tr className="border-b text-left">
                                    <th className="p-2">No.</th>
                                    <th className="p-2">Compliance</th>
                                    <th className="p-2">Applicable</th>
                                    <th className="p-2 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {sortedCompliance.map((c) => (
                                    <tr key={c.complianceId} className="border-b">
                                        <td className="p-2 text-left font-semibold"><Link to={`/framework/compliance/${c.complianceId}`} className="text-blue-600 hover:underline">{c.complianceNumber}</Link></td>
                                        <td className="p-2 text-justify whitespace-pre-line">{c.complianceSummary}</td>
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
                                        <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap"><button onClick={() => handleEditClick(c)} className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]">
                                                    Edit
                                                </button>
                                                <button onClick={() => handleDeleteClick(c)} className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50">
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
                        <ComplianceForm
                            initialData={editingCompliance}
                            onSubmit={handleSubmit}
                            onCancel={handleCancel}
                            lockedCriterionId={editingCompliance ? undefined : Number(criterionId)}
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
        </div>
    );
}

export default CriterionDetailPage;
