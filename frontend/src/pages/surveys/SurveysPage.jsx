import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { create, getAll } from "../../api/api";
import FormModal from "../../components/FormModal";
import { useAuth } from "../../context/AuthContext";

const dateValue = (value) => value?.slice?.(0, 10) || value || "";

function SurveysPage() {
  const { auth, profile } = useAuth();
  const [surveys, setSurveys] = useState([]);
  const [facilities, setFacilities] = useState([]);
  const [types, setTypes] = useState([]);
  const [surveyors, setSurveyors] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [formOpen, setFormOpen] = useState(false);
  const [form, setForm] = useState({ facilityId: "", surveyTypeId: "", surveyorId: "", startDate: "", endDate: "" });

  const load = async () => {
    try {
      setLoading(true);
      const [surveyRes, facilityRes, typeRes, surveyorRes] = await Promise.all([
        getAll("surveys"), getAll("facilities"), getAll("surveyTypes"), getAll("surveyors"),
      ]);
      setSurveys(surveyRes.data);
      setFacilities(facilityRes.data);
      setTypes(typeRes.data);
      setSurveyors(surveyorRes.data);
      setError("");
    } catch (err) {
      setError("We couldn't load the survey workspace.");
      console.error(err);
    } finally { setLoading(false); }
  };

  useEffect(() => { load(); }, []);

  const submit = async (event) => {
    event.preventDefault();
    try {
      await create("surveys", {
        facilityId: Number(form.facilityId), surveyTypeId: Number(form.surveyTypeId), surveyorId: Number(form.surveyorId),
        startDate: form.startDate, endDate: form.endDate,
      });
      setFormOpen(false);
      setForm({ facilityId: "", surveyTypeId: "", surveyorId: "", startDate: "", endDate: "" });
      await load();
    } catch (err) { console.error(err); }
  };

  const sortedSurveys = [...surveys].sort((a, b) => String(b.startDate).localeCompare(String(a.startDate)));
  const isAdmin = auth?.roleName === "Admin";
  const resumeLink = (surveyId) => {
    try {
      const saved = JSON.parse(localStorage.getItem(`survey-resume-${profile?.userId || "anonymous"}-${surveyId}`) || "null");
      return saved?.assessmentId ? `/surveys/${surveyId}?resume=${saved.assessmentId}` : null;
    } catch {
      return null;
    }
  };

  return <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
    <header className="mb-6 rounded-2xl border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_60%,#fdf7ea_100%)] p-6 sm:p-8">
      <p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Assessment workspace</p>
      <div className="mt-2 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between"><div><h1 className="text-3xl font-bold tracking-tight text-[#143c42]">Surveys</h1><p className="mt-2 max-w-2xl text-sm leading-6 text-[#527076]">Create an Internal or External survey, then record compliance scores and evidence checks.</p></div>{isAdmin && <div className="flex gap-2"><Link to="/surveys/setup" className="rounded-lg border border-[#b9d6d1] bg-white px-4 py-2.5 text-sm font-semibold text-[#087c77] hover:bg-teal-50">Survey setup</Link><button onClick={() => setFormOpen(true)} className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f]">+ Create survey</button></div>}</div>
    </header>
    {!isAdmin && <p className="mb-5 rounded-lg border border-sky-100 bg-sky-50 px-4 py-3 text-sm text-sky-800">You can complete assigned assessments. Only Administrators can create surveys.</p>}
    {error && <p className="mb-4 text-sm text-red-700">{error}</p>}
    <section className="overflow-hidden rounded-xl border border-[#e2ecea] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]">
      {loading ? <div className="space-y-3 p-6">{[1, 2, 3].map((item) => <div key={item} className="h-14 animate-pulse rounded bg-slate-100" />)}</div> : sortedSurveys.length === 0 ? <div className="px-6 py-16 text-center"><h2 className="font-semibold text-[#143c42]">No surveys yet</h2><p className="mt-1 text-sm text-[#668187]">Create a survey to generate its assessment checklist from the applicable framework.</p></div> : <div className="overflow-x-auto"><table className="w-full min-w-[760px] text-left text-sm"><thead className="border-b border-[#dce9e7] bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]"><tr><th className="px-5 py-3.5">Facility</th><th className="px-5 py-3.5">Type</th><th className="px-5 py-3.5">Team lead</th><th className="px-5 py-3.5">Dates</th><th className="px-5 py-3.5 text-right">Actions</th></tr></thead><tbody className="divide-y divide-[#e7efed]">{sortedSurveys.map((survey) => <tr key={survey.surveyId} className="hover:bg-[#f5fbfa]"><td className="px-5 py-4 font-semibold text-[#143c42]">{survey.facilityName}</td><td className="px-5 py-4"><div className="flex flex-wrap gap-1.5"><span className="rounded-full bg-teal-50 px-2.5 py-1 text-xs font-semibold text-teal-700">{survey.surveyTypeName}</span>{survey.isCancelled && <span className="rounded-full bg-red-50 px-2.5 py-1 text-xs font-semibold text-red-700">Cancelled</span>}</div></td><td className="px-5 py-4 text-[#527076]">{survey.surveyorName}</td><td className="px-5 py-4 text-[#527076]">{dateValue(survey.startDate)} — {dateValue(survey.endDate)}</td><td className="px-5 py-4 text-right"><div className="flex justify-end gap-2">{!survey.isCancelled && resumeLink(survey.surveyId) && <Link to={resumeLink(survey.surveyId)} className="rounded-lg bg-[#d6aa45] px-3 py-2 text-xs font-semibold text-[#143c42] hover:bg-[#c99d38]">Continue</Link>}<Link to={`/surveys/${survey.surveyId}`} className="rounded-lg border border-[#b9d6d1] px-3 py-2 text-xs font-semibold text-[#087c77] hover:bg-teal-50">{survey.isCancelled ? "View history" : "Open assessment"}</Link>{isAdmin && <Link to={`/surveys/${survey.surveyId}/admin`} className="rounded-lg bg-[#143c42] px-3 py-2 text-xs font-semibold text-white hover:bg-[#0d2c31]">Administer</Link>}</div></td></tr>)}</tbody></table></div>}
    </section>
    <FormModal open={formOpen} onClose={() => setFormOpen(false)}><form onSubmit={submit}><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Assessment setup</p><h2 className="mt-1 text-xl font-bold text-[#143c42]">Create survey</h2><div className="mt-5 space-y-4">{[["Facility", "facilityId", facilities, "facilityId", "facilityName"], ["Survey type", "surveyTypeId", types, "surveyTypeId", "surveyTypeName"], ["Team lead", "surveyorId", surveyors, "surveyorId", "fullName"]].map(([label, key, options, valueKey, labelKey]) => <label key={key} className="block text-sm font-semibold text-[#143c42]">{label}<select required value={form[key]} onChange={(event) => setForm({ ...form, [key]: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] px-3 py-2.5 text-sm"><option value="">Select {label.toLowerCase()}</option>{options.map((option) => <option key={option[valueKey]} value={option[valueKey]}>{option[labelKey]}</option>)}</select></label>)}<div className="grid gap-4 sm:grid-cols-2">{[["Start date", "startDate"], ["End date", "endDate"]].map(([label, key]) => <label key={key} className="block text-sm font-semibold text-[#143c42]">{label}<input required type="date" value={form[key]} onChange={(event) => setForm({ ...form, [key]: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] px-3 py-2.5 text-sm" /></label>)}</div></div><div className="mt-6 flex justify-end gap-3"><button type="button" onClick={() => setFormOpen(false)} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#527076]">Cancel</button><button type="submit" className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white">Create survey</button></div></form></FormModal>
  </main>;
}

export default SurveysPage;
