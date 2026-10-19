import { rememberSurveyResume } from "../../utils/surveyResume";
import { useEffect, useMemo, useState } from "react";
import { Link, useNavigate, useParams, useSearchParams } from "react-router-dom";
import { getAll, getMySurveyorStandardSummaries, getMySurveyorReportWorkspace, getOne, saveMySurveyorStandardSummary } from "../../api/api";
import { useAuth } from "../../context/AuthContext";
import ConfirmDialog from "../../components/ConfirmDialog";
import SurveyContextNav from "../../components/SurveyContextNav";
import useUnsavedChanges from "../../hooks/useUnsavedChanges";

const blank = { summary: "", goodPractices: "", areasOfConcern: "", recommendations: "", notApplicableNotes: "", serviceAreas: [] };

export default function SurveyorStandardSummaryPage() {
  const { surveyId, standardId } = useParams();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { profile, auth } = useAuth();
  const [locked, setLocked] = useState(false);
  const [recommendations, setRecommendations] = useState([]);
  const [removeArea, setRemoveArea] = useState(null);
  const surveyorMode = searchParams.get("mode") === "surveyor";
  const nextStandardId = searchParams.get("next");
  const [survey, setSurvey] = useState(null);
  const [standard, setStandard] = useState(null);
  const [form, setForm] = useState(blank);
  const [savedForm, setSavedForm] = useState(blank);
  const [complete, setComplete] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    let active = true;
    const load = async () => {
      try {
        setLoading(true);
        const [surveyRes, standardsRes, assessmentsRes, compliancesRes, criteriaRes, summariesRes, workspaceRes ] = await Promise.all([
          getOne("surveys", surveyId), getAll("standards"), getAll(`complianceAssessments/survey/${surveyId}/mine`), getAll("compliances"), getAll("criteria"), getMySurveyorStandardSummaries(surveyId), getMySurveyorReportWorkspace(surveyId),
        ]);
        if (!active) return;
        const currentStandard = standardsRes.data.find((item) => String(item.standardId) === String(standardId));
        const complianceById = new Map(compliancesRes.data.map((item) => [item.complianceId, item]));
        const criterionById = new Map(criteriaRes.data.map((item) => [item.criterionId, item]));
        const assigned = assessmentsRes.data.filter((assessment) => {
          const compliance = complianceById.get(assessment.complianceId);
          const criterion = criterionById.get(compliance?.criterionId);
          return String(criterion?.standardId) === String(standardId);
        });
        const existing = summariesRes.data.find((summary) => String(summary.standardId) === String(standardId));
        if (!currentStandard || !assigned.length) throw new Error("This standard is not assigned to you.");
        const nextForm = Object.fromEntries(Object.keys(blank).map(key => [key, existing?.[key] ?? blank[key]]));
        setLocked(!!surveyRes.data.isCancelled || !!workspaceRes.data.report?.isSubmitted);
        setRecommendations(assigned.filter(item => item.scoreValue != null && item.scoreValue <= 2).sort((a, b) => a.complianceNumber.localeCompare(b.complianceNumber, undefined, { numeric: true })));
        setSurvey(surveyRes.data); setStandard(currentStandard); setForm(nextForm); setSavedForm(nextForm);
        setComplete(assigned.every((assessment) => assessment.scoreId != null));
        setError("");
      } catch (loadError) {
        console.error(loadError);
        if (active) setError("We couldn't load this standard summary. Confirm that the standard is assigned to you.");
      } finally { if (active) setLoading(false); }
    };
    load();
    return () => { active = false; };
  }, [surveyId, standardId]);

  useEffect(() => {
    if (!loading && standard && !locked) rememberSurveyResume(profile?.userId, surveyId, { step: "summation", standardId, nextStandardId });
  }, [loading, standard, locked, profile?.userId, surveyId, standardId, nextStandardId]);

  const nextPath = useMemo(() => {
    if (nextStandardId) return `/surveys/${surveyId}?standard=${nextStandardId}${surveyorMode ? "&mode=surveyor" : ""}`;
    return `/surveys/${surveyId}/report${surveyorMode ? "?mode=surveyor" : ""}`;
  }, [nextStandardId, surveyId, surveyorMode]);
  const save = async (continueAfterSave = true) => {
    try {
      setSaving(true);
      await saveMySurveyorStandardSummary(surveyId, standardId, form);
      setSavedForm(form);
      if (continueAfterSave) navigate(nextPath);
      setError("");
    } catch (saveError) {
      console.error(saveError);
      setError(saveError.response?.data || "We couldn't save this standard summary.");
    } finally { setSaving(false); }
  };
  useUnsavedChanges(JSON.stringify(form) !== JSON.stringify(savedForm));

  if (loading) return <main className="mx-auto max-w-4xl px-4 py-8"><div className="h-64 animate-pulse rounded-2xl bg-slate-100" /></main>;
  if (error && !standard) return <main className="mx-auto max-w-4xl px-4 py-8"><Link to={`/surveys/${surveyId}${surveyorMode ? "?mode=surveyor" : ""}`} className="text-sm font-semibold text-[#16803a]">← Back to survey</Link><p className="mt-5 rounded-xl border border-red-200 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;

  const set = (key, value) => setForm(current => ({ ...current, [key]: value }));
  const updateArea = (index, key, value) => setForm(current => ({ ...current, serviceAreas: current.serviceAreas.map((area, i) => i === index ? { ...area, [key]: value } : area) }));
  const valid = form.summary.trim() && form.serviceAreas.every(area => area.name.trim() && area.overview.trim());
  return <main className="mx-auto max-w-4xl px-4 py-6 sm:px-6 lg:py-8">
    <Link to={`/surveys/${surveyId}?standard=${standardId}${surveyorMode ? "&mode=surveyor" : ""}`} className="text-sm font-semibold text-[#16803a]">← Back to standard</Link>
    <SurveyContextNav surveyId={surveyId} />
    <header className="mt-5 rounded-xl border border-[#bfded8] bg-[#f3faf8] p-6">
      <p className="text-xs font-bold uppercase tracking-widest text-[#16803a]">Standard summation report</p>
      <h1 className="mt-2 text-2xl font-bold text-[#092a5a]">Standard {standard.standardNumber}: {standard.standardTitle}</h1>
      <dl className="mt-4 grid gap-3 text-sm text-[#4b5f7a] sm:grid-cols-2">
        <div><dt className="font-semibold">Facility</dt><dd>{survey.facilityName}</dd></div>
        <div><dt className="font-semibold">Surveyor</dt><dd>{[profile?.firstName, profile?.lastName].filter(Boolean).join(" ") || auth?.username}</dd></div>
        <div><dt className="font-semibold">Survey</dt><dd>{survey.surveyTypeName} · #{surveyId}</dd></div>
        <div><dt className="font-semibold">Survey dates</dt><dd>{survey.startDate} — {survey.endDate}</dd></div>
      </dl>
    </header>
    {error && <p role="alert" className="mt-5 rounded-lg border border-red-200 bg-red-50 p-4 text-red-800">{error}</p>}
    {locked && <p className="mt-5 rounded-lg border border-[#bfded8] bg-[#edf8f0] p-4 text-sm text-[#092a5a]">This report is read-only because the survey is cancelled or your summations are submitted. Ask your Team Lead or Admin to reopen submitted work.</p>}
    {!complete && <p className="mt-5 rounded-lg border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">Score every assigned requirement in this standard before saving the summation report.</p>}
    <form className="mt-6 rounded-xl border border-[#dbe5ef] bg-white p-5" onSubmit={event => { event.preventDefault(); save(true); }}>
      <p className="text-sm leading-6 text-[#4b5f7a]">Describe the services assessed, recognise strengths, and summarise concerns and recommendations. Save each standard summation, then submit them together once all your assigned standards are complete. No extra overall summary is required. Existing summaries remain in the services / areas field.</p>
      <fieldset disabled={locked || saving || !complete} className="mt-5 space-y-5 disabled:opacity-70">
        <TextArea label="Services / areas assessed" required value={form.summary} onChange={value => set("summary", value)} hint="Describe the wards, units or services visited and their context." />
        <TextArea label="Commendations" value={form.goodPractices} onChange={value => set("goodPractices", value)} hint="What is working well? Include strengths and achievements." />
        <TextArea label="Areas of concern" value={form.areasOfConcern} onChange={value => set("areasOfConcern", value)} hint="Summarise significant gaps and risks, quoting requirement numbers where useful." />
        <TextArea label="Opportunities for improvement and recommendations" value={form.recommendations} onChange={value => set("recommendations", value)} hint="Consolidate the recommendations recorded during scoring. No action owners or deadlines are required." />
        {form.serviceAreas.map((area, index) => <section key={index} className="space-y-4 border-t border-[#dbe5ef] pt-5">
          <div className="flex flex-wrap items-center justify-between gap-2"><h2 className="font-bold text-[#092a5a]">Additional service / area {index + 1}</h2><button type="button" onClick={() => setRemoveArea(index)} className="text-sm font-semibold text-red-700 underline">Remove area</button></div>
          <label className="block text-sm font-semibold text-[#092a5a]">Service / area name *<input required maxLength={200} value={area.name} onChange={event => updateArea(index, "name", event.target.value)} className="mt-1.5 w-full rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5" /></label>
          <TextArea label="Service / area overview" required value={area.overview} onChange={value => updateArea(index, "overview", value)} />
          <TextArea label="Commendations" value={area.commendations} onChange={value => updateArea(index, "commendations", value)} />
          <TextArea label="Areas of concern" value={area.areasOfConcern} onChange={value => updateArea(index, "areasOfConcern", value)} />
          <TextArea label="Opportunities for improvement and recommendations" value={area.recommendations} onChange={value => updateArea(index, "recommendations", value)} />
        </section>)}
        <button type="button" disabled={form.serviceAreas.length >= 20} onClick={() => set("serviceAreas", [...form.serviceAreas, { name: "", overview: "", commendations: "", areasOfConcern: "", recommendations: "" }])} className="rounded-lg border border-[#c5d5e8] px-4 py-2 text-sm font-semibold text-[#16803a] disabled:opacity-50">+ Add service / area</button>
        <TextArea label="Not applicable / scope notes" value={form.notApplicableNotes} onChange={value => set("notApplicableNotes", value)} hint="Optional: explain exclusions or limitations." />
        <div className="flex flex-wrap justify-end gap-3">
          <button type="button" disabled={!valid} onClick={() => save(false)} className="rounded-lg border border-[#c5d5e8] px-4 py-2.5 font-semibold text-[#16803a] disabled:opacity-50">Save</button>
          <button type="submit" disabled={!valid} className="rounded-lg bg-[#16803a] px-4 py-2.5 font-semibold text-white disabled:opacity-50">{saving ? "Saving…" : nextStandardId ? "Save and continue" : "Save and review for submission"}</button>
        </div>
      </fieldset>
    </form>
    <section className="mt-6 rounded-xl border border-[#dbe5ef] bg-white p-5">
      <h2 className="text-lg font-bold text-[#092a5a]">Recommendations recorded during scoring</h2>
      <p className="mt-2 text-sm text-[#4b5f7a]">All your requirements scored 1 or 2 in this standard, regardless of risk rating. Edit these recommendations in the assessment.</p>
      <div className="mt-4 space-y-4">{recommendations.length ? recommendations.map(item => <article key={item.complianceAssessmentId} className="border-t border-[#dbe5ef] pt-3">
        <Link to={`/surveys/${surveyId}?resume=${item.complianceAssessmentId}${surveyorMode ? "&mode=surveyor" : ""}`} className="font-semibold text-[#16803a]">{item.complianceNumber} · {item.scoreLabel} →</Link>
        <p className="mt-1 text-sm text-[#092a5a]">{item.complianceSummary}</p>
        <p className="mt-2 whitespace-pre-wrap text-sm text-[#4b5f7a]">{item.complianceComments || "No recommendation recorded."}</p>
      </article>) : <p className="text-sm text-[#4b5f7a]">No requirements scored 1 or 2.</p>}</div>
    </section>
    <ConfirmDialog open={removeArea !== null} title="Remove this service / area?" message="Its text will be removed from this form. This takes effect when you save the report." onCancel={() => setRemoveArea(null)} onConfirm={() => { set("serviceAreas", form.serviceAreas.filter((_, index) => index !== removeArea)); setRemoveArea(null); }} />
  </main>;
}

function TextArea({ label, hint, required, value, onChange }) {
  return <label className="block text-sm font-semibold text-[#092a5a]">{label}{required && " *"}{hint && <span className="mt-1 block text-xs font-normal text-[#4b5f7a]">{hint}</span>}<textarea required={required} maxLength={10000} value={value || ""} onChange={event => onChange(event.target.value)} rows={4} className="mt-1.5 w-full resize-y rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm font-normal leading-6 text-[#092a5a] focus:outline-none focus:ring-2 focus:ring-[#16803a]" /></label>;
}
