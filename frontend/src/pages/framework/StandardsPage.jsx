import { useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import { Link } from "react-router-dom";
import StandardForm from "../../components/forms/StandardForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function StandardsPage() {
  const [standards, setStandards] = useState([]);
  const [editingStandard, setEditingStandard] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadStandards = async () => {
    try {
      setLoading(true);
      const res = await getAll("standards");
      setStandards(res.data);
      setError(null);
    } catch (err) {
      setError("Failed to load standards.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadStandards();
  }, []);

  const handleAddClick = () => {
    setEditingStandard(null);
    setShowForm(true);
  };

  const handleEditClick = (standard) => {
    setEditingStandard(standard);
    setShowForm(true);
  };

  const handleCancel = () => {
    setEditingStandard(null);
    setShowForm(false);
  };

  const handleSubmit = async (formData) => {
    try {
      if (editingStandard) {
        await update("standards", editingStandard.standardId, formData);
      } else {
        await create("standards", formData);
      }
      setShowForm(false);
      setEditingStandard(null);
      loadStandards();
    } catch (err) {
      setError("Failed to save standard.");
      console.error(err);
    }
  };

  const handleDeleteClick = (standard) => {
    setDeleteTarget(standard);
  };

  const handleConfirmDelete = async () => {
    try {
      await remove("standards", deleteTarget.standardId);
      setDeleteTarget(null);
      loadStandards();
    } catch (err) {
      setError("Failed to delete standard.");
      console.error(err);
    }
  };

  const sortedStandards = [...standards].sort((a, b) =>
    a.standardNumber.localeCompare(b.standardNumber, undefined, { numeric: true })
  );

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold">Standards</h1>
        <button
          onClick={handleAddClick}
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          + Add Standard
        </button>
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table className="w-full border-collapse">
          <thead>
            <tr className="border-b text-left">
              <th className="p-2">Function</th>
              <th className="p-2">Component</th>
              <th className="p-2">NHSS Standard</th>
              <th className="p-2">Title</th>
              <th className="p-2">Summary</th>
              <th className="p-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {sortedStandards.map((s) => (
              <tr key={s.standardId} className="border-b">
                <td className="p-2 text-center font-semibold">{s.functionNumber}</td>
                <td className="p-2 text-center font-semibold">{s.componentNumber}</td>
                <td className="p-2 text-left font-semibold"><Link to={`/framework/standards/${s.standardId}`} className="text-blue-600 hover:underline">{s.standardNumber}</Link></td>
                <td className="p-2">{s.standardTitle}</td>
                <td className="p-2 text-justify">{s.standardSummary}</td>
                <td className="p-2 space-x-2">
                  <button
                    onClick={() => handleEditClick(s)}
                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 w-20 mb-2"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(s)}
                    className="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 w-20 mb-2"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <FormModal open={showForm} onClose={handleCancel}>
        <StandardForm
          initialData={editingStandard}
          onSubmit={handleSubmit}
          onCancel={handleCancel}
        />
      </FormModal>

      <ConfirmDialog
        open={!!deleteTarget}
        title="Delete Standard"
        message={`Are you sure you want to delete "${deleteTarget?.standardTitle}"?`}
        onConfirm={handleConfirmDelete}
        onCancel={() => setDeleteTarget(null)}
      />
    </div>
  );
}

export default StandardsPage;