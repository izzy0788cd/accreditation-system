import { useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import ComponentForm from "../../components/forms/ComponentForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function ComponentsPage() {
  const [components, setComponents] = useState([]);
  const [editingComponent, setEditingComponent] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadComponents = async () => {
    try {
      setLoading(true);
      const res = await getAll("components");
      setComponents(res.data);
      setError(null);
    } catch (err) {
      setError("Failed to load components.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadComponents();
  }, []);

  const handleAddClick = () => {
    setEditingComponent(null);
    setShowForm(true);
  };

  const handleEditClick = (component) => {
    setEditingComponent(component);
    setShowForm(true);
  };

  const handleCancel = () => {
    setEditingComponent(null);
    setShowForm(false);
  };

const handleSubmit = async (formData) => {
    try {
      if (editingComponent) {
        await update("components", editingComponent.componentId, formData);
      } else {
        await create("components", formData);
      }
      setShowForm(false);
      setEditingComponent(null);
      loadComponents();
    } catch (err) {
      setError("Failed to save component.");
      console.error(err);
    }
  };

  const handleDeleteClick = (component) => {
    setDeleteTarget(component);
  };

  const handleConfirmDelete = async () => {
    try {
      await remove("components", deleteTarget.componentId);
      setDeleteTarget(null);
      loadComponents();
    } catch (err) {
      setError("Failed to delete component.");
      console.error(err);
    }
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold">Components</h1>
        <button
          onClick={handleAddClick}
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          + Add Component
        </button>
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table className="w-full border-collapse">
          <thead>
            <tr className="border-b text-left">
              <th className="p-2">Number</th>
              <th className="p-2">Name</th>
              <th className="p-2">Summary</th>
              <th className="p-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {components.map((c) => (
              <tr key={c.componentId} className="border-b">
                <td className="p-2 text-right font-semibold">{c.componentNumber}</td>
                <td className="p-2">{c.componentName}</td>
                <td className="p-2 text-justify">{c.componentSummary}</td>
                <td className="p-2 space-x-2">
                  <button
                    onClick={() => handleEditClick(c)}
                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 mb-2 w-20"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(c)}
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
        <ComponentForm
          initialData={editingComponent}
          onSubmit={handleSubmit}
          onCancel={handleCancel}
        />
      </FormModal>

      <ConfirmDialog
        open={!!deleteTarget}
        title="Delete Component"
        message={`Are you sure you want to delete "${deleteTarget?.componentName}"?`}
        onConfirm={handleConfirmDelete}
        onCancel={() => setDeleteTarget(null)}
      />
    </div>
  );
}

export default ComponentsPage;