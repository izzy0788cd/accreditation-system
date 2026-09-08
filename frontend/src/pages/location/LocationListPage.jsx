import { useEffect, useState } from "react";
import { create, getAll, remove, update } from "../../api/api";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import { groupBy } from "../../utils/groupBy";
import { useAuth } from "../../context/AuthContext";
import { canManageReferenceData } from "../../utils/access";

function LocationListPage({ resource, singular, plural, idField, nameField, parentLabel, parentField, Form }) {
  const { auth } = useAuth();
  const canManage = canManageReferenceData(auth?.roleName);
  const [items, setItems] = useState([]);
  const [editingItem, setEditingItem] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [formKey, setFormKey] = useState(0);

  const loadItems = async () => {
    try {
      setLoading(true);
      const response = await getAll(resource);
      setItems(response.data);
      setError(null);
    } catch (err) {
      setError(`We couldn't load ${plural.toLowerCase()}. Please try again.`);
      console.error(err);
    } finally { setLoading(false); }
  };

  useEffect(() => { loadItems(); }, []);

  const closeForm = () => { setEditingItem(null); setShowForm(false); };
  const handleSubmit = async (formData) => {
    try {
      if (editingItem) {
        await update(resource, editingItem[idField], formData);
        closeForm();
      } else {
        await create(resource, formData);
        setFormKey((key) => key + 1);
      }
      await loadItems();
    } catch (err) {
      setError(`We couldn't save this ${singular.toLowerCase()}. Please try again.`);
      console.error(err);
    }
  };
  const handleDelete = async () => {
    try {
      await remove(resource, deleteTarget[idField]);
      setDeleteTarget(null);
      await loadItems();
    } catch (err) {
      setError(`We couldn't delete this ${singular.toLowerCase()}. It may still be in use.`);
      console.error(err);
    }
  };
  const sortedItems = [...items].sort((a, b) => a[nameField].localeCompare(b[nameField]));
  const groupedItems = parentField
    ? groupBy(sortedItems, (item) => item[parentField] || "Unassigned")
    : [sortedItems];

  return (
    <section aria-labelledby={`${resource}-title`}>
      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <p className="mb-1 text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Location directory</p>
          <h2 id={`${resource}-title`} className="text-2xl font-bold tracking-tight text-[#143c42]">{plural}</h2>
          <p className="mt-1 text-sm text-[#668187]">Maintain the {plural.toLowerCase()} used to organise health services.</p>
        </div>
        {canManage && <button onClick={() => { setEditingItem(null); setFormKey((key) => key + 1); setShowForm(true); }} className="inline-flex items-center justify-center gap-2 rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f] focus:outline-none focus:ring-2 focus:ring-[#087c77] focus:ring-offset-2">
          <span aria-hidden="true" className="text-lg leading-none">+</span> Add {singular}
        </button>}
      </div>
      {error && <div role="alert" className="mb-5 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</div>}
      <div className="overflow-hidden rounded-xl border border-[#e2ecea] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]">
        {loading ? <div className="space-y-3 p-6" aria-label={`Loading ${plural.toLowerCase()}`}>{[1, 2, 3].map((row) => <div key={row} className="h-10 animate-pulse rounded bg-slate-100" />)}</div>
          : sortedItems.length === 0 ? <div className="px-6 py-14 text-center"><div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-teal-50 text-xl text-teal-700">⌁</div><h3 className="font-semibold text-[#143c42]">No {plural.toLowerCase()} yet</h3><p className="mt-1 text-sm text-[#668187]">Add the first {singular.toLowerCase()} to start building the location directory.</p></div>
          : <div className="overflow-x-auto"><table className="w-full min-w-[520px] text-left"><thead className="border-b border-[#dce9e7] bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]"><tr>{parentLabel && <th className="px-6 py-3.5 font-semibold">{parentLabel}</th>}<th className="px-6 py-3.5 font-semibold">{singular} name</th>{canManage && <th className="px-6 py-3.5 text-right font-semibold">Actions</th>}</tr></thead><tbody className="divide-y divide-[#e7efed] text-sm">{groupedItems.flatMap((group) => group.map((item, index) => <tr key={item[idField]} className={`transition-colors hover:bg-[#f5fbfa] ${parentField && index === 0 ? "border-t-2 border-[#b9d6d1]" : ""}`}>{parentField && index === 0 && <td rowSpan={group.length} className="border-r border-[#e7efed] bg-[#f5faf9] px-6 py-4 align-top font-semibold text-[#087c77]">{item[parentField] || "Unassigned"}</td>}<td className="px-6 py-4 font-semibold text-[#143c42]">{item[nameField]}</td>{canManage && <td className="px-6 py-4"><div className="flex justify-end gap-2"><button onClick={() => { setEditingItem(item); setShowForm(true); }} className="rounded-md border border-[#b9d6d1] px-3 py-1.5 text-xs font-semibold text-[#087c77] transition hover:bg-teal-50">Edit</button><button onClick={() => setDeleteTarget(item)} className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 transition hover:bg-red-50">Delete</button></div></td>}</tr>))}</tbody></table></div>}
      </div>
      <FormModal open={showForm} onClose={closeForm}><Form key={formKey} initialData={editingItem} onSubmit={handleSubmit} onCancel={closeForm} /></FormModal>
      <ConfirmDialog open={!!deleteTarget} title={`Delete ${singular}`} message={`Are you sure you want to delete "${deleteTarget?.[nameField]}"?`} onConfirm={handleDelete} onCancel={() => setDeleteTarget(null)} />
    </section>
  );
}

export default LocationListPage;
