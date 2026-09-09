import { useEffect, useMemo, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { getAll, getOne, getSurveyAssessments, getSurveyStandardAssignments, update, updateSurveyStandardAssignments } from "../../api/api";

const dateValue = (value) => value?.slice?.(0, 10) || value || "";

function SurveyAdminPage() {
  const { surveyId } = useParams();
  const navigate = useNavigate();
  const [survey, setSurvey] = useState(null);
  const [types, setTypes] = useState([]);
  const [surveyors, setSurveyors] = useState([]);
  const [standards, setStandards] = useState([]);
  const [assignments, setAssignments] = useState({});
  const [form, setForm] = useState({ surveyTypeId: "", surveyorId: "", startDate: "", endDate: "" });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const load = async () => {
    try {
      setLoading(true);
      const [surveyRes, typeRes, surveyorRes, standardRes, assignmentRes, assessmentRes, complianceRes, criterionRes] = await Promise.all([
        getOne("surveys", surveyId), getAll("surveyTypes"), getAll("surveyors"), getAll("standards"),
        getSurveyStandardAssignments(surveyId), getSurveyAssessments(surveyId), getAll("compliances"), getAll("criteria"),
      ]);
      const currentSurvey = surveyRes.data;
      const criteriaById = new Map(criterionRes.data.map((criterion) => [criterion.criterionId, criterion]));
      const complianceById = new Map(complianceRes.data.map((compliance) => [compliance.complianceId, compliance]));
      const surveyedStandardIds = new Set(assessmentRes.data.map((assessment) => {
        const compliance = complianceById.get(assessment.complianceId);
        return criteriaById.get(compliance?.criterionId)?.standardId;
      }).filter(Boolean));
      const assignmentMap = Object.fromEntries(assignmentRes.data.map((assignment) => [assignment.standardId, String(assignment.surveyorId)]));
      setSurvey(currentSurvey);
      setTypes(typeRes.data);
      setSurveyors(surveyorRes.data);
      setStandards(standardRes.data.filter((standard) => surveyedStandardIds.has(standard.standardId)));
      setAssignments(assignmentMap);
      setForm({ surveyTypeId: String(currentSurvey.surveyTypeId), surveyorId: String(currentSurvey.surveyorId), startDate: dateValue(currentSurvey.startDate), endDate: dateValue(currentSurvey.endDate) });
      setError("");
    } catch (loadError) {
      console.error(loadError);
      setError("We couldn't load this survey administration page.");
    } finally { setLoading(false); }
  };

  useEffect(() => { load(); }, [surveyId]);
  const unassignedCount = useMemo(() => standards.filter((standard) => !assignments[standard.standardId]).length, [standards, assignments]);

  const save = async (event) => {
    event.preventDefault();
    if (form.endDate < form.startDate) { setError("End date cannot be before start date."); return; }
    try {
      setSaving(true);
      await update("surveys", surveyId, { surveyTypeId: Number(form.surveyTypeId), surveyorId: Number(form.surveyorId), startDate: form.startDate, endDate: form.endDate });
      const dedicatedAssignments = standards
        .filter((standard) => assignments[standard.standardId] && assignments[standard.standardId] !== form.surveyorId)
        .map((standard) => ({ standardId: standard.standardId, surveyorId: Number(assignments[standard.standardId]) }));
      await updateSurveyStandardAssignments(surveyId, dedicatedAssignments);
      navigate(`/surveys/${surveyId}`);
    } catch (saveError) { console.error(saveError); } finally { setSaving(false); }
  };

  if (loading) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><div className="h-64 animate-pulse rounded-2xl bg-slate-100" /></main>;
  if (error && !survey) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><Link to="/surveys" className="text-sm font-semibold text-[#087c77]">← Back to surveys</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;

  return <main className="mx-auto max-w-6xl px-4 py-6 sm:px-6 lg:py-8">
    <Link to="/surveys" className="text-sm font-semibold text-[#087c77] hover:underline">← Back to surveys</Link>
    <header className="mt-5 rounded-2xl border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_60%,#fdf7ea_100%)] p-6 sm:p-8">
      <p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Survey administration</p>
      <h1 className="mt-2 text-3xl font-bold tracking-tight text-[#143c42]">{survey.facilityName}</h1>
      <p className="mt-2 max-w-2xl text-sm leading-6 text-[#527076]">Update the survey details, nominate the team lead, and allocate each included standard to the surveyor responsible for it.</p>
    </header>
    {error && <p className="mt-5 rounded-lg border border-red-100 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</p>}
    <form onSubmit={save} className="mt-6 space-y-6">
      <section className="rounded-xl border border-[#dce9e7] bg-white p-5 shadow-sm sm:p-6">
        <h2 className="text-lg font-bold text-[#143c42]">Survey details</h2>
        <p className="mt-1 text-sm text-[#527076]">The facility is fixed once the checklist has been generated.</p>
        <div className="mt-5 grid gap-4 md:grid-cols-2">
          <label className="text-sm font-semibold text-[#143c42]">Survey type<select value={form.surveyTypeId} onChange={(event) => setForm({ ...form, surveyTypeId: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] px-3 py-2.5 text-sm"><option value="">Select survey type</option>{types.map((type) => <option key={type.surveyTypeId} value={type.surveyTypeId}>{type.surveyTypeName}</option>)}</select></label>
          <label className="text-sm font-semibold text-[#143c42]">Team lead<select value={form.surveyorId} onChange={(event) => setForm({ ...form, surveyorId: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] px-3 py-2.5 text-sm"><option value="">Select team lead</option>{surveyors.map((surveyor) => <option key={surveyor.surveyorId} value={surveyor.surveyorId}>{surveyor.fullName}</option>)}</select></label>
          <label className="text-sm font-semibold text-[#143c42]">Start date<input required type="date" value={form.startDate} onChange={(event) => setForm({ ...form, startDate: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] px-3 py-2.5 text-sm" /></label>
          <label className="text-sm font-semibold text-[#143c42]">End date<input required type="date" value={form.endDate} onChange={(event) => setForm({ ...form, endDate: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] px-3 py-2.5 text-sm" /></label>
        </div>
      </section>
      <section className="overflow-hidden rounded-xl border border-[#dce9e7] bg-white shadow-sm">
        <div className="border-b border-[#dce9e7] bg-[#f5faf9] p-5 sm:p-6"><h2 className="text-lg font-bold text-[#143c42]">Standard assignments</h2><p className="mt-1 text-sm text-[#527076]">Leave a standard with the team lead, or choose a dedicated surveyor. A surveyor can be responsible for more than one standard.</p>{unassignedCount > 0 && <p className="mt-3 text-xs font-semibold text-[#876318]">{unassignedCount} standard{unassignedCount === 1 ? "" : "s"} currently covered by the team lead.</p>}</div>
        <div className="divide-y divide-[#e7efed]">{standards.map((standard) => <div key={standard.standardId} className="grid gap-3 p-5 sm:grid-cols-[minmax(0,1fr)_18rem] sm:items-center sm:px-6"><div><p className="text-sm font-bold text-[#0b6f6b]">Standard {standard.standardNumber}</p><p className="mt-1 text-sm leading-6 text-[#143c42]">{standard.standardTitle}</p></div><label className="text-sm font-semibold text-[#527076]"><span className="sr-only">Assigned surveyor for Standard {standard.standardNumber}</span><select value={assignments[standard.standardId] || form.surveyorId} onChange={(event) => setAssignments({ ...assignments, [standard.standardId]: event.target.value })} className="w-full rounded-lg border border-[#c9ddd9] bg-white px-3 py-2.5 text-sm text-[#143c42]"><option value={form.surveyorId}>Team lead — {surveyors.find((surveyor) => String(surveyor.surveyorId) === form.surveyorId)?.fullName || "Select team lead"}</option>{surveyors.filter((surveyor) => String(surveyor.surveyorId) !== form.surveyorId).map((surveyor) => <option key={surveyor.surveyorId} value={surveyor.surveyorId}>{surveyor.fullName}</option>)}</select></label></div>)}</div>
      </section>
      <div className="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end"><Link to={`/surveys/${surveyId}`} className="rounded-lg border border-[#b9d6d1] px-4 py-2.5 text-center text-sm font-semibold text-[#527076] hover:bg-slate-50">Cancel</Link><button disabled={saving} type="submit" className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f] disabled:opacity-60">{saving ? "Saving…" : "Save survey administration"}</button></div>
    </form>
  </main>;
}

export default SurveyAdminPage;
