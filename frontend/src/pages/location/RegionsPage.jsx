import { useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import RegionForm from "../../components/forms/RegionForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function RegionsPage() {
  const [regions, setRegions] = useState([]);
  const [editingRegion, setEditingRegion] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadRegions = async () => {
    try {
      setLoading(true);
      const res = await getAll("regions");
      setRegions(res.data);
      setError(null);
    } catch (err) {
      setError("Failed to load regions.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadRegions();
  }, []);

  const handleAddClick = () => {
    setEditingRegion(null);
    setShowForm(true);
  };

  const handleEditClick = (region) => {
    setEditingRegion(region);
    setShowForm(true);
  };

  const handleCancel = () => {
    setEditingRegion(null);
    setShowForm(false);
  };

  const handleSubmit = async (formData) => {
    try {
      if (editingRegion) {
        await update("regions", editingRegion.regionId, formData);
      } else {
        await create("regions", formData);
      }
      setShowForm(false);
      setEditingRegion(null);
      loadRegions();
    } catch (err) {
      setError("Failed to save region.");
      console.error(err);
    }
  };

  const handleDeleteClick = (region) => {
    setDeleteTarget(region);
  };

  const handleConfirmDelete = async () => {
    try {
      await remove("regions", deleteTarget.regionId);
      setDeleteTarget(null);
      loadRegions();
    } catch (err) {
      setError("Failed to delete region.");
      console.error(err);
    }
  };

  const sortedRegions = [...regions].sort((a, b) => a.regionName.localeCompare(b.regionName));

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold">Regions</h1>
        <button onClick={handleAddClick} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          + Add Region
        </button>
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table className="w-full border-collapse">
          <thead>
            <tr className="border-b text-left">
              <th className="p-2">Name</th>
              <th className="p-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {sortedRegions.map((r) => (
              <tr key={r.regionId} className="border-b">
                <td className="p-2">{r.regionName}</td>
                <td className="p-2 space-x-2">
                  <button
                    onClick={() => handleEditClick(r)}
                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 mb-2 w-20"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(r)}
                    className="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 mb-2 w-20"
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
        <RegionForm initialData={editingRegion} onSubmit={handleSubmit} onCancel={handleCancel} />
      </FormModal>

      <ConfirmDialog
        open={!!deleteTarget}
        title="Delete Region"
        message={`Are you sure you want to delete "${deleteTarget?.regionName}"?`}
        onConfirm={handleConfirmDelete}
        onCancel={() => setDeleteTarget(null)}
      />
    </div>
  );
}

export default RegionsPage;