import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { create, getAll, remove, update } from "../../api/api";
import { useAuth } from "../../context/AuthContext";
import ConfirmDialog from "../../components/ConfirmDialog";
import FormModal from "../../components/FormModal";
import FacilityForm from "../../components/forms/FacilityForm";
import AccreditationStatusBadge from "../../components/AccreditationStatusBadge";
import { canManageReferenceData } from "../../utils/access";

function FacilitiesPage() {
  const { auth } = useAuth();
  const canManage = canManageReferenceData(auth?.roleName);
  const [facilities, setFacilities] = useState([]);
  const [query, setQuery] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [editing, setEditing] = useState(null);
  const [deleting, setDeleting] = useState(null);
  const [formOpen, setFormOpen] = useState(false);
  const [formKey, setFormKey] = useState(0);
  const load = async () => { try { setLoading(true); const response = await getAll("facilities"); setFacilities(response.data); setError(""); } catch (err) { console.error(err); setError("We couldn't load facilities. Please try again."); } finally { setLoading(false); } };
  useEffect(() => { load(); }, []);
  const visibleFacilities = useMemo(() => facilities.filter((facility) => [facility.facilityName, facility.districtName, facility.organizationName, facility.levelName, facility.creditationStatus].some((value) => value?.toLowerCase().includes(query.toLowerCase()))).sort((a, b) => a.facilityName.localeCompare(b.facilityName)), [facilities, query]);
  const closeForm = () => { setFormOpen(false); setEditing(null); };
  const save = async (payload) => { try { if (editing) { await update("facilities", editing.facilityId, payload); closeForm(); } else { await create("facilities", payload); setFormKey((value) => value + 1); } await load(); } catch (err) { console.error(err); setError("We couldn't save this facility. Please try again."); } };
  const confirmDelete = async () => { try { await remove("facilities", deleting.facilityId); setDeleting(null); await load(); } catch (err) { console.error(err); setError("We couldn't delete this facility. It may already have surveys."); } };
  return <section aria-labelledby="facilities-title">
    <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Facility directory</p><h2 id="facilities-title" className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Health Facilities</h2><p className="mt-1 text-sm text-[#68778c]">Search, manage, and prepare facilities for accreditation surveys.</p></div>{canManage && <button onClick={() => { setEditing(null); setFormKey((value) => value + 1); setFormOpen(true); }} className="inline-flex items-center justify-center gap-2 rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]"><span className="text-lg leading-none">+</span>Add facility</button>}</div>
    <div className="mb-5 rounded-xl border border-[#dfe7f0] bg-white p-4 shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><label className="sr-only" htmlFor="facility-search">Search facilities</label><input id="facility-search" value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search by facility, district, organisation, level, or status" className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm outline-none transition focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" /></div>
    {error && <p role="alert" className="mb-5 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</p>}
    <div className="overflow-hidden rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]">{loading ? <div className="space-y-3 p-6">{[1, 2, 3].map((item) => <div key={item} className="h-12 animate-pulse rounded bg-slate-100" />)}</div> : visibleFacilities.length === 0 ? <div className="px-6 py-16 text-center"><div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-[#edf8f0] text-xl text-[#16803a]">+</div><h3 className="font-semibold text-[#092a5a]">{facilities.length ? "No matching facilities" : "No facilities yet"}</h3><p className="mt-1 text-sm text-[#68778c]">{facilities.length ? "Try a different search term." : "Add your first health facility to begin preparing surveys."}</p>{!facilities.length && canManage && <Link to="/facilities/reference-data" className="mt-4 inline-flex rounded-lg border border-[#c5d5e8] px-3 py-2 text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]">Review setup data →</Link>}</div> : <div className="overflow-x-auto"><table className="w-full min-w-[860px] text-left text-sm"><thead className="border-b border-[#dbe5ef] bg-[#f6f9fc] text-xs uppercase tracking-wider text-[#4b5f7a]"><tr><th className="px-6 py-3.5 font-semibold">Facility</th><th className="px-6 py-3.5 font-semibold">Location</th><th className="px-6 py-3.5 font-semibold">Organisation</th><th className="px-6 py-3.5 font-semibold">Level</th><th className="px-6 py-3.5 font-semibold">Status</th>{canManage && <th className="px-6 py-3.5 text-right font-semibold">Actions</th>}</tr></thead><tbody className="divide-y divide-[#e7edf4]">{visibleFacilities.map((facility) => <tr key={facility.facilityId} className="hover:bg-[#f5f9fd]"><td className="px-6 py-4 font-semibold text-[#092a5a]"><Link to={`/facilities/directory/${facility.facilityId}`} className="hover:text-[#16803a] hover:underline">{facility.facilityName}</Link></td><td className="px-6 py-4 text-[#4b5f7a]">{facility.districtName}</td><td className="px-6 py-4 text-[#4b5f7a]">{facility.organizationName}</td><td className="px-6 py-4 text-[#4b5f7a]">{facility.levelName}</td><td className="px-6 py-4"><AccreditationStatusBadge status={facility.creditationStatus} /></td>{canManage && <td className="px-6 py-4"><div className="flex justify-end gap-2"><button onClick={() => { setEditing(facility); setFormOpen(true); }} className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]">Edit</button><button onClick={() => setDeleting(facility)} className="rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50">Delete</button></div></td>}</tr>)}</tbody></table></div>}</div>
    <FormModal open={formOpen} onClose={closeForm}><FacilityForm key={formKey} initialData={editing} onSubmit={save} onCancel={closeForm} /></FormModal><ConfirmDialog open={!!deleting} title="Delete facility" message={`Are you sure you want to delete "${deleting?.facilityName}"?`} onConfirm={confirmDelete} onCancel={() => setDeleting(null)} />
  </section>;
}
export default FacilitiesPage;
