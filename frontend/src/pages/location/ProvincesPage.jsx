import { useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import ProvinceForm from "../../components/forms/ProvinceForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function ProvincesPage() {
  const [provinces, setProvinces] = useState([]);
  const [editingProvince, setEditingProvince] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadProvinces = async () => {
    try {
      setLoading(true);
      const res = await getAll("provinces");
      setProvinces(res.data);
      setError(null);
    } catch (err) {
      setError("Failed to load provinces.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadProvinces();
  }, []);

  const handleAddClick = () => {
    setEditingProvince(null);
    setShowForm(true);
  };

  const handleEditClick = (province) => {
    setEditingProvince(province);
    setShowForm(true);
  };

  const handleCancel = () => {
    setEditingProvince(null);
    setShowForm(false);
  };

  const handleSubmit = async (formData) => {
    try {
      if (editingProvince) {
        await update("provinces", editingProvince.provinceId, formData);
      } else {
        await create("provinces", formData);
      }
      setShowForm(false);
      setEditingProvince(null);
      loadProvinces();
    } catch (err) {
      setError("Failed to save province.");
      console.error(err);
    }
  };

  const handleDeleteClick = (province) => {
    setDeleteTarget(province);
  };

  const handleConfirmDelete = async () => {
    try {
      await remove("provinces", deleteTarget.provinceId);
      setDeleteTarget(null);
      loadProvinces();
    } catch (err) {
      setError("Failed to delete province.");
      console.error(err);
    }
  };

  const sortedProvinces = [...provinces].sort((a, b) => a.provinceName.localeCompare(b.provinceName));

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold">Provinces</h1>
        <button onClick={handleAddClick} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          + Add Province
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
              <th className="p-2">Region</th>
              <th className="p-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {sortedProvinces.map((p) => (
              <tr key={p.provinceId} className="border-b">
                <td className="p-2">{p.provinceName}</td>
                <td className="p-2">{p.regionName}</td>
                <td className="p-2 space-x-2">
                  <button
                    onClick={() => handleEditClick(p)}
                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 mb-2 w-20"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(p)}
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
        <ProvinceForm initialData={editingProvince} onSubmit={handleSubmit} onCancel={handleCancel} />
      </FormModal>

      <ConfirmDialog
        open={!!deleteTarget}
        title="Delete Province"
        message={`Are you sure you want to delete "${deleteTarget?.provinceName}"?`}
        onConfirm={handleConfirmDelete}
        onCancel={() => setDeleteTarget(null)}
      />
    </div>
  );
}

export default ProvincesPage;