import { useState, useEffect } from "react";
import { getAll, create, update, patchApplicability, remove } from "../../api/api"
import { Link } from "react-router-dom";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import ComplianceForm from "../../components/forms/ComplianceForm";
import { groupBy } from "../../utils/groupBy";

function CompliancePage() {
    const [compliance, setCompliance] = useState([]);
    const [editingCompliance, setEditingCompliance] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [, setSuccessMessage] = useState(null);

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
    const complianceByCriterion = groupBy(sortedCompliance, (item) => item.criterionNumber);

    return (
        <div>
            <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Framework layer</p><h2 className="mt-1 text-2xl font-bold tracking-tight text-[#143c42]">
                    Compliance
                </h2></div>
                <button onClick={handleAddClick} className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f]">
                    + Add Compliance
                </button>
            </div>

            {error && <p className="text-red-600 mb-4">{error}</p>}

            {loading ? (
                <p>Loading...</p>
            ) : (
                <div className="overflow-x-auto rounded-xl border border-[#e2ecea] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[820px] text-sm"><thead className="border-b border-[#dce9e7] bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]"><tr className="text-left">
                            <th className="p-2">Criteria</th>
                            <th className="p-2">No.</th>
                            <th className="p-2">Compliance</th>
                            <th className="p-2">Applicable</th>
                            <th className="p-2 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-[#e7efed]">
                        {complianceByCriterion.flatMap((group) => group.map((c, index) => (
                            <tr key={c.complianceId} className={`hover:bg-[#f5fbfa] ${index === 0 ? "border-t-2 border-[#b9d6d1]" : ""}`}>
                                {index === 0 && <td rowSpan={group.length} className="border-r border-[#e7efed] bg-[#f5faf9] p-3 align-top font-semibold"><Link to={`/framework/criteria/${c.criterionId}`} className="text-[#087c77] hover:underline">{c.criterionNumber}</Link></td>}
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
                                <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap">
                                        <button onClick={() => handleEditClick(c)} className="rounded-md border border-[#b9d6d1] px-3 py-1.5 text-xs font-semibold text-[#087c77] hover:bg-teal-50">
                                        Edit
                                        </button>
                                        <button onClick={() => handleDeleteClick(c)} className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50">
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
