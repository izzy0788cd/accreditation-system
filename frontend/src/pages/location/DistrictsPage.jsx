import { useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import DistrictForm from "../../components/forms/DistrictForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function DistrictsPage() {
  const [districts, setDistricts] = useState([]);
  const [editingDistrict, setEditingDistrict] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadDistricts = async () => {
    try {
      setLoading(true);
      const res = await getAll("districts");
      setDistricts(res.data);
      setError(null);
    } catch (err) {
      setError("Failed to load districts.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDistricts();
  }, []);

  const handleAddClick = () => {
    setEditingDistrict(null);
    setShowForm(true);
  };

  const handleEditClick = (district) => {
    setEditingDistrict(district);
    setShowForm(true);
  };

  const handleCancel = () => {
    setEditingDistrict(null);
    setShowForm(false);
  };

  const handleSubmit = async (formData) => {
    try {
      if (editingDistrict) {
        await update("districts", editingDistrict.districtId, formData);
      } else {
        await create("districts", formData);
      }
      setShowForm(false);
      setEditingDistrict(null);
      loadDistricts();
    } catch (err) {
      setError("Failed to save district.");
      console.error(err);
    }
  };

  const handleDeleteClick = (district) => {
    setDeleteTarget(district);
  };

  const handleConfirmDelete = async () => {
    try {
      await remove("districts", deleteTarget.districtId);
      setDeleteTarget(null);
      loadDistricts();
    } catch (err) {
      setError("Failed to delete district.");
      console.error(err);
    }
  };

  const sortedDistricts = [...districts].sort((a, b) => a.districtName.localeCompare(b.districtName));

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold">Districts</h1>
        <button onClick={handleAddClick} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          + Add District
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
              <th className="p-2">Province</th>
              <th className="p-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {sortedDistricts.map((d) => (
              <tr key={d.districtId} className="border-b">
                <td className="p-2">{d.districtName}</td>
                <td className="p-2">{d.provinceName}</td>
                <td className="p-2 space-x-2">
                  <button
                    onClick={() => handleEditClick(d)}
                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 mb-2 w-20"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(d)}
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
        <DistrictForm initialData={editingDistrict} onSubmit={handleSubmit} onCancel={handleCancel} />
      </FormModal>

      <ConfirmDialog
        open={!!deleteTarget}
        title="Delete District"
        message={`Are you sure you want to delete "${deleteTarget?.districtName}"?`}
        onConfirm={handleConfirmDelete}
        onCancel={() => setDeleteTarget(null)}
      />
    </div>
  );
}

export default DistrictsPage;