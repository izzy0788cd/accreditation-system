import { useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import FunctionForm from "../../components/forms/FunctionForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";

function FunctionsPage() {
    const [functions, setFunctions] = useState([]);
    const [editingFunction, setEditingFunction] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [deleteTarget, setDeleteTarget] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const loadFunctions = async () => {
        try {
        setLoading(true);
        const res = await getAll("functions");
        setFunctions(res.data);
        setError(null);
        } catch (err) {
        setError("Failed to load functions.");
        console.error(err);
        } finally {
        setLoading(false);
        }
    };

    useEffect(() => {
        loadFunctions();
    }, []);

    const handleAddClick = () => {
        setEditingFunction(null);
        setShowForm(true);
    };

    const handleEditClick = (functionItem) => {
        setEditingFunction(functionItem);
        setShowForm(true);
    }

    const handleCancel = () => {
        setEditingFunction(null);
        setShowForm(false);
    }

    const handleSubmit = async (formData) => {
        try {
            if (editingFunction) {
                await update("functions", editingFunction.functionId, formData);
            } else {
                await create("functions", formData);
            }
            setShowForm(false);
            setEditingFunction(null);
            loadFunctions();
        } catch (err) {
            setError("Failed to save function.");
            console.error(err);
        }
    };

    const handleDeleteClick = (functionItem) => {
        setDeleteTarget(functionItem);
    };

    const handleConfirmDelete = async () => {
        try {
            await remove("functions", deleteTarget.functionId);
            setDeleteTarget(null);
            loadFunctions();
        } catch (err) {
            setError("Failed to delete function.");
            console.error(err);
        }
    };

    const sortedFunctions = [...functions].sort((a, b) => a.functionNumber.localeCompare(b.functionNumber, undefined, { numeric: true}));

    return (
        <section>
            <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Framework layer</p><h2 className="mt-1 text-2xl font-bold tracking-tight text-[#143c42]">Functions</h2></div>
                <button onClick={handleAddClick} className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f]">
                    + Add Function
                </button>
            </div>

            {error && <p className="text-red-600 mb-4">{error}</p>}

            {loading ? (
                <div className="space-y-3 rounded-xl border border-[#e2ecea] p-6">{[1, 2, 3].map((row) => <div key={row} className="h-10 animate-pulse rounded bg-slate-100" />)}</div>
            ) : (
                <div className="overflow-x-auto rounded-xl border border-[#e2ecea] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[720px] text-sm">
                    <thead className="border-b border-[#dce9e7] bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]">
                        <tr className="text-left"><th className="px-6 py-3.5">Number</th><th className="px-6 py-3.5">Title</th><th className="px-6 py-3.5">Summary</th><th className="px-6 py-3.5 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-[#e7efed]">
                        {sortedFunctions.map((f) => (
                        <tr key={f.functionId} className="hover:bg-[#f5fbfa]"><td className="px-6 py-4 font-semibold text-[#087c77]">{f.functionNumber}</td><td className="px-6 py-4 font-semibold text-[#143c42]">{f.functionTitle}</td><td className="px-6 py-4 leading-6 text-[#527076]">{f.functionSummary}</td><td className="px-6 py-4"><div className="flex justify-end gap-2 whitespace-nowrap">
                            <button
                                onClick={() => handleEditClick(f)}
                                className="rounded-md border border-[#b9d6d1] px-3 py-1.5 text-xs font-semibold text-[#087c77] hover:bg-teal-50"
                            >
                                Edit
                            </button>
                            <button
                                onClick={() => handleDeleteClick(f)}
                                className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50"
                            >
                                Delete
                            </button></div>
                            </td>
                        </tr>
                        ))}
                    </tbody>
                </table></div>
            )}
                  <FormModal open={showForm} onClose={handleCancel}>
                    <FunctionForm
                    initialData={editingFunction}
                    onSubmit={handleSubmit}
                    onCancel={handleCancel}
                    />
                </FormModal>

                <ConfirmDialog
                    open={!!deleteTarget}
                    title="Delete Function"
                    message={`Are you sure you want to delete "${deleteTarget?.functionTitle}"?`}
                    onConfirm={handleConfirmDelete}
                    onCancel={() => setDeleteTarget(null)}
                />
        </section>
    );
}

export default FunctionsPage;
