import { useEffect, useMemo, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { cancelSurvey, getAll, getOne, getSurveyAssessments, getSurveyStandardAssignments, syncSurveyFramework, update, updateSurveyStandardAssignments } from "../../api/api";
import ConfirmDialog from "../../components/ConfirmDialog";
import SurveyContextNav from "../../components/SurveyContextNav";
import useUnsavedChanges from "../../hooks/useUnsavedChanges";

const dateValue = (value) => value?.slice?.(0, 10) || value || "";

function SurveyAdminPage() {
  const { surveyId } = useParams();
  const navigate = useNavigate();
  const [survey, setSurvey] = useState(null);
  const [types, setTypes] = useState([]);
  const [surveyors, setSurveyors] = useState([]);
  const [standards, setStandards] = useState([]);
  const [assignments, setAssignments] = useState({});
  const [baseline, setBaseline] = useState(null);
  const [form, setForm] = useState({ surveyTypeId: "", surveyorId: "", startDate: "", endDate: "" });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [syncing, setSyncing] = useState(false);
  const [cancelling, setCancelling] = useState(false);
  const [cancelOpen, setCancelOpen] = useState(false);
  const [cancellationReason, setCancellationReason] = useState("");
  const [notice, setNotice] = useState("");
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
      setStandards(standardRes.data
        .filter((standard) => surveyedStandardIds.has(standard.standardId))
        .sort((first, second) => String(first.standardNumber).localeCompare(
          String(second.standardNumber),
          undefined,
          { numeric: true, sensitivity: "base" },
        )));
      setAssignments(assignmentMap);
      const initialForm = { surveyTypeId: String(currentSurvey.surveyTypeId), surveyorId: String(currentSurvey.surveyorId), startDate: dateValue(currentSurvey.startDate), endDate: dateValue(currentSurvey.endDate) };
      setForm(initialForm);
      setBaseline({ form: initialForm, assignments: assignmentMap });
      setError("");
    } catch (loadError) {
      console.error(loadError);
      setError("We couldn't load this survey administration page.");
    } finally { setLoading(false); }
  };

  useEffect(() => { load(); }, [surveyId]);
  useUnsavedChanges(Boolean(baseline) && !survey?.isCancelled && JSON.stringify({ form, assignments }) !== JSON.stringify(baseline));
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

  const syncFramework = async () => {
    try {
      setSyncing(true);
      const response = await syncSurveyFramework(surveyId);
      setNotice(response.data.message);
      await load();
    } catch (syncError) { console.error(syncError); } finally { setSyncing(false); }
  };

  const cancelCurrentSurvey = async () => {
    if (!cancellationReason.trim()) { setError("Enter a reason before cancelling this survey."); return; }
    try {
      setCancelling(true);
      await cancelSurvey(surveyId, cancellationReason);
      setCancelOpen(false);
      setNotice("The survey has been cancelled. Its recorded findings remain available as read-only history.");
      await load();
    } catch (cancelError) { console.error(cancelError); } finally { setCancelling(false); }
  };

  if (loading) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><div className="h-64 animate-pulse rounded-2xl bg-slate-100" /></main>;
  if (error && !survey) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><Link to="/surveys" className="text-sm font-semibold text-[#16803a]">← Back to surveys</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;

  return <main className="mx-auto max-w-6xl px-4 py-6 sm:px-6 lg:py-8">
    <Link to="/surveys" className="text-sm font-semibold text-[#16803a] hover:underline">← Back to surveys</Link>
    <SurveyContextNav surveyId={surveyId} />
    <header className="mt-5 rounded-2xl border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_60%,#fdf7ea_100%)] p-6 sm:p-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Survey administration</p>
      <h1 className="mt-2 text-3xl font-bold tracking-tight text-[#092a5a]">{survey.facilityName}</h1>
      <p className="mt-2 max-w-2xl text-sm leading-6 text-[#4b5f7a]">Update the survey details, nominate the team lead, and allocate each included standard to the surveyor responsible for it.</p></div><Link to={`/surveys/${surveyId}/team-dashboard`} className="shrink-0 rounded-lg bg-[#16803a] px-4 py-2.5 text-center text-sm font-semibold text-white shadow-sm hover:bg-[#0d6531]">Survey team dashboard</Link></div>
    </header>
    {survey.isCancelled && <section className="mt-5 rounded-xl border border-red-200 bg-red-50 p-5 text-sm text-red-900"><p className="font-bold">Cancelled survey</p><p className="mt-1 leading-6">{survey.cancellationReason}</p><p className="mt-2 text-xs text-red-700">Cancelled {survey.cancelledAt ? new Date(survey.cancelledAt).toLocaleString() : ""}{survey.cancelledByUsername ? ` by ${survey.cancelledByUsername}` : ""}. Existing findings remain available, but cannot be changed.</p></section>}
    {error && <p className="mt-5 rounded-lg border border-red-100 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</p>}
    {notice && <p className="mt-5 rounded-lg border border-teal-100 bg-[#edf8f0] px-4 py-3 text-sm text-teal-800">{notice}</p>}
    <form onSubmit={save} className="mt-6 space-y-6">
      <section className="rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm sm:p-6">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between"><div><h2 className="text-lg font-bold text-[#092a5a]">Edit survey details</h2><p className="mt-1 text-sm text-[#4b5f7a]">The facility is fixed once the checklist has been generated.</p></div>{!survey.isCancelled && <button type="button" disabled={syncing} onClick={syncFramework} className="rounded-lg border border-[#c5d5e8] bg-white px-4 py-2.5 text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0] disabled:opacity-60">{syncing ? "Synchronising…" : "Sync latest framework"}</button>}</div>
        <div className="mt-5 grid gap-4 md:grid-cols-2">
          <label className="text-sm font-semibold text-[#092a5a]">Survey type<select disabled={survey.isCancelled} value={form.surveyTypeId} onChange={(event) => setForm({ ...form, surveyTypeId: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm disabled:bg-slate-50"><option value="">Select survey type</option>{types.map((type) => <option key={type.surveyTypeId} value={type.surveyTypeId}>{type.surveyTypeName}</option>)}</select></label>
          <label className="text-sm font-semibold text-[#092a5a]">Team lead<select disabled={survey.isCancelled} value={form.surveyorId} onChange={(event) => setForm({ ...form, surveyorId: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm disabled:bg-slate-50"><option value="">Select team lead</option>{surveyors.map((surveyor) => <option key={surveyor.surveyorId} value={surveyor.surveyorId}>{surveyor.fullName}</option>)}</select></label>
          <label className="text-sm font-semibold text-[#092a5a]">Start date<input disabled={survey.isCancelled} required type="date" value={form.startDate} onChange={(event) => setForm({ ...form, startDate: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm disabled:bg-slate-50" /></label>
          <label className="text-sm font-semibold text-[#092a5a]">End date<input disabled={survey.isCancelled} required type="date" value={form.endDate} onChange={(event) => setForm({ ...form, endDate: event.target.value })} className="mt-1.5 w-full rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm disabled:bg-slate-50" /></label>
        </div>
      </section>
      <section className="overflow-hidden rounded-xl border border-[#dbe5ef] bg-white shadow-sm">
        <div className="border-b border-[#dbe5ef] bg-[#f6f9fc] p-5 sm:p-6"><h2 className="text-lg font-bold text-[#092a5a]">Standard assignments</h2><p className="mt-1 text-sm text-[#4b5f7a]">Leave a standard with the team lead, or choose a dedicated surveyor. A surveyor can be responsible for more than one standard.</p>{unassignedCount > 0 && <p className="mt-3 text-xs font-semibold text-[#876318]">{unassignedCount} standard{unassignedCount === 1 ? "" : "s"} currently covered by the team lead.</p>}</div>
        <div className="divide-y divide-[#e7edf4]">{standards.map((standard) => <div key={standard.standardId} className="grid gap-3 p-5 sm:grid-cols-[minmax(0,1fr)_18rem] sm:items-center sm:px-6"><div><p className="text-sm font-bold text-[#0f6b3c]">Standard {standard.standardNumber}</p><p className="mt-1 text-sm leading-6 text-[#092a5a]">{standard.standardTitle}</p></div><label className="text-sm font-semibold text-[#4b5f7a]"><span className="sr-only">Assigned surveyor for Standard {standard.standardNumber}</span><select disabled={survey.isCancelled} value={assignments[standard.standardId] || form.surveyorId} onChange={(event) => setAssignments({ ...assignments, [standard.standardId]: event.target.value })} className="w-full rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm text-[#092a5a] disabled:bg-slate-50"><option value={form.surveyorId}>Team lead — {surveyors.find((surveyor) => String(surveyor.surveyorId) === form.surveyorId)?.fullName || "Select team lead"}</option>{surveyors.filter((surveyor) => String(surveyor.surveyorId) !== form.surveyorId).map((surveyor) => <option key={surveyor.surveyorId} value={surveyor.surveyorId}>{surveyor.fullName}</option>)}</select></label></div>)}</div>
      </section>
      <div className="flex flex-col-reverse gap-3 sm:flex-row sm:items-center sm:justify-between"><div>{!survey.isCancelled && <button type="button" onClick={() => setCancelOpen(true)} className="rounded-lg border border-red-200 bg-white px-4 py-2.5 text-sm font-semibold text-red-700 hover:bg-red-50">Cancel survey</button>}</div><div className="flex flex-col-reverse gap-3 sm:flex-row"><Link to={`/surveys/${surveyId}`} className="rounded-lg border border-[#c5d5e8] px-4 py-2.5 text-center text-sm font-semibold text-[#4b5f7a] hover:bg-slate-50">Back to survey</Link>{!survey.isCancelled && <button disabled={saving} type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531] disabled:opacity-60">{saving ? "Saving…" : "Save survey administration"}</button>}</div></div>
    </form>
    <ConfirmDialog open={cancelOpen} title="Cancel this survey?" message="The survey will remain in the system as read-only history. Enter the reason below so the decision is auditable." confirmLabel={cancelling ? "Cancelling…" : "Cancel survey"} confirmDisabled={cancelling || !cancellationReason.trim()} onCancel={() => !cancelling && setCancelOpen(false)} onConfirm={cancelCurrentSurvey}><label className="mt-4 block text-sm font-semibold text-[#092a5a]">Cancellation reason<textarea autoFocus required value={cancellationReason} onChange={(event) => setCancellationReason(event.target.value)} rows="4" className="mt-1.5 w-full resize-y rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm font-normal" placeholder="For example: facility requested a change of dates." /></label></ConfirmDialog>
  </main>;
}

export default SurveyAdminPage;
