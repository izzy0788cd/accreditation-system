import { useEffect, useState } from "react";
import { getAll, create, update, remove, patchApplicability } from "../../api/api";
import { Link } from "react-router-dom";
import CriterionForm from "../../components/forms/CriterionForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";


function CriteriaPage() {
    const [criteria, setCriteria] = useState([]);
    const [editingCriterion, setEditingCriterion] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [successMessage, setSuccessMessage] = useState(null);

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

    const handleEditClick = (criterion) => {
        setEditingCriterion(criterion);
        setShowForm(true);
    };

    const handleCancel = () => {
        setEditingCriterion(null);
        setShowForm(false);
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
        loadData(); // or loadCriteria(), matching whichever file you're in
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
        loadData();
        } catch (err) {
        setError("Failed to update Applicability.");
        console.error(err);
        }
    };

    const sortedCriteria = [...criteria].sort((a, b) =>
        a.criterionNumber.localeCompare(b.criterionNumber, undefined, { numeric: true })
    );

    return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold">Criteria</h1>
        <button
          onClick={handleAddClick}
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          + Add Criterion
        </button>
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table className="w-full border-collapse">
          <thead>
            <tr className="border-b text-left">
              <th className="p-2">Standard</th>
              <th className="p-2">Criteria</th>
              <th className="p-2">Title</th>
              <th className="p-2">Applicable</th>
              <th className="p-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {sortedCriteria.map((c) => (
              <tr key={c.criterionId} className="border-b">
                <td className="p-2"><Link to={`/framework/standards/${c.standardId}`} className="text-blue-600 hover:underline">{c.standardNumber}</Link></td>
                <td className="p-2 text-left font-semibold"><Link to={`/framework/criteria/${c.criterionId}`} className="text-blue-600 hover:underline">{c.criterionNumber}</Link></td>
                <td className="p-2">{c.criterionTitle}</td>
                <td className="p-2">
                  <button
                    onClick={() => handleToggleApplicability(c)}
                    className={`px-3 py-1 rounded text-sm font-medium ${
                      c.isApplicable
                        ? "bg-green-100 text-green-700 hover:bg-green-200"
                        : "bg-gray-200 text-gray-600 hover:bg-gray-300"
                    }`}
                  >
                    {c.isApplicable ? "Applicable" : "Not Applicable"}
                  </button>
                </td>
                <td className="p-2 space-x-2">
                  <div className="flex gap-2">
                    <button
                    onClick={() => handleEditClick(c)}
                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 w-20 mb-2"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(c)}
                    className="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 w-20 mb-2"
                  >
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
        <CriterionForm
          initialData={editingCriterion}
          onSubmit={handleSubmit}
          onCancel={handleCancel}
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