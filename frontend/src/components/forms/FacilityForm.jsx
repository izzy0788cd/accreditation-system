import { useEffect, useMemo, useState } from "react";
import { getAll } from "../../api/api";

const emptyForm = { facilityName: "", regionId: "", provinceId: "", districtId: "", organizationId: "", levelId: "", creditationStatusId: "", headOfService: "", comments: "" };

function FacilityForm({ initialData, onSubmit, onCancel }) {
  const [formData, setFormData] = useState(emptyForm);
  const [data, setData] = useState({ regions: [], provinces: [], districts: [], organizations: [], levels: [], statuses: [] });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all(["regions", "provinces", "districts", "organizations", "levels", "creditationstatuses"].map(getAll))
      .then(([regions, provinces, districts, organizations, levels, statuses]) => setData({ regions: regions.data, provinces: provinces.data, districts: districts.data, organizations: organizations.data, levels: levels.data, statuses: statuses.data }))
      .catch(console.error).finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    if (!initialData || loading) { if (!initialData) setFormData(emptyForm); return; }
    const district = data.districts.find((item) => item.districtId === initialData.districtId);
    const province = data.provinces.find((item) => item.provinceId === district?.provinceId);
    setFormData({ ...initialData, districtId: String(initialData.districtId), provinceId: String(province?.provinceId ?? ""), regionId: String(province?.regionId ?? ""), organizationId: String(initialData.organizationId), levelId: String(initialData.levelId), creditationStatusId: String(initialData.creditationStatusId), headOfService: initialData.headOfService || "", comments: initialData.comments || "" });
  }, [initialData, loading, data.districts, data.provinces]);

  const provinces = useMemo(() => data.provinces.filter((item) => String(item.regionId) === String(formData.regionId)), [data.provinces, formData.regionId]);
  const districts = useMemo(() => data.districts.filter((item) => String(item.provinceId) === String(formData.provinceId)), [data.districts, formData.provinceId]);
  const updateField = (event) => {
    const { name, value } = event.target;
    if (name === "regionId") setFormData((current) => ({ ...current, regionId: value, provinceId: "", districtId: "" }));
    else if (name === "provinceId") setFormData((current) => ({ ...current, provinceId: value, districtId: "" }));
    else setFormData((current) => ({ ...current, [name]: value }));
  };
  const submit = (event) => {
    event.preventDefault();
    onSubmit({ facilityName: formData.facilityName.trim(), districtId: Number(formData.districtId), organizationId: Number(formData.organizationId), levelId: Number(formData.levelId), creditationStatusId: Number(formData.creditationStatusId), headOfService: formData.headOfService.trim(), comments: formData.comments.trim() || null });
  };
  const selectClass = "w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm outline-none transition focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0] disabled:bg-slate-50";
  if (loading) return <div className="space-y-3 p-2" aria-label="Loading facility form">{[1, 2, 3].map((item) => <div key={item} className="h-10 animate-pulse rounded bg-slate-100" />)}</div>;
  const prerequisitesReady = data.organizations.length && data.levels.length && data.statuses.length;
  return <form onSubmit={submit} className="space-y-5">
    <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Facility directory</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">{initialData ? "Edit facility" : "Add a facility"}</h2></div>
    {!prerequisitesReady && <p role="alert" className="rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-800">Add at least one organisation, facility level, and accreditation status in Reference data before creating facilities.</p>}
    <Field label="Facility name"><input required name="facilityName" value={formData.facilityName} onChange={updateField} maxLength={200} placeholder="e.g. Goroka Provincial Hospital" className={selectClass} /></Field>
    <div className="grid gap-4 sm:grid-cols-2"><Select label="Region" name="regionId" value={formData.regionId} onChange={updateField} options={data.regions} valueKey="regionId" labelKey="regionName" /><Select label="Province" name="provinceId" value={formData.provinceId} onChange={updateField} options={provinces} valueKey="provinceId" labelKey="provinceName" disabled={!formData.regionId} /><Select label="District" name="districtId" value={formData.districtId} onChange={updateField} options={districts} valueKey="districtId" labelKey="districtName" disabled={!formData.provinceId} required /><Select label="Organisation" name="organizationId" value={formData.organizationId} onChange={updateField} options={data.organizations} valueKey="organizationId" labelKey="organizationName" required /><Select label="Facility level" name="levelId" value={formData.levelId} onChange={updateField} options={data.levels} valueKey="levelId" labelKey="levelName" required /><Select label="Accreditation status" name="creditationStatusId" value={formData.creditationStatusId} onChange={updateField} options={data.statuses} valueKey="creditationStatusId" labelKey="creditationStatus" required /></div>
    <Field label="Head of service"><input name="headOfService" value={formData.headOfService} onChange={updateField} maxLength={200} placeholder="Optional" className={selectClass} /></Field>
    <Field label="Notes"><textarea name="comments" value={formData.comments} onChange={updateField} rows="3" placeholder="Optional operational notes" className={selectClass} /></Field>
    <div className="flex gap-2"><button disabled={!prerequisitesReady} type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#0d6531] disabled:cursor-not-allowed disabled:opacity-50">{initialData ? "Save changes" : "Add facility"}</button><button type="button" onClick={onCancel} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] transition hover:bg-slate-100">Cancel</button></div>
  </form>;
}
function Field({ label, children }) { return <label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#153a70]">{label}</span>{children}</label>; }
function Select({ label, name, value, onChange, options, valueKey, labelKey, disabled, required }) { return <label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#153a70]">{label}</span><select name={name} value={value} onChange={onChange} required={required} disabled={disabled} className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm outline-none transition focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0] disabled:bg-slate-50"><option value="" disabled>Select {label.toLowerCase()}</option>{options.map((option) => <option key={option[valueKey]} value={option[valueKey]}>{option[labelKey]}</option>)}</select></label>; }
export default FacilityForm;
