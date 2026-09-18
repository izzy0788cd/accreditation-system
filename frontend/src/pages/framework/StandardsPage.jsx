import { Fragment, useEffect, useState } from "react";
import { getAll, create, update, remove } from "../../api/api";
import { Link } from "react-router-dom";
import StandardForm from "../../components/forms/StandardForm";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import FrameworkFilters from "../../components/FrameworkFilters/FrameworkFilters";
import { STANDARD_23_FAMILY, isStandard23Child } from "../../utils/standardFamilies";
import { useAuth } from "../../context/AuthContext";
import { canManageReferenceData } from "../../utils/access";

function StandardsPage() {
  const { auth } = useAuth();
  const canManage = canManageReferenceData(auth?.roleName);
  const [standards, setStandards] = useState([]);
  const [editingStandard, setEditingStandard] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [search, setSearch] = useState("");

  const loadStandards = async (initialLoad = false) => {
    try {
      // Keep the current list mounted during a refresh. Replacing it with a
      // short Loading state collapses the page and causes the browser to
      // clamp the viewport back to the top after an edit.
      if (initialLoad) setLoading(true);
      const res = await getAll("standards");
      setStandards(res.data);
      setError(null);
    } catch (err) {
      setError("Failed to load standards.");
      console.error(err);
    } finally {
      if (initialLoad) setLoading(false);
    }
  };

  useEffect(() => {
    loadStandards(true);
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
    const previousScrollTop = window.scrollY;
    try {
      if (editingStandard) {
        await update("standards", editingStandard.standardId, formData);
      } else {
        await create("standards", formData);
      }
      setShowForm(false);
      setEditingStandard(null);
      await loadStandards();
      // Closing the modal and refreshing its row must leave the editor at
      // the item they were working on, rather than at the top of the list.
      window.requestAnimationFrame(() => window.scrollTo({ top: previousScrollTop, behavior: "auto" }));
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
  const normalizedSearch = search.trim().toLowerCase();
  const filteredStandards = sortedStandards.filter((standard) =>
    [standard.standardNumber, standard.standardTitle, standard.standardSummary]
      .some((value) => value?.toLowerCase().includes(normalizedSearch))
  );

  return (
    <div>
      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework layer</p><h2 className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Standards</h2></div>
        {canManage && <button
          onClick={handleAddClick}
          className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]"
        >
          + Add Standard
        </button>}
      </div>

      {error && <p className="text-red-600 mb-4">{error}</p>}

      {loading ? (
        <p>Loading...</p>
      ) : (
        <>
        <FrameworkFilters search={search} onSearchChange={setSearch} searchPlaceholder="Search number, title, or summary" resultCount={filteredStandards.length} totalCount={standards.length} />
        <div className="overflow-x-auto rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><table className="w-full min-w-[800px] text-sm"><thead className="border-b border-[#dbe5ef] bg-[#f6f9fc] text-xs uppercase tracking-wider text-[#4b5f7a]"><tr className="text-left">
              {/* <th className="p-2">Function</th> */}
              {/* <th className="p-2">Component</th> */}
              <th className="p-2">NHSS Standard</th>
              <th className="p-2">Title</th>
              <th className="p-2">Summary</th>
              {canManage && <th className="p-2 text-right">Actions</th>}
            </tr>
          </thead>
          <tbody className="divide-y divide-[#e7edf4]">
            {filteredStandards.map((s, index) => (
              <Fragment key={s.standardId}>
              {isStandard23Child(s.standardNumber) && !filteredStandards.slice(0, index).some((item) => isStandard23Child(item.standardNumber)) && <tr key="standard-23-family" className="bg-[#edf8f0]"><td colSpan={canManage ? 4 : 3} className="px-3 py-4"><p className="font-bold text-[#092a5a]">Standard {STANDARD_23_FAMILY.number} — {STANDARD_23_FAMILY.title}</p><p className="mt-1 max-w-5xl whitespace-pre-line text-justify text-sm leading-6 text-[#4b5f7a]">{STANDARD_23_FAMILY.summary}</p><p className="mt-2 text-xs font-semibold text-[#16803a]">Each lettered specialty remains separate for assessment, assignment, and reporting.</p></td></tr>}
              <tr className="hover:bg-[#f5f9fd]">
                {/* <td className="p-2 text-center font-semibold">{s.functionNumber}</td> */}
                {/* <td className="p-2 text-center font-semibold">{s.componentNumber}</td> */}
                <td className="p-2 text-left font-semibold"><Link to={`/framework/standards/${s.standardId}`} className="text-blue-600 hover:underline">{s.standardNumber}</Link></td>
                <td className="p-2">{s.standardTitle}</td>
                <td className="p-2 text-justify">{s.standardSummary}</td>
                {canManage && <td className="p-2"><div className="flex justify-end gap-2 whitespace-nowrap">
                  <Link
                    to={`/framework/standards/${s.standardId}`}
                    className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]"
                  >
                    Details
                  </Link>
                  <button
                    onClick={() => handleEditClick(s)}
                    className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDeleteClick(s)}
                    className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50"
                  >
                    Delete
                  </button></div>
                </td>}
              </tr>
              </Fragment>
            ))}
          </tbody>
        </table></div>
        {filteredStandards.length === 0 && <p className="mt-4 rounded-lg border border-dashed border-[#c5d4e6] bg-white px-4 py-5 text-center text-sm text-[#4b5f7a]">No standards match these filters.</p>}
        </>
      )}

      <FormModal open={showForm} onClose={handleCancel} wide>
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
