import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { getOne, getAll, update, remove, patchApplicability } from "../../api/api";
import CriterionForm from "../../components/forms/CriterionForm";
import CriterionWizardForm from "../../components/forms/CriterionWizardPage";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import { useAuth } from "../../context/AuthContext";
import { canManageReferenceData } from "../../utils/access";

function StandardDetailPage() {
  const { auth } = useAuth();
  const canManage = canManageReferenceData(auth?.roleName);
  const canToggleApplicability = canManage || auth?.roleName === "Surveyor";
  const { standardId } = useParams();
  const [standard, setStandard] = useState(null);
  const [criteria, setCriteria] = useState([]);
  const [editingCriterion, setEditingCriterion] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [showWizard, setShowWizard] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadData = async () => {
    try {
      setLoading(true);
      const [standardRes, criteriaRes] = await Promise.all([
        getOne("standards", standardId),
        getAll("criteria"),
      ]);
      setStandard(standardRes.data);
      setCriteria(
        criteriaRes.data.filter((c) => c.standardId === Number(standardId))
      );
      setError(null);
    } catch (err) {
      setError("Failed to load standard.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, [standardId]);

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
      await update("criteria", editingCriterion.criterionId, formData);
      setShowForm(false);
      setEditingCriterion(null);
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
      setError("Failed to update applicability.");
      console.error(err);
    }
  };

  const sortedCriteria = [...criteria].sort((a, b) =>
    a.criterionNumber.localeCompare(b.criterionNumber, undefined, { numeric: true })
  );

  if (loading) return <p>Loading...</p>;
  if (!standard) return <p>Standard not found.</p>;

  return (
    <div>
      <Link to="/framework/standards" className="text-sm font-semibold text-[#16803a] hover:underline">
        ← Back to Standards
      </Link>

      <div className="mb-6 mt-3 rounded-xl border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_100%)] px-6 py-5">
        <p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">NHSS standard</p><h1 className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">
          {standard.standardNumber} — {standard.standardTitle}
        </h1>
        <div className="mt-4 grid gap-3 sm:grid-cols-2"><div className="rounded-lg border border-[#c5d4e6] bg-white/80 px-4 py-3"><p className="text-xs font-bold uppercase tracking-[0.14em] text-[#4b5f7a]">Function</p><p className="mt-1 font-semibold text-[#092a5a]">{standard.functionNumber ? `${standard.functionNumber} — ` : ""}{standard.functionTitle || "Not recorded"}</p></div><div className="rounded-lg border border-[#c5d4e6] bg-white/80 px-4 py-3"><p className="text-xs font-bold uppercase tracking-[0.14em] text-[#4b5f7a]">Component</p><p className="mt-1 font-semibold text-[#092a5a]">{standard.componentNumber ? `${standard.componentNumber} — ` : ""}{standard.componentName || "Not recorded"}</p></div></div>
        {standard.standardSummary && (
          <p className="mt-4 text-justify leading-7 text-[#4b5f7a]">{standard.standardSummary}</p>
        )}
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      <div className="mb-4 flex items-center justify-between"><h2 className="text-xl font-bold text-[#092a5a]">Criteria</h2>
        {canManage && <button
          onClick={handleAddWizardClick}
          className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]"
        >
          + Add Criterion
        </button>}
      </div>

      <div className="overflow-x-auto rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[700px] text-sm">
        <thead>
          <tr className="border-b text-left">
            <th className="p-2">Number</th>
            <th className="p-2">Title</th>
            <th className="p-2">Applicable</th>
            {canManage && <th className="p-2 text-right">Actions</th>}
          </tr>
        </thead>
        <tbody>
          {sortedCriteria.map((c) => (
            <tr key={c.criterionId} className="border-b">
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
              {canManage && <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap"><button
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
                </button></div>
              </td>}
            </tr>
          ))}
        </tbody>
      </table></div>

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
          lockedStandardId={Number(standardId)}
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

export default StandardDetailPage;
