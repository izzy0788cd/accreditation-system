import { useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import ComponentForm from "../../components/forms/ComponentForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import { useAuth } from "../../context/AuthContext";
import { canManageReferenceData } from "../../utils/access";

function ComponentsPage() {
  const { auth } = useAuth();
  const canManage = canManageReferenceData(auth?.roleName);
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
    <section>
      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework layer</p><h2 className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Components</h2></div>
        {canManage && <button
          onClick={handleAddClick}
          className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]"
        >
          + Add Component
        </button>}
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {loading ? (
        <div className="space-y-3 rounded-xl border border-[#dfe7f0] p-6">{[1, 2, 3].map((row) => <div key={row} className="h-10 animate-pulse rounded bg-slate-100" />)}</div>
      ) : (
        <div className="overflow-x-auto rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[720px] text-sm"><thead className="border-b border-[#dbe5ef] bg-[#f6f9fc] text-xs uppercase tracking-wider text-[#4b5f7a]"><tr className="text-left"><th className="px-6 py-3.5">Number</th><th className="px-6 py-3.5">Name</th><th className="px-6 py-3.5">Summary</th>{canManage && <th className="px-6 py-3.5 text-right">Actions</th>}
            </tr>
          </thead>
          <tbody className="divide-y divide-[#e7edf4]">
            {components.map((c) => (
              <tr key={c.componentId} className="hover:bg-[#f5f9fd]"><td className="px-6 py-4 font-semibold text-[#16803a]">{c.componentNumber}</td><td className="px-6 py-4 font-semibold text-[#092a5a]">{c.componentName}</td><td className="px-6 py-4 text-justify leading-6 text-[#4b5f7a]">{c.componentSummary}</td>{canManage && <td className="px-6 py-4"><div className="flex justify-end gap-2 whitespace-nowrap">
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
                  </button></div>
                </td>}
              </tr>
            ))}
          </tbody>
        </table></div>
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
    </section>
  );
}

export default ComponentsPage;
