import { useState, useEffect } from "react";
import { getAll, create, update, patchApplicability, remove } from "../../api/api";
import { Link } from "react-router-dom";
import EvidenceForm from "../../components/forms/EvidenceForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import { groupBy } from "../../utils/groupBy";

function EvidencePage() {
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
    const evidenceByCompliance = groupBy(sortedEvidence, (item) => item.complianceNumber);


    return (
        <div>
            <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Framework layer</p><h2 className="mt-1 text-2xl font-bold tracking-tight text-[#143c42]">
                    Evidence
                </h2></div>
                <button onClick={handleAddClick} className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f]">
                    + Add Evidence
                </button>
            </div>

            {error && <p className="text-red-600 mb-4">{error}</p>}

            {loading ? (
                <p>Loading...</p>
            ) : (
                <div className="overflow-x-auto rounded-xl border border-[#e2ecea] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[820px] text-sm"><thead className="border-b border-[#dce9e7] bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]"><tr className="text-left">
                            <th className="p-2">Compliance</th>
                            <th className="p-2">No.</th>
                            <th className="p-2">Evidence</th>
                            <th className="p-2">Applicable</th>
                            <th className="p-2 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-[#e7efed]">
                        {evidenceByCompliance.flatMap((group) => group.map((ev, index) => (
                            <tr key={ev.evidenceId} className={`hover:bg-[#f5fbfa] ${index === 0 ? "border-t-2 border-[#b9d6d1]" : ""}`}>
                                {index === 0 && <td rowSpan={group.length} className="border-r border-[#e7efed] bg-[#f5faf9] p-3 align-top font-semibold"><Link to={`/framework/compliance/${ev.complianceId}`} className="text-[#087c77] hover:underline">{ev.complianceNumber}</Link></td>}
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
                                <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap">
                                        <button onClick={() => handleEditClick(ev)} className="rounded-md border border-[#b9d6d1] px-3 py-1.5 text-xs font-semibold text-[#087c77] hover:bg-teal-50">
                                            Edit
                                        </button>
                                        <button onClick={() => handleDeleteClick(ev)} className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50">
                                            Delete
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))) }
                    </tbody>
                </table></div>
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
