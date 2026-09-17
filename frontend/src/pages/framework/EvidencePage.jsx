import { useState, useEffect } from "react";
import { getAll, create, update, patchApplicability, remove } from "../../api/api";
import { Link } from "react-router-dom";
import EvidenceForm from "../../components/forms/EvidenceForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import { groupBy } from "../../utils/groupBy";
import FrameworkFilters from "../../components/FrameworkFilters/FrameworkFilters";
import { useAuth } from "../../context/AuthContext";
import { canManageReferenceData } from "../../utils/access";

function EvidencePage() {
    const { auth } = useAuth();
    const canManage = canManageReferenceData(auth?.roleName);
    const canToggleApplicability = canManage || auth?.roleName === "Surveyor";
    const [evidence, setEvidence] = useState([]);
    const [compliances, setCompliances] = useState([]);
    const [criteria, setCriteria] = useState([]);
    const [editingEvidence, setEditingEvidence] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [, setSuccessMessage] = useState(null);
    const [search, setSearch] = useState("");
    const [complianceFilter, setComplianceFilter] = useState("");
    const [criterionFilter, setCriterionFilter] = useState("");
    const [standardFilter, setStandardFilter] = useState("");
    const [applicabilityFilter, setApplicabilityFilter] = useState("");

    const loadData = async () => {
        try {
            setLoading(true);
            const [evidenceRes, complianceRes, criteriaRes] = await Promise.all([getAll("evidence"), getAll("compliances"), getAll("criteria")]);
            setEvidence(evidenceRes.data);
            setCompliances(complianceRes.data);
            setCriteria(criteriaRes.data);
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

    useEffect(() => {
        setCriterionFilter("");
        setComplianceFilter("");
    }, [standardFilter]);

    useEffect(() => {
        setComplianceFilter("");
    }, [criterionFilter]);
    
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
            setEvidence((current) => current.map((item) => item.evidenceId === evidence.evidenceId ? { ...item, isApplicable: !item.isApplicable } : item));
        } catch (err) {
            setError("Failed to change applicability.");
            console.error(err);
        }
    };

    const complianceById = new Map(compliances.map((item) => [item.complianceId, item]));
    const criteriaById = new Map(criteria.map((item) => [item.criterionId, item]));
    const evidenceWithHierarchy = evidence.map((item) => {
        const complianceItem = complianceById.get(item.complianceId);
        const criterionItem = criteriaById.get(complianceItem?.criterionId);
        return {
            ...item,
            criterionId: complianceItem?.criterionId,
            criterionNumber: complianceItem?.criterionNumber,
            standardId: criterionItem?.standardId,
            standardNumber: criterionItem?.standardNumber,
            standardTitle: criterionItem?.standardTitle,
        };
    });
    const sortedEvidence = [ ...evidenceWithHierarchy].sort((a, b) => {
        const complianceCompare = a.complianceNumber.localeCompare(b.complianceNumber, undefined, { numeric: true });
        if (complianceCompare !== 0) return complianceCompare;

        return a.evidenceNumber.localeCompare(b.evidenceNumber, undefined, { numeric: true });
    });
    const standardOptions = [...new Map(criteria.map((item) => [item.standardId, { value: String(item.standardId), label: `${item.standardNumber} — ${item.standardTitle}` }])).values()]
        .sort((a, b) => a.label.localeCompare(b.label, undefined, { numeric: true }));
    const criterionOptions = [...new Map(evidenceWithHierarchy
        .filter((item) => !standardFilter || String(item.standardId) === standardFilter)
        .map((item) => [item.criterionId, { value: String(item.criterionId), label: item.criterionNumber }])).values()]
        .filter((option) => option.value !== "undefined")
        .sort((a, b) => a.label.localeCompare(b.label, undefined, { numeric: true }));
    const complianceOptions = [...new Map(evidenceWithHierarchy
        .filter((item) => (!standardFilter || String(item.standardId) === standardFilter)
            && (!criterionFilter || String(item.criterionId) === criterionFilter))
        .map((item) => [item.complianceId, { value: String(item.complianceId), label: item.complianceNumber }])).values()]
        .sort((a, b) => a.label.localeCompare(b.label, undefined, { numeric: true }));
    const normalizedSearch = search.trim().toLowerCase();
    const filteredEvidence = sortedEvidence.filter((item) => {
        const matchesSearch = [item.evidenceNumber, item.evidenceSummary, item.complianceNumber]
            .some((value) => value?.toLowerCase().includes(normalizedSearch));
        const matchesCompliance = !complianceFilter || String(item.complianceId) === complianceFilter;
        const matchesCriterion = !criterionFilter || String(item.criterionId) === criterionFilter;
        const matchesStandard = !standardFilter || String(item.standardId) === standardFilter;
        const matchesApplicability = !applicabilityFilter
            || (applicabilityFilter === "applicable" ? item.isApplicable : !item.isApplicable);
        return matchesSearch && matchesStandard && matchesCriterion && matchesCompliance && matchesApplicability;
    });
    const evidenceByCompliance = groupBy(filteredEvidence, (item) => item.complianceNumber);


    return (
        <div>
            <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework layer</p><h2 className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">
                    Evidence
                </h2></div>
                {canManage && <button onClick={handleAddClick} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]">
                    + Add Evidence
                </button>}
            </div>

            {error && <p className="text-red-600 mb-4">{error}</p>}

            {loading ? (
                <p>Loading...</p>
            ) : (
                <>
                <FrameworkFilters search={search} onSearchChange={setSearch} searchPlaceholder="Search number, evidence, or compliance" filters={[{ label: "Standard", value: standardFilter, onChange: setStandardFilter, options: standardOptions }, { label: "Criterion", value: criterionFilter, onChange: setCriterionFilter, options: criterionOptions }]} parentLabel="Compliance" parentValue={complianceFilter} onParentChange={setComplianceFilter} parentOptions={complianceOptions} applicability={applicabilityFilter} onApplicabilityChange={setApplicabilityFilter} resultCount={filteredEvidence.length} totalCount={evidence.length} />
                <div className="overflow-x-auto rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[820px] text-sm"><thead className="border-b border-[#dbe5ef] bg-[#f6f9fc] text-xs uppercase tracking-wider text-[#4b5f7a]"><tr className="text-left">
                            <th className="p-2">Compliance</th>
                            <th className="p-2">No.</th>
                            <th className="p-2">Evidence</th>
                            <th className="p-2">Applicable</th>
                            {canManage && <th className="p-2 text-right">Actions</th>}
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-[#e7edf4]">
                        {evidenceByCompliance.flatMap((group) => group.map((ev, index) => (
                            <tr key={ev.evidenceId} className={`hover:bg-[#f5f9fd] ${index === 0 ? "border-t-2 border-[#c5d5e8]" : ""}`}>
                                {index === 0 && <td rowSpan={group.length} className="border-r border-[#e7edf4] bg-[#f6f9fc] p-3 align-top font-semibold"><Link to={`/framework/compliance/${ev.complianceId}`} className="text-[#16803a] hover:underline">{ev.complianceNumber}</Link></td>}
                                <td className="p-2 text-center">{ev.evidenceNumber}</td>
                                <td className="p-2 text-justify whitespace-pre-line">{ev.evidenceSummary}</td>
                                <td className="p-2">
                                    {canToggleApplicability ? <button onClick={() => handleToggleApplicability(ev)}
                                        className={`px-3 py-1 rounded text-sm font-medium ${
                                            ev.isApplicable 
                                            ? "bg-green-100 text-green-700 hover:bg-green-200"
                                            : "bg-gray-200 text-gray-600 hover:bg-gray-300"
                                        }`}>
                                        {ev.isApplicable ? "Applicable" : "Not Applicable"}
                                    </button> : <span className={`inline-block rounded px-3 py-1 text-sm font-medium ${ev.isApplicable ? "bg-green-100 text-green-700" : "bg-gray-200 text-gray-600"}`}>{ev.isApplicable ? "Applicable" : "Not Applicable"}</span>}
                                </td>
                                {canManage && <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap">
                                        <button onClick={() => handleEditClick(ev)} className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]">
                                            Edit
                                        </button>
                                        <button onClick={() => handleDeleteClick(ev)} className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50">
                                            Delete
                                        </button>
                                    </div>
                                </td>}
                            </tr>
                        ))) }
                    </tbody>
                </table></div>
                {filteredEvidence.length === 0 && <p className="mt-4 rounded-lg border border-dashed border-[#c5d4e6] bg-white px-4 py-5 text-center text-sm text-[#4b5f7a]">No evidence records match these filters.</p>}
                </>
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
