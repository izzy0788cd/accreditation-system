import { useEffect, useState } from "react";
import { getAll, create, update, remove, patchApplicability } from "../../api/api";
import { Link } from "react-router-dom";
import CriterionForm from "../../components/forms/CriterionForm";
import CriterionWizardForm from "../../components/forms/CriterionWizardPage";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import { groupBy } from "../../utils/groupBy";
import FrameworkFilters from "../../components/FrameworkFilters/FrameworkFilters";
import { useAuth } from "../../context/AuthContext";
import { canManageReferenceData } from "../../utils/access";


function CriteriaPage() {
    const { auth } = useAuth();
    const canManage = canManageReferenceData(auth?.roleName);
    const canToggleApplicability = canManage || auth?.roleName === "Surveyor";
    const [criteria, setCriteria] = useState([]);
    const [editingCriterion, setEditingCriterion] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [showWizard, setShowWizard] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [, setSuccessMessage] = useState(null);
    const [search, setSearch] = useState("");
    const [standardFilter, setStandardFilter] = useState("");
    const [applicabilityFilter, setApplicabilityFilter] = useState("");

    const loadData = async () => {
        try {
            setLoading(true);
            const res = await getAll("criteria");
            setCriteria(res.data);
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
    }, []);

    const handleAddClick = () => {
        setEditingCriterion(null);
        setShowForm(true);
    };

    const handleAddWizardClick = () => {
        setShowWizard(true);
    };

    const handleEditClick = (criterion) => {
        setEditingCriterion(criterion);
        setShowForm(true);
    };

    const handleCancel = () => {
        setEditingCriterion(null);
        setShowForm(false);
    };

    const handleWizardCancel = () => {
        setShowWizard(false);
    };

    const handleWizardDone = () => {
        setShowWizard(false);
        loadData();
    };

const handleSubmit = async (formData) => {
    try {
        if (editingCriterion) {
            await update("criteria", editingCriterion.criterionId, formData);
            setShowForm(false);
            setEditingCriterion(null);
        } else {
            await create("criteria", formData);
            setSuccessMessage(`"${formData.criterionTitle}" added.`);
            setTimeout(() => setSuccessMessage(null), 2000);
        }
        loadData();
    } catch (err) {
        setError("Failed to save criterion.");
        console.error(err);
    }
};

    const handleDeleteClick = (criterion) => {
        setDeleteTarget(criterion);
    };

    const handleConfirmDelete = async () => {
        try {
        await remove("criteria", deleteTarget.criterionId);
        setDeleteTarget(null);
        loadData();
        } catch (err) {
        setError("Failed to delete criterion.");
        console.error(err);
        }
    };

    const handleToggleApplicability = async (criterion) => {
        try {
        await patchApplicability("criteria", criterion.criterionId, !criterion.isApplicable);
        setCriteria((current) => current.map((item) => item.criterionId === criterion.criterionId ? { ...item, isApplicable: !item.isApplicable } : item));
        } catch (err) {
        setError("Failed to update Applicability.");
        console.error(err);
        }
    };

    const sortedCriteria = [...criteria].sort((a, b) =>
        a.criterionNumber.localeCompare(b.criterionNumber, undefined, { numeric: true })
    );
    const standardOptions = [...new Map(criteria.map((item) => [item.standardId, { value: String(item.standardId), label: `${item.standardNumber} — ${item.standardTitle}` }])).values()]
        .sort((a, b) => a.label.localeCompare(b.label, undefined, { numeric: true }));
    const normalizedSearch = search.trim().toLowerCase();
    const filteredCriteria = sortedCriteria.filter((item) => {
        const matchesSearch = [item.criterionNumber, item.criterionTitle, item.standardNumber, item.standardTitle]
            .some((value) => value?.toLowerCase().includes(normalizedSearch));
        const matchesStandard = !standardFilter || String(item.standardId) === standardFilter;
        const matchesApplicability = !applicabilityFilter
            || (applicabilityFilter === "applicable" ? item.isApplicable : !item.isApplicable);
        return matchesSearch && matchesStandard && matchesApplicability;
    });
    const criteriaByStandard = groupBy(filteredCriteria, (item) => item.standardNumber);

    return (
    <div>
      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework layer</p><h2 className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Criteria</h2></div>
        {canManage && <div className="flex gap-2">
          <button
            onClick={handleAddClick}
            className="rounded-lg border border-[#c5d5e8] px-4 py-2.5 text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]"
          >
            + Add Criterion
          </button>
          <button
            onClick={handleAddWizardClick}
            className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]"
          >
            + Add Criterion with Compliance &amp; Evidence
          </button>
        </div>}
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {loading ? (
        <p>Loading...</p>
      ) : (
        <>
        <FrameworkFilters search={search} onSearchChange={setSearch} searchPlaceholder="Search number, criterion, or standard" parentLabel="Standard" parentValue={standardFilter} onParentChange={setStandardFilter} parentOptions={standardOptions} applicability={applicabilityFilter} onApplicabilityChange={setApplicabilityFilter} resultCount={filteredCriteria.length} totalCount={criteria.length} />
        <div className="overflow-x-auto rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[760px] text-sm"><thead className="border-b border-[#dbe5ef] bg-[#f6f9fc] text-xs uppercase tracking-wider text-[#4b5f7a]"><tr className="text-left">
              <th className="p-2">Standard</th>
              <th className="p-2">Criteria</th>
              <th className="p-2">Title</th>
              <th className="p-2">Applicable</th>
              {canManage && <th className="p-2 text-right">Actions</th>}
            </tr>
          </thead>
          <tbody className="divide-y divide-[#e7edf4]">
            {criteriaByStandard.flatMap((group) => group.map((c, index) => (
              <tr key={c.criterionId} className={`hover:bg-[#f5f9fd] ${index === 0 ? "border-t-2 border-[#c5d5e8]" : ""}`}>
                {index === 0 && <td rowSpan={group.length} className="border-r border-[#e7edf4] bg-[#f6f9fc] p-3 align-top font-semibold"><Link to={`/framework/standards/${c.standardId}`} className="text-[#16803a] hover:underline">{c.standardNumber}</Link></td>}
                <td className="p-2 text-left font-semibold"><Link to={`/framework/criteria/${c.criterionId}`} className="text-blue-600 hover:underline">{c.criterionNumber}</Link></td>
                <td className="p-2">{c.criterionTitle}</td>
                <td className="p-2">
                  {canToggleApplicability ? <button
                    onClick={() => handleToggleApplicability(c)}
                    className={`px-3 py-1 rounded text-sm font-medium ${
                      c.isApplicable
                        ? "bg-green-100 text-green-700 hover:bg-green-200"
                        : "bg-gray-200 text-gray-600 hover:bg-gray-300"
                    }`}
                  >
                    {c.isApplicable ? "Applicable" : "Not Applicable"}
                  </button> : <span className={`inline-block rounded px-3 py-1 text-sm font-medium ${c.isApplicable ? "bg-green-100 text-green-700" : "bg-gray-200 text-gray-600"}`}>{c.isApplicable ? "Applicable" : "Not Applicable"}</span>}
                </td>
                {canManage && <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap">
                    <button
                    onClick={() => handleEditClick(c)}
                    className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(c)}
                    className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50"
                  >
                    Delete
                  </button>
                  </div>
                </td>}
              </tr>
            ))) }
          </tbody>
        </table></div>
        {filteredCriteria.length === 0 && <p className="mt-4 rounded-lg border border-dashed border-[#c5d4e6] bg-white px-4 py-5 text-center text-sm text-[#4b5f7a]">No criteria match these filters.</p>}
        </>
      )}

      <FormModal open={showForm} onClose={handleCancel}>
        <CriterionForm
          initialData={editingCriterion}
          onSubmit={handleSubmit}
          onCancel={handleCancel}
        />
      </FormModal>

      <FormModal open={showWizard} onClose={handleWizardCancel} wide>
        <CriterionWizardForm
          onDone={handleWizardDone}
          onCancel={handleWizardCancel}
        />
      </FormModal>

      <ConfirmDialog
        open={!!deleteTarget}
        title="Delete Criterion"
        message={`Are you sure you want to delete "${deleteTarget?.criterionTitle}"?`}
        onConfirm={handleConfirmDelete}
        onCancel={() => setDeleteTarget(null)}
      />
    </div>
  );
}

export default CriteriaPage;
