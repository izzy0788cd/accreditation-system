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
        <div>
            <div className="flex items-center justify-between mb-4">
                <h1 className="text-2xl font-bold">Functions</h1>
                <button onClick={handleAddClick} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    + Add Function
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
                        <th className="p-2">Title</th>
                        <th className="p-2">Summary</th>
                        <th className="p-2">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {sortedFunctions.map((f) => (
                        <tr key={f.functionId} className="border-b">
                            <td className="p-2 text-right font-semibold">{f.functionNumber}</td>
                            <td className="p-2">{f.functionTitle}</td>
                            <td className="p-2 text-justify">{f.functionSummary}</td>
                            <td className="p-2 space-x-2">
                            <button
                                onClick={() => handleEditClick(f)}
                                className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 mb-2 w-20"
                            >
                                Edit
                            </button>
                            <button
                                onClick={() => handleDeleteClick(f)}
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
        </div>
    );
}

export default FunctionsPage;